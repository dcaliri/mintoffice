class ChangeOwnerTypeOfAttachments < ActiveRecord::Migration
  def change
    Attachment.where(owner_type: "Hrinfo").update_all(:owner_type => 'Employee')
  end
end
