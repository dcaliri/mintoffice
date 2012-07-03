class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
    	t.integer 	:user_id
    	t.string		:juminno
    	
      t.timestamps
    end
  end
end
