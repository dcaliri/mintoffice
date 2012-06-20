# encoding: UTF-8

class Contact < ActiveRecord::Base
  belongs_to :company
  belongs_to :target, :polymorphic => true
  belongs_to :owner, class_name: 'User'

  REJECT_IF_EMPTY = proc { |attrs| attrs.all? { |k, v| k != "target" ? v.blank? : true  } }

  has_many :addresses, class_name: 'ContactAddress', :dependent => :destroy
  accepts_nested_attributes_for :addresses, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY

  has_many :emails, class_name: 'ContactEmail', :dependent => :destroy
  accepts_nested_attributes_for :emails, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY

  has_many :phone_numbers, class_name: 'ContactPhoneNumber', :dependent => :destroy
  accepts_nested_attributes_for :phone_numbers, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY

  has_many :others, class_name: 'ContactOther', :dependent => :destroy
  accepts_nested_attributes_for :others, :allow_destroy => :true, :reject_if => REJECT_IF_EMPTY

  self.per_page = 20

  include Historiable
  include Attachmentable
  include Taggable

  def access?(user)
    isprivate == false || owner == user
  end

  def owner?(user)
    owner == user
  end

  def owner_name
    owner.hrinfo.fullname rescue ""
  end

  class << self
    def isprivate(current_user)
      where("isprivate = ? OR owner_id = ?", false, current_user.id)
    end

    def search(query)
      query = "%#{query}%"
      search_by_name(query) | search_by_company_name(query) | search_by_email(query) | search_by_address(query) | search_by_phone_number(query)
    end

    def search_by_name(query)
      where(search_by_name_query, query)
    end

    def search_by_name_query
      if ActiveRecord::Base.connection.adapter_name == 'SQLite'
        "lastname || firstname like ?"
      else
        "CONCAT(lastname, firstname) like ?"
      end
    end

    def search_by_company_name(query)
      where("company_name like ? OR department like ? OR position like ?", query, query, query)
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
