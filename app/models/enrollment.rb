# encoding: utf-8

class Enrollment < ActiveRecord::Base
  belongs_to :company
  belongs_to :user
  has_one :contact, :as => :target

  has_many :items, class_name: 'EnrollmentItem', dependent: :destroy

  accepts_nested_attributes_for :contact, :allow_destroy => :true

  def information_filled?(item_field)
    if item_field == :basic
      contact.present?
    else
      items.exists?(name: item_field)
    end
  end

  def item_required?(item_field)
    required_items.include? item_field
  end

  def find_or_create_custom_item(name)
    if item = self.items.find_by_name(name)
      item
    else
      self.items.create!(name: name)
    end
  end

  def required_items
    company.enrollment_items.split(',')
  end

  def item_fields
    (required_items + items.all.map{|item| item.name}).uniq
  end
end
