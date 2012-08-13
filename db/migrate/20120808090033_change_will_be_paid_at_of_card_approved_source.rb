class ChangeWillBePaidAtOfCardApprovedSource < ActiveRecord::Migration
  def up
  	change_column :card_approved_sources, :will_be_paied_at, :date

  end

  def down
  	change_column :card_approved_sources, :will_be_paied_at, :datetime
  end
end
