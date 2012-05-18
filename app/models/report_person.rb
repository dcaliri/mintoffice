class ReportPerson < ActiveRecord::Base
  belongs_to :hrinfo
  belongs_to :report

  has_many :next, class_name: "ReportPerson"
  belongs_to :prev, :class_name => "ReportPerson", :foreign_key => 'prev_id'

  has_many :comments, class_name: "ReportComment"

  def self.access_list(user)
    hrinfo = user.hrinfo
    where(hrinfo ? {hrinfo_id: hrinfo.id} : "0")
  end

  def fullname
    hrinfo.fullname
  end
end