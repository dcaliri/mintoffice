module MigrationHelpers
  module ReportMigration
    class Report < ActiveRecord::Base
      belongs_to :target, polymorphic: true
      has_one :reporter, class_name: "ReportPerson"
    end
    class Account < ActiveRecord::Base
      has_one :employee
    end
    class Group < ActiveRecord::Base
      has_and_belongs_to_many :accounts
    end
    class Employee < ActiveRecord::Base
      belongs_to :account
      has_many :reporters, class_name: 'ReportPerson'
    end
    class ReportPerson < ActiveRecord::Base
      belongs_to :employee
      belongs_to :report
    end

    def up_report(class_name)
      account = Group.where(name: "admin").first.accounts.first
      class_name.constantize.find_each do |target|
        report = Report.new
        report.target_type = class_name
        report.target_id = target.id
        report.status = :reported
        report.save!

        reporter = ReportPerson.new(report_id: report.id, employee_id: account.employee.id)
        reporter.save!

        target.save!
      end
    end

    def down_report(class_name)
      Report.where(target_type: class_name).find_each do |report|
        report.reporter.destroy
        report.destroy
      end
    end
  end
end