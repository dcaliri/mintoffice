class ReportPerson < ActiveRecord::Base
  # belongs_to :account
  # belongs_to :hrinfo
  belongs_to :person
  belongs_to :report

  has_many :next, class_name: "ReportPerson"
  belongs_to :prev, :class_name => "ReportPerson", :foreign_key => 'prev_id'

  has_many :comments, class_name: "ReportComment"

  class << self
    def access_list(account)
      # where(account ? {account_id: account.id} : "0")
      # where(account ? {hrinfo_id: account.hrinfo.id} : "0")
      where(account ? {person_id: account.person.id} : "0")
    end

    def readers
      where(permission_type: [:read, :write])
    end

    def writers
      where(permission_type: :write)
    end

    def by_me
      where(person_id: Account.current_account.person.id, owner: true)
    end
  end

  def fullname
    hrinfo.fullname rescue ""
  end
end