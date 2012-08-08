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
    def search_by_status(status)
      status = status.blank? ? :default : status.to_sym
      case status
      when :all
        where("")
      when :default
        where('reports.status != ?', :reported).merge(ReportPerson.by_me)
      else
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

    self.status = :reporting
    self.comments.build(owner: prev_reporter, description: "#{next_reporter.fullname}"+I18n.t('models.report.to_report'))
    self.comments.build(owner: prev_reporter, description: comment) unless comment.blank?

    next_reporter.save!
    prev_reporter.save!

    target_name = target.class.to_s.downcase
    title = I18n.t("reports.report.title.#{target_name}", {
      default: I18n.t("reports.report.title.default"),
      prev: prev_reporter.fullname,
      next: next_reporter.fullname
    })

    body = I18n.t("reports.report.body.#{target_name}", {
      default: I18n.t("reports.report.body.default"),
      prev: prev_reporter.fullname,
      next: next_reporter.fullname,
      url: report_url,
    })

    permission person, :write
    permission prev_reporter.person, :read

    save!

    Boxcar.send_to_boxcar_account(next_reporter.person, prev_reporter.fullname, title)
    ReportMailer.report(target, prev_reporter.person, next_reporter.person, title, body)
  end

  def approve!(comment)
    self.status = :reported
    Person.current_person.reporters.create!(report_id: id, owner: true) unless self.reporter
    self.comments.build(owner: self.reporter, description: "#{reporter.fullname}"+I18n.t('models.report.to_approve'))
    self.comments.build(owner: self.reporter, description: comment) unless comment.blank?
    save!
  end

  def rollback!(comment, report_url)
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
    self.comments.build(owner: prev_reporter, description: "#{prev_reporter.fullname}"+I18n.t('models.report.to_rollback'))
    self.comments.build(owner: prev_reporter, description: comment) unless comment.blank?

    if next_reporter
      target_name = target.class.to_s.downcase
      title = I18n.t("reports.rollback.title.#{target_name}", {
        default: I18n.t("reports.rollback.title.default"),
        prev: prev_reporter.fullname,
        next: next_reporter.fullname
      })

      body = I18n.t("reports.rollback.body.#{target_name}", {
        default: I18n.t("reports.rollback.body.default"),
        prev: prev_reporter.fullname,
        next: next_reporter.fullname,
        url: report_url,
      })


      Boxcar.send_to_boxcar_account(next_reporter.person, prev_reporter.fullname, title)
      ReportMailer.report(target, prev_reporter.person, next_reporter.person, title, body)
    end

    save!
  end

  def report?
    self.reporter.present? && self.reporter.person == Person.current_person
  end

  def rollback?
    self.status == :reported || (self.reporter and self.reporter.prev.nil? == false)
  end

  def approve?
    self.status != :reported
  end
end