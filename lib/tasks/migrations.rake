namespace :db do
  namespace :report do
    task :reset => :environment do
      account = Account.where(name: ENV['accountname']).first

      Report.find_each do |report|
        puts "reset report: id = #{report.id}, status = #{report.status}, account = #{report.reporter.account.fullname}"

        report.status = :not_reported
        report.reporter.account = account

        report.save!
        report.reporter.save!
      end
    end

    namespace :owner do
      task :reset => :environment do
        Report.find_each do |report|
          reporters = report.reporters
          next if reporters.exists?(owner: true) or !reporters.exists?

          reporter = reporters.first
          puts "reset owner: report = #{report.id}, reporter = #{reporter.id}"
          reporter.owner = true
          reporter.save!
        end
      end
    end
  end

  namespace :cardbill do
    task :reset => :environment do
      account = Account.where(name: ENV['accountname']).first
      Cardbill.find_each do |cardbill|
        cardbill.accessors.destroy_all
        accessor = cardbill.accessors.create!(account_id: account.id, access_type: "write")
        puts "reset cardbill's permission: id = #{cardbill.id}, permission = #{accessor.access_type}, account = #{accessor.account.name}"
      end
    end
  end
end
