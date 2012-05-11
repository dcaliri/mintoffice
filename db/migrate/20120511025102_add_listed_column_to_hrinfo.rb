class AddListedColumnToHrinfo < ActiveRecord::Migration
  def change
    add_column :hrinfos, :listed, :boolean
    
    Hrinfo.all.each do |hr|
      hr.listed = true
      hr.save!
    end
  end
end