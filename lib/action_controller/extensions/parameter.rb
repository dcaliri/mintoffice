module ActionController
  module Extensions
    module Parameter
      extend ActiveSupport::Concern

      def modify_query_parameter
        [:q, :query].each do |query|
          params[query].strip! if params[query]
        end
      end

      included do
        before_filter :modify_query_parameter
      end
    end
  end
end