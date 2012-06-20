module Api
  class ContactsController < Api::ApplicationController
    expose(:contacts) { current_company.contacts }
    expose(:contacts) { Contact.where("") }

    before_filter :find_user
    respond_to :json

    def index
      @contacts = contacts.isprivate(@user)
      render :json => {:status => :ok, :contacts => @contacts}
    end
  end
end

# curl "http://mintoffice.dev/api/login.json?user=admin&password=1234"
# curl -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://mintoffice.dev/api/contacts"
