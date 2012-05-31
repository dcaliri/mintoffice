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

  def report!(user, comment)
    prev_reporter = self.reporter
    prev_reporter.owner = false

    collection = reporters.where(user_id: user.id)
    if collection.empty?
      next_reporter = user.reporters.build(owner: true)
      next_reporter.prev = prev_reporter
      self.reporters << next_reporter
    else
      next_reporter = collection.first
      next_reporter.owner = true
    end

    self.status = :reporting
    self.comments.build(owner: prev_reporter, description: "#{next_reporter.fullname}님에게 결제를 요청하였습니다")
    self.comments.build(owner: prev_reporter, description: comment) unless comment.blank?

    next_reporter.save!
    prev_reporter.save!

    Boxcar.send_to_boxcar_user(next_reporter.user, prev_reporter.fullname, "#{prev_reporter.fullname}님이 #{next_reporter.fullname}님에게 결제를 요청하였습니다")

    permission user, :write
    permission prev_reporter.user, :read

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
      next_reporter.owner = true
      next_reporter.save!

      prev_reporter.owner = false
      prev_reporter.save!

      permission next_reporter.user, :write
      permission prev_reporter.user, :read
    end
    self.comments.build(owner: prev_reporter, description: "#{prev_reporter.fullname}님이 결제를 반려하였습니다")
    self.comments.build(owner: prev_reporter, description: comment) unless comment.blank?

    Boxcar.send_to_boxcar_user(next_reporter.user, prev_reporter.fullname, "#{prev_reporter.fullname}님이 #{next_reporter.fullname}님에게 결제를 반려하였습니다")

    save!
  end

  def rollback?
    self.status == :reported || self.reporter.prev.nil? == false
  end

  def approve?
    self.status != :reported
  end
end