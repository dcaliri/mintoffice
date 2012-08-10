class MigrateOwnerIdOfContacts < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE contacts
      SET owner_id = (SELECT users.person_id
      FROM users
      WHERE users.id = contacts.owner_id)
    SQL
  end
  
  def down
    execute <<-SQL
      UPDATE contacts
      SET owner_id = (SELECT users.id
      FROM users
      WHERE users.person_id = contacts.owner_id)
    SQL
  end
end