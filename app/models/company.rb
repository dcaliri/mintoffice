class Company < ActiveRecord::Base
  has_many :projects
  has_many :documents
  has_many :business_clients
  has_many :contacts
  has_many :contact_address_tags
  has_many :contact_email_tags
  has_many :contact_phone_number_tags
  has_many :contact_other_tags
  has_many :tags

  belongs_to :apply_admin, class_name: 'User'

  cattr_accessor :current_company

  include Attachmentable

  def seal
    unless attachments.empty?
      "#{Rails.root}/files/#{attachments.first.filepath}"
    else
      ""
    end
  end
end