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

      Prawn::Document.generate(filename, page_layout: options.layout_type, :page_size=> "A4", margin: [10, 10, 30, 10]) do |pdf|
        pdf.font "#{Rails.root}/public/fonts/NanumGothic.ttf"
        pdf.repeat :all do
          pdf.text collections.model_name.human
          pdf.font_size 8

          subtitle = options.subtitle
          subtitle = subtitle.call(collections) if subtitle.respond_to?(:call)

          if options.period
            ordered_collection = collections.where("#{options.period} is not null").order("#{options.period} DESC")
            unless ordered_collection.empty?
              first_paid = ordered_collection.last
              last_paid = ordered_collection.first
              subtitle = "#{first_paid.send(options.period).to_date} ~ #{last_paid.send(options.period).to_date}"
            end
          end

          pdf.draw_text subtitle, :at => [pdf.bounds.right - 100, pdf.bounds.top - 10]

          pdf.font_size 7
        end

        records = collections.all.map do |resource|
                    records = []
                    columns.each do |column|
                      record = resource.send(column)
                      record = record.strftime("%Y-%m-%d(%H:%m:%S)") if record.respond_to?(:strftime)
                      record = number_to_currency(record) if options.krw.include?(column)
                      records << record
                    end
                    records
                  end

        table_data = [localized_columns] + records

        width = pdf.bounds.right
        height = pdf.bounds.top - 40
        pdf.bounding_box [0, height], :width => width, :height => height do
          table = pdf.table(table_data, header: true, :cell_style => {:background_color => "F0B9C8"}, :row_colors => ["F0F0F0", "FFFFCC"]) do |table|
            table.row(0).style(align: :center)
            columns.each_with_index do |column, index|
              columns = table.row(1..-1).column(index)
              if options.krw.include?(column)
                columns.style(align: :right)
              end
              if options.align[:left].include?(column)
                columns.style(align: :left)
              end
              if options.align[:right].include?(column)
                columns.style(align: :right)
              end
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