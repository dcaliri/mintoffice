module ResourceExportable
  class PdfExporter
    include ActionView::Helpers::NumberHelper

    attr_accessor :collections
    attr_accessor :filename
    attr_accessor :columns
    attr_accessor :options

    def initialize(collections, filename, columns, opts)
      self.collections = collections
      self.filename = filename
      self.columns = columns
      self.options = OpenStruct.new(opts)
    end

    def export
      filename = self.filename
      columns = self.columns
      localized_columns = divide(columns.map{|column| collections.human_attribute_name(column)})

      Prawn::Document.generate(filename, page_layout: options.layout_type) do |pdf|
        pdf.font "#{Rails.root}/public/fonts/NanumGothic.ttf"
        pdf.text collections.model_name.human

        pdf.font_size 7
        records = collections.all.map do |resource|
                    records = []
                    columns.each_with_index do |column, index|
                      record = resource.send(column)
                      record = record.strftime("%Y-%m-%d(%H:%m:%S)") if record.respond_to?(:strftime)
                      record = number_to_currency(record) if options.money.include?(index)
                      records << record
                    end
                    divide(records)
                  end

        table_data = localized_columns + records.flatten(1)

        table = pdf.table(table_data) do |table|
          0.upto(default_row - 1) do |row|
            table.row(row).style(:background_color => 'DDDDDD', :size => 9)
          end
          (default_row).upto(table.row_length-1) do |row|
            color = (row % (default_row*2)) < default_row ? 'F0F0F0' : "FFFFCC"
            table.row(row).style(:background_color => color)

            options.money.each do |column|
              current_column = table.row(row).column(column)
              table.row(row).column(column).style(align: :right)
            end
          end
        end
      end

      filename
    end

    private
      def default_row
        options.row_length
      end

      def divide(columns)
        if default_row == 1
          [columns]
        else
          half = (columns.length.to_f / 2).round - 1
          [columns[0..half], columns[half+1..-1]]
        end
      end
  end
end