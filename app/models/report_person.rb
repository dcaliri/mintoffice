class ReportPerson < ActiveRecord::Base
  belongs_to :hrinfo
  belongs_to :report

  has_many :next, class_name: "ReportPerson"
  belongs_to :prev, :class_name => "ReportPerson", :foreign_key => 'prev_id'

  has_many :comments, class_name: "ReportComment"

  def fullname
    hrinfo.fullname
  end
end