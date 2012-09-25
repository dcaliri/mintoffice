# encoding: UTF-8

class Report < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  has_many :reporters, class_name: "ReportPerson", dependent: :destroy
  has_many :comments, class_name: 'ReportComment'

  before_create :set_status
  def set_status
    self.status = :not_reported
  end

  def status
    read_attribute(:status).to_sym
  end

  STATUS_SELECT = {
    I18n.t('models.report.all') => :all,
    I18n.t('models.report.default') => :default,
    I18n.t('models.report.not_reported') => :not_reported,
    I18n.t('models.report.reporting') => :reporting,
    I18n.t('models.report.rollback') => :rollback,
    I18n.t('models.report.reported') => :reported
  }

  include Permissionable

  class << self
    def for_timeline
      joins(:reporters).search_by_status([:reporting, :rollback]).merge(ReportPerson.by_me)
    end
    
    def search_by_status(status)
      status = :default if status.blank?
      if status.is_a? Array
        status = status.map(&:to_sym)
      else
        status = status.to_sym
      end
      
      case status
      when :all
        where("")
      when :default
        where('reports.status != ?', :reported).merge(ReportPerson.by_me)
      else
        status = [status] unless status.is_a? Array
        where(status: status)
      end
    end
  end

  def reporter
    self.reporters.find_by_owner(true)
  end

  def localize_status
    I18n.t("activerecord.attributes.report.localized_status.#{status}")
  end

  def report!(person, comment, report_url)
    prev_reporter = self.reporter
    next_reporter = change_owner(person)

    self.status = :reporting

    self.comments.build(owner: prev_reporter, description: "#{next_reporter.fullname}"+I18n.t('models.report.to_report'))
    self.comments.build(owner: prev_reporter, description: comment) unless comment.blank?

    save!

    notify(:report, prev_reporter, next_reporter, report_url, comment)
  end

  def approve!(person, comment)
    self.status = :reported

    unless self.reporter
      approved = Person.current_person.reporters.create!(report_id: id, owner: true)
    else
      approved = change_owner(person)
    end

    self.comments.build(owner: approved, description: "#{person.fullname}"+I18n.t('models.report.to_approve'))
    self.comments.build(owner: approved, description: comment) unless comment.blank?

    save!
  end

  def rollback!(comment, report_url)
    prev_status = self.status
    self.status = :rollback
    prev_reporter = self.reporter
    next_reporter = prev_reporter.prev if prev_reporter.prev

    if next_reporter
      next_reporter.owner = true
      next_reporter.save!

      prev_reporter.owner = false
      prev_reporter.save!

      permission next_reporter.person, :write
      permission prev_reporter.person, :read
    end

    self.comments.build(owner: prev_reporter, description: "#{prev_reporter.person.fullname}"+I18n.t('models.report.to_rollback'))
    self.comments.build(owner: prev_reporter, description: comment) unless comment.blank?

    save!

    notify(:rollback, prev_reporter, next_reporter, report_url, comment)
  end

  def report?
    not self.reporter.present? or self.reporter.person == Person.current_person
  end

  def rollback?
    self.status == :reported || (self.reporter and self.reporter.prev.nil? == false)
  end

  def approve?
    self.status != :reported
  end

  private
  def change_owner(person)
    unless self.reporter
      self.reporters << Person.current_person.reporters.build(report_id: id, owner: true)
    end

    prev_reporter = self.reporter
    return prev_reporter if person == prev_reporter.person

    prev_reporter.owner = false

    collection = reporters.where(person_id: person.id)
    if collection.empty?
      next_reporter = person.reporters.build(owner: true)
      next_reporter.prev = prev_reporter
      self.reporters << next_reporter
    else
      next_reporter = collection.first
      next_reporter.owner = true
    end

    prev_reporter.save!
    next_reporter.save!

    permission person, :write
    permission prev_reporter.person, :read

    next_reporter
  end

  def notify(action, from, to, url, comment)
    return if !from or !to

    target_name = target.class.to_s.downcase
    title = I18n.t("reports.#{action}.title.#{target_name}", {
      default: I18n.t("reports.#{action}.title.default"),
      prev: from.fullname,
      next: to.fullname
    })

    email_title = target.email_notify_title(action, from, to, url) || title
    boxcar_title = target.boxcar_notify_title(action, from, to, url) || title

    body = I18n.t("reports.#{action}.body.#{target_name}", {
      default: I18n.t("reports.#{action}.body.default"),
      prev: from.fullname,
      next: to.fullname,
      url: url,
    })

    email_body = target.email_notify_body(action, from, to, url, comment) || body

    Boxcar.send_to_boxcar_account(to.person, from.fullname, boxcar_title)
    ReportMailer.report(target, from.person, to.person, email_title, email_body)
  end
end