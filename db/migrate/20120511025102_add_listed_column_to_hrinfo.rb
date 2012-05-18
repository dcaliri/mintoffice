class AddListedColumnToHrinfo < ActiveRecord::Migration
  class Hrinfo < ActiveRecord::Base
  end

  def change
    add_column :hrinfos, :listed, :boolean

    Hrinfo.all.each do |hr|
      hr.listed = true
      hr.save!
    end
  end
end