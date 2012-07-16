# encoding: UTF-8

class Contact < ActiveRecord::Base
  belongs_to :company
  belongs_to :target, :polymorphic => true
  belongs_to :owner, class_name: 'User'

  REJECT_IF_EMPTY = proc do |attrs|
    attrs.all? {|k, v| ["target", "created_at", "updated_at"].include?(k) or v.blank?}
  end

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

  validate :validate_if_apply
  def validate_if_apply
    if target.class == Enrollment
      errors.add(:address, I18n.t('models.contact.one_more_need_ga')) if addresses.length == 0     # models.contact.one_more_need_ga
      errors.add(:email, I18n.t('models.contact.one_more_need_i')) if emails.length == 0          # models.contact.one_more_need_i
      errors.add(:number, I18n.t('models.contact.one_more_need_ga')) if phone_numbers.length == 0  # models.contact.one_more_need_ga
    end
  end

  def access?(user)
    isprivate == false || owner == user
  end

  def owner?(user)
    owner == user
  end

  def edit?(user)
    user.admin? || owner?(user)
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

    def save_to(google_contact)
      all.each do |resource|
        contact = convert_to_google_contact(google_contact, resource)
        google_contact.save(contact)
        save_from_google_contact(resource, contact)
      end
    end

    def convert_to_google_contact(google_contact, resource)
      attributes = {
        id: resource.google_id,
        etag: resource.google_etag,
        # updated: (node.xpath('./updated').first.content rescue ""),
        # title: (node.xpath('./title').first.content rescue ""),
        given_name: resource.firstname,
        family_name: resource.lastname,
        full_name: resource.name,
        company: resource.company_name,
        position: resource.position,
        emails: resource.emails.all.map do |email|
          {
            label: email.target,
            email: email.email
          }
        end,
        phone_numbers: resource.phone_numbers.all.map do |phone_number|
          {
            label: phone_number.target,
            phone_number: phone_number.number
          }
        end,

        addresses: resource.addresses.all.map do |address|
          {
            label: address.target,
            country: address.country,
            city: address.city,
            region: address.province,
            postcode: address.postal_code,
            formatted: address.info
          }
        end,
        websites: resource.others.all.map do |other|
          {
            label: other.target,
            url: other.description
          }
        end
      }

      OpenApi::GoogleContact::Base.new(attributes)
    end

    def save_from_google_contact(resource, contact)
      resource.isprivate = true

      resource.google_id = contact.id
      resource.google_etag = contact.etag

      resource.firstname = contact.given_name
      resource.lastname = contact.family_name

      resource.company_name = contact.company
      resource.position = contact.position

      resource.emails.clear
      contact.emails.each do |email|
        resource.emails.build({
          target: email[:label],
          email: email[:email]
        })
      end

      resource.phone_numbers.clear
      contact.phone_numbers.each do |number|
        resource.phone_numbers.build({
          target: number[:label],
          number: number[:phone_number]
        })
      end

      resource.addresses.clear
      contact.addresses.each do |address|
        resource.addresses.build({
          target: address[:label],
          country: address[:country],
          city: address[:city],
          province: address[:region],
          postal_code: address[:postcode],
        })
      end

      resource.others.clear
      contact.websites.each do |website|
        resource.others.build({
          target: website[:label],
          description: website[:url],
        })
      end

      resource.save
    end

    def load_from(google_contact)
      google_contact.load.each do |information|
        collection = where(google_id: information.id)
        if collection.empty?
          resource = collection.new
        else
          resource = collection.first
        end

        save_from_google_contact(resource, information)
      end
    end
  end

  def name
    if firstname and lastname
      lastname + " " + firstname
    else
      ""
    end
  end
  def serializable_hash(options={})
    super(options.merge(only: [:id, :firstname, :lastname, :company_name, :department, :position], include: [:emails, :phone_numbers, :addresses]))
  end
end
