class ReportPerson < ActiveRecord::Base
  belongs_to :user
  belongs_to :report

  has_many :next, class_name: "ReportPerson"
  belongs_to :prev, :class_name => "ReportPerson", :foreign_key => 'prev_id'

  has_many :comments, class_name: "ReportComment"

  def self.access_list(user)
    where(user ? {user_id: user.id} : "0")
  end

  def fullname
    user.name
  end
end