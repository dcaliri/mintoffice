class Commute < ActiveRecord::Base
  belongs_to :user
  belongs_to :attachment

  def go!
    unless read_attribute(:go)
      write_attribute(:go, Time.zone.now)
      save!
    else
      raise ActiveRecord::RecordInvalid
    end
  end

  def leave!
    unless read_attribute(:leave)
      write_attribute(:leave, Time.zone.now)
      save!
    else
      raise ActiveRecord::RecordInvalid
    end
  end
end