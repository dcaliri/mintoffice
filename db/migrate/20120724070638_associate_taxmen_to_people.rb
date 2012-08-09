class AssociateTaxmenToPeople < ActiveRecord::Migration
  class ::Taxman < ActiveRecord::Base
    belongs_to :person
  end

  class ::Person < ActiveRecord::Base
    has_one :taxman
  end

  def up
    add_column :taxmen, :person_id, :integer

    Taxman.find_each do |taxman|
      person = Person.create!
      taxman.update_column(:person_id, person.id)
    end
  end

  def down
    Taxman.find_each do |taxman|
      person = Person.find(taxman.person_id)
      person.destroy
    end

    remove_column :taxmen, :person_id
  end
end
