class CompleteAllPreviousReports < ActiveRecord::Migration
  def up
    Report.find_each do |report|
      report.status = :reported
      report.save!
    end
  end

  def down
    Report.find_each do |report|
      report.status = ""
      report.save!
    end
  end
end
