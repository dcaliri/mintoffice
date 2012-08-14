class CreateVacationType < ActiveRecord::Migration
  def change
    create_table :vacation_types do |t|
      t.string :title
      t.timestamps
    end

    create_table :vacation_type_infos do |t|
      t.references :used_vacation
      t.references :vacation_type
      t.timestamps
    end
  end
end
