# encoding: utf-8

class Enrollment < ActiveRecord::Base
  belongs_to :company
  belongs_to :user
  has_one :contact, :as => :target

  has_many :items, class_name: 'EnrollmentItem', dependent: :destroy

  accepts_nested_attributes_for :contact, :allow_destroy => :true

  validates_format_of :juminno, :with => /^\d{6}-\d{7}$/, :message => I18n.t('hrinfos.error.juminno_invalid')
  validates_uniqueness_of :juminno

  include Reportable
  def apply_status
    case report.status
    when :rollback
      "수정 요청"
    else
      "승인 심사중"
    end
  end

  class << self
    def applied
      includes(:report).where("reports.status != 'not_reported'")
    end
  end

  include Rails.application.routes.url_helpers
  def redirect_when_reported
    if user == User.current_user
      [:dashboard, :enrollments]
    else
      enroll_report_path(self)
    end
  end

  def name
    contact.name
  end

  def email
    contact.emails.first.email
  end

  def phone_number
    contact.phone_numbers.first.number
  end

  def address
    contact.addresses.first.info
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
    company.enrollment_items.split(',')
  end
end
