class MakeReportsOfUsedVacations < ActiveRecord::Migration
  # class UsedVacation < ActiveRecord::Base
  #   include Reportable
  # end
  #
  # def up
  #   user = Group.where(name: "admin").first.users.first
  #
  #   execute <<-SQL
  #     INSERT INTO reports (status, target_id, target_type)
  #     SELECT 'not_reported', id, 'UsedVacation'
  #     FROM used_vacations;
  #   SQL
  #
  #   execute <<-SQL
  #     INSERT INTO report_people (user_id, report_id, permission_type, owner, prev_id, created_at, updated_at)
  #     SELECT "#{user.id}", id, "write", "t", "", date('now'), date('now')
  #     FROM reports
  #     WHERE reports.target_type = 'UsedVacation';
  #   SQL
  # end
  #
  # def down
  #   execute <<-SQL
  #     DELETE FROM report_people WHERE report_id IN (SELECT id FROM reports WHERE target_type = "UsedVacation");
  #   SQL
  #
  #   execute <<-SQL
  #     DELETE FROM reports WHERE target_type = "UsedVacation";
  #   SQL
  # end
end
