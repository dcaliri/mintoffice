class ReportPerson < ActiveRecord::Base
  belongs_to :person
  belongs_to :report

  has_many :next, class_name: "ReportPerson"
  belongs_to :prev, :class_name => "ReportPerson", :foreign_key => 'prev_id'

  has_many :comments, class_name: "ReportComment"

  class << self
    def access_list(account)
      where(account ? {person_id: account.person.id} : "0")
    end

    def readers
      where(permission_type: [:read, :write])
    end

    def writers
      where(permission_type: :write)
    end

    def by_me
      where(person_id: Person.current_person.id, owner: true)
    end
  end

  def fullname
    person.name rescue ""
  end
end