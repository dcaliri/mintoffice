class AddAttachmentIdToBusinessClient < ActiveRecord::Migration
  def change
    add_column :business_clients, :attachment_id, :integer
  end
end
