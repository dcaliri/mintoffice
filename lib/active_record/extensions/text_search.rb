module ActiveRecord
  module Extensions
    module TextSearch
      extend ActiveSupport::Concern

      module ClassMethods
        def search_by_text(text)
          text = "%#{text}%"

          query = self.column_names.map do |column|
            "`#{self.to_s.tableize.pluralize}`.`#{column}` like ?"
          end

          query = query.join(" OR ")
          parameters = [text] * self.column_names.count

          where(query, *parameters)
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end