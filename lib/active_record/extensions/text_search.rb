module ActiveRecord
  module Extensions
    module TextSearch
      extend ActiveSupport::Concern

      module ClassMethods
        def search_by_text(text)
          text = "%#{text}%"

          arel = self.arel_table
          query = self.column_names.map do |column|
            arel[column].matches(text)
          end
          query = query.inject do |result, query|
            result ? result.or(query) : query
          end

          where(query)
        end
      end

      included do
        extend ClassMethods
      end
    end
  end
end