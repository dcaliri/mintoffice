# encoding: UTF-8

class Report < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  has_many :reporters, class_name: "ReportPerson"
  has_many :comments, class_name: 'ReportComment'

  before_create :set_status
  def set_status
    self.status = :not_reported
  end

  def status
    read_attribute(:status).to_sym
  end

  STATUS_SELECT = [
    [not_reported: "결제 대기 중"],
    [reporting: "결제 진행 중"],
    [rollback: "반려"],
    [reported: "결제 완료"],
  ]

  STATUS_SELECT = {
    "전체" => :all,
    "결재전 + 나의 결재 대기중" => :default,
    "결제 대기 중" => :not_reported,
    "결제 진행 중" => :reporting,
    "반려" => :rollback,
    "결제 완료" => :reported
  }

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

  def access?(user, permission_type = :read)
    permission_query = permission_type == :write ? {permission_type: :write} : {}
    self.reporters.where(permission_query).exists?(user_id: user)
  end

  def localize_status
    I18n.t("activerecord.attributes.report.localized_status.#{status}")
  end

  def report!(user, comment)
    prev_reporter = self.reporter
    prev_reporter.attributes = {permission_type: "read", owner: false}

    collection = reporters.where(user_id: user.id)
    if collection.empty?
      next_reporter = user.reporters.build(permission_type: "write", owner: true)
      next_reporter.prev = prev_reporter
      self.reporters << next_reporter
    else
      next_reporter = collection.first
      next_reporter.attributes = {permission_type: "write", owner: true}
    end

    self.status = :reporting
    self.comments.build(owner: prev_reporter, description: "#{next_reporter.fullname}님에게 결제를 요청하였습니다")
    self.comments.build(owner: prev_reporter, description: comment) unless comment.blank?

    next_reporter.save!
    prev_reporter.save!
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
    self.status = :rollback
    prev_reporter = self.reporter
    next_reporter = prev_reporter.prev if prev_reporter.prev
    if next_reporter
      next_reporter.attributes = {permission_type: "write", owner: true}
      next_reporter.save!

      prev_reporter.attributes = {permission_type: "read", owner: false}
      prev_reporter.save!
    end
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