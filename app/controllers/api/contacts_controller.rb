module Api
  class ContactsController < Api::ApplicationController
    expose(:contacts) { current_company.contacts }
    expose(:contacts) { Contact.where("") }

    before_filter :find_account
    respond_to :json

    def index
      @contacts = contacts.isprivate(current_person)
      render :json => {:status => :ok, :contacts => @contacts}
    end

    def create
      @contact = contacts.where(owner_id: current_person.id).build(params[:contact])
      @contact.save!
      render :json => {:status => :ok, :contact => @contact}
    rescue => e
      render :json => {:status => :invalid, errors: e.message}
    end

    def update
      @contact = contacts.find(params[:id])
      @contact.update_attributes!(params[:contact])
      render :json => {:status => :ok, :contact => @contact}
    rescue => e
      render :json => {:status => :invalid, errors: e.message}
    end
  end
end

# curl "http://mintoffice.dev/api/login.json?account=admin&password=1234"
# curl -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://mintoffice.dev/api/contacts"
# curl -X POST -H "Content-Type: application/json" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://mintoffice.dev/api/contacts" -d '{"contact":{"firstname":"Sunghee", "lastname": "Kang", "emails_attributes":{"0": {"email":"contact@example.com", "target":"home"}}, "phone_numbers_attributes":{"0": {"number": "010-1234-5678", "target": "comapny"}}}}'
# curl -X PUT -H "Content-Type: application/json" -H "api-key: c389b8fd0716c0db8c8f8b7da0c1255c21cdb47f" "http://mintoffice.dev/api/contacts/70" -d '{"contact":{"firstname":"Sunghee2", "lastname": "Kang2", "emails_attributes":{"0": {"email":"contact@example.com", "target":"home", "id":"101"}}, "phone_numbers_attributes":{"0": {"number": "010-2345-6789", "target": "comapny", "id":"83"}}}}'
