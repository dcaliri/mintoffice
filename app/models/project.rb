# encoding: UTF-8

class Project < ActiveRecord::Base
  belongs_to :company

  has_many :documents
  has_many :expense_reports

  has_many :assign_infos, class_name: "ProjectAssignInfo"

  scope :completed, :conditions =>['ended_on is not null'], :order => "started_on ASC"
  scope :inprogress, :conditions =>['ended_on is null'], :order => "started_on ASC"

  validates_uniqueness_of :name, scope: :company_id
  validates_numericality_of :revenue

  def employees
    Employee.joins(:project_infos).merge(ProjectAssignInfo.participants_by_project(:employees, self.id))
  end

  def add_employee(employee)
    unless employees.include?(employee)
      ProjectAssignInfo.create!(project_id: id, participant_type: "Employee", participant_id: employee.id)
      true
    else
      false
    end
  end

  def groups
    Group.joins(:project_infos).merge(ProjectAssignInfo.participants_by_project(:groups, self.id))
  end

  def add_group(group)
    unless groups.include?(group)
      ProjectAssignInfo.create!(project_id: id, participant_type: "Group", participant_id: group.id)
      true
    else
      false
    end
  end

  def has_manager_permission?(employee)
    employee.admin? or self.owner == employee
  end

  def change_owner!(employee_id)
    transaction do
      before_owner = self.assign_infos.find_by_owner(true)
      if before_owner
        before_owner.owner = false
        before_owner.save!
      end

      # after_owner = self.assign_infos.find_by_employee_id(employee_id)
      after_owners = self.assign_infos.where(participant_type: "Employee", participant_id: employee_id)
      unless after_owners.empty?
        after_owner = after_owners.first
        after_owner.owner = true
        after_owner.save!
      end
    end
  end

  def owner
    self.assign_infos.find_by_owner(true).participant rescue nil
  end

  def owner_name
    owner.fullname rescue I18n.t('models.project.not')
  end

  def completed?
    ! self.ended_on.nil?
  end

  def self.assign_list(employee)
    joins(:assign_infos).merge(ProjectAssignInfo.projects_by_participant(:employees, employee.id))
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

  def assign_rate(employee, start, finish)
    start = start.to_date
    finish = finish.to_date

    assign_info = assign_infos.where(employee_id: employee.id).first
    rates = assign_info.rates.where(start: start, finish: finish)

    unless rates.empty?
      rates.first.percentage
    else
      number_of_project = employee.projects.where('(? BETWEEN started_on AND ending_on) AND (? BETWEEN started_on AND ending_on)', start, finish).count
      if number_of_project > 0
        100 / number_of_project
      else
        100
      end
    end
  end

  def self.assign_projects(employee, projects)
    start = Date.parse(projects["start"])
    finish = Date.parse(projects["finish"])

    total_percentage = projects["assign"].sum {|info| info[1].to_i}
    return false if total_percentage != 100

    projects["assign"].each do |assign_info|
      project = find(assign_info[0])
      percentage = assign_info[1]

      assign_info = project.assign_infos.where(employee_id: employee.id).first
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



