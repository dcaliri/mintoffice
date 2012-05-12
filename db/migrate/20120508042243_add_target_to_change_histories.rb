class AddTargetToChangeHistories < ActiveRecord::Migration
  def change
    add_column :change_histories, :target, :string
  end
end
