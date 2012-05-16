class Project < ActiveRecord::Base
  belongs_to :company

  has_many :documents
  has_many :assign_infos, class_name: "ProjectAssignInfo"
  has_many :users, through: :assign_infos

  scope :completed, :conditions =>['ended_on is not null'], :order => "started_on ASC"
  scope :inprogress, :conditions =>['ended_on is null'], :order => "started_on ASC"

  validates_uniqueness_of :name
  validates_numericality_of :revenue

  def completed?
    ! self.ended_on.nil?
  end

  def self.progress_period(year, month)
    start = Time.zone.parse("#{year}-#{month}-01 00:00:00")
    finish = start + 1.month - 1.day

    s = start
    f = finish.dup
    cache = nil

    (0..30).each do |i|
      timestamp = start + i.day
      p = where('? BETWEEN started_on AND ending_on', timestamp)

      if cache != nil && cache.count != p.count
        yield cache, s, timestamp if cache.count > 0
        s = timestamp
      end
      cache = p
    end

    if cache.count > 0
      yield cache, s, f
    end
  end

  def now_processing(period)
    period.between?(started_on, ending_on)
  end

  def assign_rate(user, start, finish)
    start = start.to_date
    finish = finish.to_date

    assign_info = assign_infos.where(user_id: user.id).first
    rates = assign_info.rates.where(start: start, finish: finish)

    unless rates.empty?
      rates.first.percentage
    else
      number_of_project = user.projects.where('(? BETWEEN started_on AND ending_on) AND (? BETWEEN started_on AND ending_on)', start, finish).count
      if number_of_project > 0
        100 / number_of_project
      else
        100
      end
    end
  end

  def self.assign_projects(user, projects)
    start = Date.parse(projects["start"])
    finish = Date.parse(projects["finish"])

    total_percentage = projects["assign"].sum {|info| info[1].to_i}
    return false if total_percentage != 100

    projects["assign"].each do |assign_info|
      project = find(assign_info[0])
      percentage = assign_info[1]

      assign_info = project.assign_infos.where(user_id: user.id).first
      rates = assign_info.rates.where(start: start, finish: finish)
      if rates.empty?
        rate = rates.build
      else
        rate = rates.first
      end

      rate.percentage = percentage
      rate.save!
    end
  end
end



