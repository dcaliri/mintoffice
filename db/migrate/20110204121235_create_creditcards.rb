class CreateCreditcards < ActiveRecord::Migration
  def self.up
    create_table :creditcards do |t|
      t.string :cardno
      t.string :expireyear
      t.string :expiremonth
      t.string :nickname
      t.string :issuer
      t.string :cardholder

      t.timestamps
    end
  end

  def self.down
    drop_table :creditcards
  end
end
