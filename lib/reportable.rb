module Reportable
  extend ActiveSupport::Concern

  def create_initial_report
    unless self.report
      report = build_report
      report.reporters << Person.current_person.reporters.build(report_id: report.id, owner: true)
    end
  end

  def create_initial_accessor
    report.permission Person.current_person, :write
  end

  def create_if_no_report
    if report.nil?
      report = create_report
      person = Person.current_person
      if person.admin?
        report.reporters << person.reporters.build(report_id: report, owner: true)
        report.permission person, :write
        report.save!
      end
    end
  end

  def localize_status
    if self.class == Employee
      I18n.t("activerecord.attributes.employee.localized_status.#{report.status}")
    else
      report.localize_status rescue I18n.t("activerecord.attributes.report.localized_status.not_reported")
    end
  end

  def access?(person, permission_type = :read)
    if report.present?
      report.access?(person, permission_type)
    else
      person.admin?
    end
  end
  delegate :report?, :report!, :approve!, :rollback!, :to => :report

  def approve?(person)
    person.admin?
  end

  def redirect_when_reported
    self
  end

  def email_notify_title(action, from, to, url)
  end

  def boxcar_notify_title(action, from, to, url)
  end

  def email_notify_body(action, from, to, url, comment)
  end

  def summary
    report.target_type
  end

  module ClassMethods
    def no_permission
      includes(:report => :accessors).merge(AccessPerson.no_permission)
    end

    def access_list(person)
      includes(:report => :accessors).merge(AccessPerson.access_list(person))
    end

    def report_status(status)
      includes(:report => :reporters).merge(Report.search_by_status(status))
    end
  end

  included do
    has_one :report, as: :target, dependent: :destroy
    before_create :create_initial_report, unless: :prevent_create_report
    after_create :create_initial_accessor, unless: :prevent_create_report

    attr_accessor :prevent_create_report
    extend ClassMethods
  end
end