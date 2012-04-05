class AddTableNameToAttachment < ActiveRecord::Migration
  def self.up
    add_column :attachments, :owner_table_name, :string
    add_column :attachments, :owner_id, :integer
    
    Cardbill.all.each do |cardbill|
      next if ! cardbill.attachment
      puts "here"
      cardbill.attachment.owner_table_name = Cardbill.table_name
      cardbill.attachment.owner_id = cardbill.id
      cardbill.attachment.save
    end
    
    Pettycash.all.each do |pettycash|
      next if ! pettycash.attachment
      pettycash.attachmeht.owner_table_name = Pettycash.table_name
      pettycash.attachment.owner_id = pettycash.id
      pettycash.attachment.save
    end
  end

  def self.down
    remove_column :attachments, :owner_id
    remove_column :attachments, :owner_table_name
  end
end