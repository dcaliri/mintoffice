class MakeReportsOfUsedVacations < ActiveRecord::Migration
  class UsedVacation < ActiveRecord::Base
    include Reportable
  end

  def up
    user = Group.where(name: "admin").first.users.first
    UsedVacation.find_each do |target|
      report = Report.new
      report.target_type = "UsedVacation"
      report.target_id = target.id
      report.status = :not_reported
      report.save!

      reporter = ReportPerson.new(report_id: report.id, user_id: user.id, permission_type: :write, owner: true)
      reporter.save!

      target.save!
    end
  end

  def down
    Report.where(target_type: "UsedVacation").find_each do |report|
      report.destroy
    end
  end
end
