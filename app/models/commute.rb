# encoding: UTF-8

class Commute < ActiveRecord::Base
  belongs_to :employee

  validate :check_unique_date, on: :create
  def check_unique_date
    errors.add(:go, I18n.t('commutes.error.already_created')) if employee.commutes.exists?(go: Time.now.all_day)
  end

  include Attachmentable

  def self.latest
    order("go DESC")
  end

  def self.every_during(days)
    commutes_by_employee_id = {}
    where(go: days).select("DISTINCT employee_id").collect(&:employee_id).each do |employee_id|
      commutes_by_employee_id[employee_id] = Employee.find(employee_id).commutes.during(days)
    end
    commutes_by_employee_id
  end

  def self.during(days)
    commutes = where(go: days).order("go ASC")
    commutes_hash = {}
    days.begin.to_date.step(days.end.to_date,1) do |day|
      commutes_hash[day] = commutes.to_a.select {|commute| commute.go.to_date === day }.first
    end
    commutes_hash
  end

  def go!
    write_attribute(:go, Time.now)
    save!
    # Boxcar.send_to_boxcar_group("admin",self.employee.fullname, "#{Commute.human_attribute_name('go')} : #{self.go.strftime("%Y-%m-%d %H:%M")}")
  end

  def leave!
    write_attribute(:leave, Time.now)
    save!
    # Boxcar.send_to_boxcar_group("admin",self.employee.fullname, "#{Commute.human_attribute_name('leave')} : #{self.leave.strftime("%Y-%m-%d %H:%M")}")
  end

  def as_json(options={})
    super(options.merge(:only => [:go, :leave]))
  end
end














