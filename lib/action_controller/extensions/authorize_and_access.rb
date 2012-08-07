module ActionController
  module Extensions
    module AuthorizeAndAccess
      extend ActiveSupport::Concern

      def authorize
        redirect_unless_logged_in and redirect_unless_permission
      end

      def redirect_unless_logged_in
        if current_person.nil? or current_person.not_joined?
          redirect_to login_accounts_path
          false
        else
          true
        end
      end

      def redirect_unless_permission
        unless Permission.can_access? current_person, controller_name, action_name
          force_redirect
        end
      end

      def redirect_unless_admin
        unless current_person.admin?
          force_redirect
        end
      end

      def redirect_unless_me(employee)
        unless current_person.admin?
          force_redirect unless current_person.employee.id == employee.id
        end
      end

      def access_check
        model_name = (controller_name.singularize.classify).constantize
        model = model_name.find(params[:id])
        force_redirect unless model.access?(current_person)
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