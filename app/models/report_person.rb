class ReportPerson < ActiveRecord::Base
  # belongs_to :user
  belongs_to :hrinfo
  belongs_to :report

  has_many :next, class_name: "ReportPerson"
  belongs_to :prev, :class_name => "ReportPerson", :foreign_key => 'prev_id'

  has_many :comments, class_name: "ReportComment"

  class << self
    def access_list(user)
      # where(user ? {user_id: user.id} : "0")
      where(user ? {hrinfo_id: user.hrinfo.id} : "0")
    end

    def readers
      where(permission_type: [:read, :write])
    end

    def writers
      where(permission_type: :write)
    end

    def by_me
      where(hrinfo_id: User.current_user.hrinfo.id, owner: true)
    end
  end

  def fullname
    hrinfo.fullname rescue ""
  end
end