class CreatePeople < ActiveRecord::Migration
  class ::User < ActiveRecord::Base
    belongs_to :person
  end

  class ::Person < ActiveRecord::Base
    has_one :user
  end

  class ::Hrinfo < ActiveRecord::Base
    belongs_to :person
  end


  def up
    create_table :people do |t|
      t.timestamp
    end

    add_column :hrinfos, :person_id, :integer
    add_column :users, :person_id, :integer

    User.find_each do |user|
      people = Person.create!
      user.update_column(:person_id, people.id)

      hrinfo = Hrinfo.find_by_user_id(user.id)
      hrinfo.update_column(:person_id, people.id) if hrinfo
    end

    Hrinfo.find_each do |hrinfo|
      next if hrinfo.person_id

      people = Person.create!
      hrinfo.update_column(:person_id, people.id)
    end

    remove_column :hrinfos, :user_id
  end

  def down
    add_column :hrinfos, :user_id, :integer

    Person.find_each do |people|
      hrinfo = Hrinfo.find_by_person_id(people.id)
      user = User.find_by_person_id(people.id)

      hrinfo.update_column(:user_id, user.id) if hrinfo
    end

    remove_column :hrinfos, :person_id
    remove_column :users, :person_id

    drop_table :people
  end
end
