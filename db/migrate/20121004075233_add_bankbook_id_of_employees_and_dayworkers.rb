class AddBankbookIdOfEmployeesAndDayworkers < ActiveRecord::Migration
  class ::Employee < ActiveRecord::Base
    has_one :bankbook, as: :holder
  end

  class ::Dayworker < ActiveRecord::Base
    has_one :bankbook, as: :holder
  end

  class ::Bankbook < ActiveRecord::Base
    belongs_to :holder, polymorphic: true
  end

  def up
    add_column :employees, :bankbook_id, :integer
    add_column :dayworkers, :bankbook_id, :integer

    [Employee, Dayworker].each do |class_name|
      class_name.find_each do |resource|
        bankbook = resource.bankbook

        if bankbook
          resource.update_column(:bankbook_id, bankbook.id)
        end
      end
    end
  end

  def down
    remove_column :dayworkers, :bankbook_id
    remove_column :employees, :bankbook_id
  end
end
