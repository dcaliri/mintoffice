module ActionController
  module Extensions
    module Title
      extend ActiveSupport::Concern

      def title(text="")
        unless text.blank?
          @title = text
        else
          @title || t("#{controller_name}.title")
        end
      end

      included do
        helper_method :title
      end
    end
  end
end