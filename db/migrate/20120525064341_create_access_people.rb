class CreateAccessPeople < ActiveRecord::Migration
  def up
    create_table :access_people do |t|
      t.references :user
      t.references :access_target, polymorphic: true
      t.string :access_type, default: "read"
      t.timestamps
    end

    ReportPerson.find_each do |person|
      if person.report
        person.report.accessors.create!(user_id: person.user.id, access_type: person.permission_type)
      end
    end
  end

  def down
    AccessPerson.destroy_all
    drop_table :access_people
  end
end
