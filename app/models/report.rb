class Report < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :reportee, class_name: "Hrinfo"
  belongs_to :reporter, class_name: "Hrinfo"

  def status
    status = read_attribute(:status)
    status ? status.to_sym : :not_reported
  end
end