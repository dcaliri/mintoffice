class CreateBusinessClient < ActiveRecord::Migration
  def change
    create_table :business_clients do |t|
      t.string :name
      t.string :registration_number
      t.string :category
      t.string :business_status
      t.string :address
      t.string :owner
      t.timestamps
      # 첨부 (사업자등록증)
    end
  end
end
