namespace :db do
  namespace :report do
    task :reset => :environment do
      user = User.where(name: ENV['username']).first

      Report.find_each do |report|
        puts "reset report: id = #{report.id}, status = #{report.status}, user = #{report.reporter.user.fullname}"

        report.status = :not_reported
        report.reporter.user = user

        report.save!
        report.reporter.save!
      end
    end
  end
end
