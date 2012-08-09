# encoding: utf-8

class Enrollment < ActiveRecord::Base
  belongs_to :company
  belongs_to :person
  accepts_nested_attributes_for :person, :allow_destroy => :true

  has_many :items, class_name: 'EnrollmentItem', dependent: :destroy

  validates_format_of :juminno, :with => /^\d{6}-\d{7}$/, :message => I18n.t('employees.error.juminno_invalid'), on: :update
  validates_uniqueness_of :juminno, on: :update

  def contact
    person.contact
  end

  include Reportable

  def apply_status
    case report.status
    when :rollback
      I18n.t('models.employee.request')
    when :reported
      I18n.t('models.employee.approved')
    else
      I18n.t('models.employee.approving')
    end
  end

  class << self
    def applied
      includes(:report).where("reports.status != 'not_reported'")
    end
  end

  def account
    person.account
  end

  include Rails.application.routes.url_helpers
  def redirect_when_reported
    if person == Person.current_person
      [:dashboard, :enrollments]
    else
      enroll_report_path(self)
    end
  end

  def name
    contact.name
  end

  def email
    contact.emails.first.email rescue ""
  end

  def phone_number
    contact.phone_numbers.first.number rescue ""
  end

  def address
    contact.addresses.first.info rescue ""
  end

  def find_or_create_item_by_name(name)
    item = self.items.find_by_name(name)
    if item
      item
    else
      self.items.create!(name: name)
    end
  end

  def modify?
    [:not_reported, :rollback].include? report.status
  end

  def all_information_filled?
    ([:basic] + required_items).all?{|item| information_filled?(item)}
  end

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

  def item_names
    (required_items + items.all.map{|item| item.name}).uniq
  end

  def required_items
    items = company.enrollment_items || ""
    items.split(',')
  end
end
