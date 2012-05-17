module MigrationHelpers
  module ReportMigration
    class Report < ActiveRecord::Base
      belongs_to :target, polymorphic: true
      has_one :reporter, class_name: "ReportPerson"
    end
    class User < ActiveRecord::Base
      has_one :hrinfo
    end
    class Group < ActiveRecord::Base
      has_and_belongs_to_many :users
    end
    class Hrinfo < ActiveRecord::Base
      belongs_to :user
      has_many :reporters, class_name: 'ReportPerson'
    end
    class ReportPerson < ActiveRecord::Base
      belongs_to :hrinfo
      belongs_to :report
    end

    def up_report(class_name)
      user = Group.where(name: "admin").first.users.first
      class_name.constantize.find_each do |target|
        report = Report.new
        report.target_type = class_name
        report.target_id = target.id
        report.status = :reported
        report.save!

        reporter = ReportPerson.new(report_id: report.id, hrinfo_id: user.hrinfo.id)
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