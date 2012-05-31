module ResourceExportable
  class PdfExporter
    attr_accessor :collections
    attr_accessor :options

    def initialize(collections, opts)
      self.collections = collections
      self.options = OpenStruct.new(opts)
    end

    def export
      filename = options.filename
      columns = options.columns
      localized_columns = divide(columns.map{|column| collections.human_attribute_name(column)})

      ::Prawn::Document.generate(filename, page_layout: :landscape) do |pdf|
        pdf.font "#{Rails.root}/public/fonts/NanumGothic.ttf"
        pdf.text collections.model_name.human

        pdf.font_size 7
        records = collections.all.map do |resource|
                    records = columns.map do |column|
                                record = resource.send(column)
                                record = record.strftime("%Y-%m-%d(%H:%m:%S)") if record.respond_to?(:strftime)
                                record
                              end
                    divide(records)
                  end

        table_data = localized_columns + records.flatten(1)

        table = pdf.table(table_data) do |table|
          0.upto(1) do |row|
            table.row(row).style(:background_color => 'DDDDDD', :size => 9)
          end
          2.upto(table.row_length-1) do |row|
            color = (row % 4) < 2 ? 'F0F0F0' : "FFFFCC"
            table.row(row).style(:background_color => color)
          end
        end
      end

      filename
    end

    private
      def divide(columns)
        half = (columns.length.to_f / 2).round - 1
        [columns[0..half], columns[half+1..-1]]
      end
  end
end