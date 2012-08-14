class AssociateEnrollmentsToPeople < ActiveRecord::Migration
  class ::User < ActiveRecord::Base
    belongs_to :person
  end

  class ::Person < ActiveRecord::Base
    has_one :user
  end

  class ::Enrollment < ActiveRecord::Base
    belongs_to :person
  end

  def up
    add_column :enrollments, :person_id, :integer

    Enrollment.find_each do |enrollment|
      user = User.find(enrollment.user_id)
      person = Person.find(user.person_id)

      enrollment.update_column(:person_id, person.id)
    end

    remove_column :enrollments, :user_id
  end

  def down
    add_column :enrollments, :user_id, :integer

    Enrollment.find_each do |enrollment|
      person = Person.find(enrollment.person_id)
      user = User.find_by_person_id(person.id)

      enrollment.update_column(:user_id, user.id)
    end

    remove_column :enrollments, :person_id
  end
end
