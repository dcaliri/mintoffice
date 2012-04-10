class CreateTaxbills < ActiveRecord::Migration
  def change
    create_table :taxbills do |t|
      t.string :billtype
      t.datetime :transacted_at
      t.references :taxmans
      t.timestamps
    end
  end
end
