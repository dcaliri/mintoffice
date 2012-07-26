module ActionController
  module Extensions
    module AuthorizeAndAccess
      extend ActiveSupport::Concern

      def authorize
        redirect_unless_logged_in
        redirect_unless_permission if current_account
      end

      def redirect_unless_logged_in
        if current_account.nil? or current_account.not_joined?
          redirect_to accounts_login_path
        end
      end

      def redirect_unless_permission
        unless Permission.can_access? current_account, controller_name, action_name
          force_redirect
        end
      end

      def redirect_unless_admin
        unless current_account.admin?
          force_redirect 
        end
      end

      def redirect_unless_me(account)
        unless current_account.ingroup? "admin"
          force_redirect unless current_account == account
        end
      end

      def access_check
        model_name = (controller_name.singularize.classify).constantize
        model = model_name.find(params[:id])
        force_redirect unless model.access?(current_account)
      end
  
      def force_redirect
        flash[:notice] = "You don't have to permission"
        redirect_to :root
      end

      included do
        before_filter :authorize
      end
    end
  end
end