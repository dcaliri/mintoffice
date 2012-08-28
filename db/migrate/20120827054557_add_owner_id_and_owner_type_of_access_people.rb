class AddOwnerIdAndOwnerTypeOfAccessPeople < ActiveRecord::Migration
  def change
    add_column :access_people, :owner_type, :string
    AccessPerson.update_all(owner_type: "Person")

    rename_column :access_people, :person_id, :owner_id
  end
end
