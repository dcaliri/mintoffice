class Project < ActiveRecord::Base
  has_many :documents
  has_many :assign_infos, class_name: "ProjectAssignInfo"
  has_many :users, through: :assign_infos

  # named_scope :completed, :conditions =>['ended_on is not null'], :order => "started_on ASC"
  # named_scope :inprogress, :conditions =>['ended_on is null'], :order => "started_on ASC"

  scope :completed, :conditions =>['ended_on is not null'], :order => "started_on ASC"
  scope :inprogress, :conditions =>['ended_on is null'], :order => "started_on ASC"

  validates_uniqueness_of :name
  validates_numericality_of :revenue

  def completed?
    ! self.ended_on.nil?
  end

  def self.in_progress_period
    start = order('started_on ASC').first.started_on
    finish = order('ending_on DESC').last.ending_on
    period = start.dup
    while period.month <= finish.month
      yield period
      period += 1.month
    end
  end

  def now_processing(period)
    period.between?(started_on, ending_on)
  end

  def assign_rate(user, period)
    100
    assign_info = assign_infos.where(user_id: user.id).first
    assign_info.rate(period)
  end
end
