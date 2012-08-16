module ActiveRecord
  module Extensions
    module TextSearch
      extend ActiveSupport::Concern

      module ClassMethods
        def search_by_text(text)
          text = "%#{text}%"

          arel = self.arel_table
          query = self.column_names.map do |column|
            type = self.columns_hash[column.to_s].type
            if type == :text or type == :string
              arel[column].matches(text)
            end
          end

          query.delete(nil)

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