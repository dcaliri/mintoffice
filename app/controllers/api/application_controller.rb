module Api
  class ApplicationController < ::ApplicationController
    skip_before_filter :authorize
    skip_before_filter :verify_authenticity_token

    before_filter :find_account

    def current_account
      @current_account ||= Account.find_by_api_key(request.env['HTTP_API_KEY'])
    end

    def current_person
      current_account.person if current_account
    end
    helper_method :current_person

    def current_employee
      current_person.employee if current_person
    end
    helper_method :current_employee

    protected
    def find_account
      if current_account
        Person.current_person = current_person
      else
        render :json => {:status => :api_key_wrong}
      end
    end
  end
end