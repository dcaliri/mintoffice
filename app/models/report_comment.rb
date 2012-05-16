class ReportComment < ActiveRecord::Base
  belongs_to :report
  belongs_to :owner, class_name: 'ReportPerson'

  def self.lastest
    order('created_at DESC')
  end
end