# encoding: UTF-8

class Commute < ActiveRecord::Base
  belongs_to :user

  validate :check_unique_date
  def check_unique_date
    errors.add(:go, "이 이미 생성되었습니다.") if user.commutes.exists?(go: Time.zone.now.all_day)
  end

  include Attachmentable

  def self.latest
    order("go DESC")
  end

  def go!
    write_attribute(:go, Time.zone.now)
    save!
    Boxcar.send_to_boxcar_group("admin",self.user.hrinfo.fullname, "#{Commute.human_attribute_name('go')} : #{self.go.strftime("%Y-%m-%d %H:%M")}")
  end

  def leave!
    write_attribute(:leave, Time.zone.now)
    save!
    Boxcar.send_to_boxcar_group("admin",self.user.hrinfo.fullname, "#{Commute.human_attribute_name('leave')} : #{self.leave.strftime("%Y-%m-%d %H:%M")}")
  end


  def as_json(options={})
    super(options.merge(:only => [:go, :leave]))
  end

end