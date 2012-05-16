# encoding: UTF-8

class Report < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  has_one :reporter, class_name: "ReportPerson"
  has_many :comments, class_name: 'ReportComment'

  def status
    status = read_attribute(:status)
    status ? status.to_sym : :not_reported
  end

  def localize_status
    I18n.t("activerecord.attributes.report.localized_status.#{status}")
  end

  def report!(hrinfo, comment)
    next_reporter = hrinfo.reporters.build
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
    save!
  end

  def rollback!(comment)
    prev_reporter = self.reporter
    self.reporter = prev_reporter.prev
    self.comments.build(owner: prev_reporter, description: "#{prev_reporter.fullname}님이 결제를 반려하였습니다")
    self.comments.build(owner: prev_reporter, description: comment) unless comment.blank?
    save!
  end

  def rollback?
    self.reporter.prev.nil? == false
  end
end