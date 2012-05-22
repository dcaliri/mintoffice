# encoding: UTF-8

class Report < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  has_one :reporter, class_name: "ReportPerson"
  has_many :comments, class_name: 'ReportComment'

  before_create :set_status
  def set_status
    self.status = :not_reported
  end

  def status
    read_attribute(:status).to_sym
  end

  def access?(user)
    self.reporter.user == user
  end

  def localize_status
    I18n.t("activerecord.attributes.report.localized_status.#{status}")
  end

  def report!(user, comment)
    next_reporter = user.reporters.build
    prev_reporter = self.reporter
    next_reporter.prev = prev_reporter
    self.reporter = next_reporter

    self.status = :reporting
    self.comments.build(owner: prev_reporter, description: "#{reporter.fullname}님에게 결제를 요청하였습니다")
    self.comments.build(owner: prev_reporter, description: comment) unless comment.blank?
    save!
  end

  def approve!(comment)
    self.status = :reported
    self.comments.build(owner: self.reporter, description: "#{reporter.fullname}님이 결제를 승인하였습니다")
    self.comments.build(owner: self.reporter, description: comment) unless comment.blank?
    self.reporter.save!
    save!
  end

  def rollback!(comment)
    self.status = :reporting
    prev_reporter = self.reporter
    self.reporter = prev_reporter.prev if prev_reporter.prev
    self.comments.build(owner: prev_reporter, description: "#{prev_reporter.fullname}님이 결제를 반려하였습니다")
    self.comments.build(owner: prev_reporter, description: comment) unless comment.blank?
    save!
  end

  def rollback?
    reported? || self.reporter.prev.nil? == false
  end

  def reported?
    self.status == :reported
  end
end