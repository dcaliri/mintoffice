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

  namespace :cardbill do
    task :reset => :environment do
      user = User.where(name: ENV['username']).first
      Cardbill.find_each do |cardbill|
        cardbill.accessors.destroy_all
        accessor = cardbill.accessors.create!(user_id: user.id, access_type: "write")
        puts "reset cardbill's permission: id = #{cardbill.id}, permission = #{accessor.access_type}, user = #{accessor.user.name}"
      end
    end
  end
end
