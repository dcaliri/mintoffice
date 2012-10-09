# encoding: UTF-8

class Asset < ActiveRecord::Base
  belongs_to :owner, class_name: 'Employee', foreign_key: 'owner_id'

  include Historiable
  def history_info
    {
      :owner_id => proc do |asset, value|
        Employee.find_by_id(value).fullname rescue "없음"
      end
    }
  end

  class << self
    def by_owner(condition)
      if condition
        table = arel_table
        where(table[:owner_id].not_eq(nil))
      else
        where(owner_id: nil)
      end
    end
  end

  def return!
    update_column(:owner_id, nil)
  end

  def owner_name
    owner.fullname rescue ""
  end
end