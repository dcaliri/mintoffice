# encoding: UTF-8

class Contact < ActiveRecord::Base
  belongs_to :target, :polymorphic => true

  REJECT_IF_EMPTY = proc { |attrs| attrs.all? { |k, v| k != "target" ? v.blank? : true  } }

  has_many :addresses, class_name: 'ContactAddress', :dependent => :destroy
  accepts_nested_attributes_for :addresses, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY

  has_many :emails, class_name: 'ContactEmail', :dependent => :destroy
  accepts_nested_attributes_for :emails, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY

  has_many :phone_numbers, class_name: 'ContactPhoneNumber', :dependent => :destroy
  accepts_nested_attributes_for :phone_numbers, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY

  class << self
    def search(query)
      query = "%#{query || ""}%"
      search_by_name(query) | search_by_company(query) | search_by_email(query) | search_by_address(query) | search_by_phone_number(query)
    end

    def search_by_name(query)
      # if ActiveRecord::Base.connection.class == ActiveRecord::ConnectionAdapters::SQLite3Adapter
      #   where("firstname || lastname like ?", query)
      # else
      #   where("CONCAT(firstname, lastname) like ?", query)
      # end
      where(search_by_name_query, query)
    end

    def search_by_name_query
      if ActiveRecord::Base.connection.class == ActiveRecord::ConnectionAdapters::SQLite3Adapter
        "firstname || lastname like ?"
      else
        "CONCAT(firstname, lastname) like ?"
      end
    end

    def search_by_company(query)
      where("company like ? OR department like ? OR position like ?", query, query, query)
    end

    def search_by_email(query)
      joins(:emails).merge(ContactEmail.search(query))
    end

    def search_by_phone_number(query)
      joins(:phone_numbers).merge(ContactPhoneNumber.search(query))
    end

    def search_by_address(query)
      joins(:addresses).merge(ContactAddress.search(query))
    end
  end

  def name
    if firstname and lastname
      lastname + " " + firstname
    else
      ""
    end
  end
end