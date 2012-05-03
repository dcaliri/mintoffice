class Commute < ActiveRecord::Base
  belongs_to :user
  belongs_to :attachment

  def self.latest
    order("go DESC")
  end

  def go!
    write_attribute(:go, Time.zone.now)
    save!
  end

  def leave!
    write_attribute(:leave, Time.zone.now)
    save!
  end


  def as_json(options={})
    super(options.merge(:only => [:go, :leave]))
  end

end