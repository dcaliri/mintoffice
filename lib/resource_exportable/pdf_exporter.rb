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
      localized_columns = columns.map{|column| collections.human_attribute_name(column)}

      ::Prawn::Document.generate(filename) do |pdf|
        pdf.font "/System/Library/Fonts/AppleGothic.ttf"
        pdf.text collections.model_name.human

        pdf.font_size 7
        records = collections.all.map do |resource|
                    columns.map do |column|
                      record = resource.send(column)
                      record = record.strftime("%Y-%m-%d(%H:%m:%S)") if record.respond_to?(:strftime)
                      record
                    end
                  end

        table_data = [localized_columns] + records
        pdf.table table_data, header: true, row_colors: ["F0F0F0", "FFFFCC"] do |table|
          table.row(0).style(:background_color => 'dddddd', :size => 9)
        end
      end

      filename
    end
  end
end