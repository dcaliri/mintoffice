class AddCompanynoToHrinfos < ActiveRecord::Migration
  def self.up
    add_column :hrinfos, :companyno, :integer
    add_index :hrinfos, :companyno, :unique => true
  end

  def self.down
    remove_column :hrinfos, :companyno
    remove_index :hrinfos, :column => :companyno
  end
end