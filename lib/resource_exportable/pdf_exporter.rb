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
      localized_columns = columns.map{|column| collections.human_attribute_name(column)}

      Prawn::Document.generate(filename, page_layout: options.layout_type) do |pdf|
        pdf.font "#{Rails.root}/public/fonts/NanumGothic.ttf"
        pdf.repeat :all do
          pdf.text collections.model_name.human
          pdf.font_size 8

          subtitle = options.subtitle
          subtitle = subtitle.call(collections) if subtitle.respond_to?(:call)
          pdf.draw_text subtitle, :at => [pdf.bounds.right - 100, pdf.bounds.top - 10]

          pdf.font_size 7
        end

        records = collections.all.map do |resource|
                    records = []
                    columns.each_with_index do |column, index|
                      record = resource.send(column)
                      record = record.strftime("%Y-%m-%d(%H:%m:%S)") if record.respond_to?(:strftime)
                      record = number_to_currency(record) if options.money.include?(index)
                      records << record
                    end
                    records
                  end

        table_data = [localized_columns] + records

        width = pdf.bounds.right
        height = pdf.bounds.top - 40
        pdf.bounding_box [0, height], :width => width, :height => height do
          table = pdf.table(table_data, header: true, :cell_style => {:background_color => "F0B9C8"}, :row_colors => ["F0F0F0", "FFFFCC"]) do |table|
            options.money.each do |column|
              current_column = table.row(row).column(column)
              table.row(row).column(column).style(align: :right)
            end
          end
        end

        pdf.number_pages "<page> / <total>",
                          :at => [pdf.bounds.right - 100, 0],
                          :align => :right,
                          :size => 14
      end

      filename
    end

    private
  end
end