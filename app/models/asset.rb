class Asset < ActiveRecord::Base
  belongs_to :owner, class_name: 'Employee', foreign_key: 'owner_id'

  def return!
    update_column(:owner_id, nil)
  end

  def owner_name
    owner.fullname rescue ""
  end
end