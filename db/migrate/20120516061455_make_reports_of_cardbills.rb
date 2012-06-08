class MakeReportsOfCardbills < ActiveRecord::Migration
  # class Cardbill < ActiveRecord::Base
  #   has_one :report, as: :target
  # end
  # class Report < ActiveRecord::Base
  #   belongs_to :target, polymorphic: true
  #   has_one :reporter, class_name: "ReportPerson"
  # end
  # class User < ActiveRecord::Base
  #   has_one :hrinfo
  # end
  # class Group < ActiveRecord::Base
  #   has_and_belongs_to_many :users
  # end
  # class Hrinfo < ActiveRecord::Base
  #   belongs_to :user
  #   has_many :reporters, class_name: 'ReportPerson'
  # end
  # class ReportPerson < ActiveRecord::Base
  #   belongs_to :hrinfo
  #   belongs_to :report
  # end
  #
  # def up
  #   add_column :cardbills, :before_report, :boolean
  #   user = Group.where(name: "admin").first.users.first
  #
  #   Cardbill.find_each do |cardbill|
  #     cardbill.before_report = true
  #
  #     report = Report.new
  #     report.target_type = "Cardbill"
  #     report.target_id = cardbill.id
  #     report.status = :reported
  #     report.save!
  #
  #     reporter = ReportPerson.new(report_id: report.id, hrinfo_id: user.hrinfo.id)
  #     reporter.save!
  #
  #     cardbill.save!
  #   end
  # end
  #
  # def down
  #   Report.destroy_all
  #   ReportPerson.destroy_all
  #
  #   remove_column :cardbills, :before_report
  # end
end



