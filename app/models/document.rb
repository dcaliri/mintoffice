# encoding: UTF-8

class Document < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  belongs_to :company
  belongs_to :employee

  belongs_to :project

  include Attachmentable
  include Taggable
  include Reportable

  self.per_page = 20

  class << self
    def search(params)
      result = report_status(params[:report_status]).search_by_text(params[:query])
      result = if params[:empty_permission] == 'true'
                result.no_permission
              else
                result.access_list(params[:person])
              end
      result
    end
    def latest
      order('documents.created_at DESC')
    end
  end

  def summary
    username = report.reporter.prev.fullname rescue ""
    "[문서] #{username} #{title}"
  end

  def add_tags(tag_list)
    unless tag_list.blank?
      tag_list.split(',').each do |tag|
        tags << Company.current_company.tags.find_or_create_by_name(tag)
      end
    end
  end

  def account_for_tag(tag_name)
    tag_names = self.tags.index_by {|t1| t1.name }
    all_account = Account.all.index_by {|u| u.name}
    target_account = tag_names.keys & all_account.keys

    if (tag_names.keys.include? (tag_name)) && target_account.size == 1
      Account.find_by_name(target_account[0])
    else
      nil
    end
  end

  def project_name
    if project then project.name else "none" end
  end

  def self.search_by_text(query)
    query = "%#{query}%"
    includes(:project).includes(:tags).where('title like ? OR projects.name like ? OR tags.name LIKE ?', query, query, query)
  end

  def email_notify_title(action, from, to, url)
    if action == :rollback
      "문서관리 - #{self.title} - #{from.fullname}님에 의해서 반려되었습니다."
    else
      "문서관리 - #{from.fullname}님이 #{self.title} 문서를 상신하였습니다."
    end
  end

  def boxcar_notify_title(action, from, to, url)
    if action == :rollback
      "문서관리 - #{self.title} - #{from.fullname}님에 의해서 반려되었습니다."
    else
      "문서관리 - #{from.fullname}의 결재요청 : #{self.title}"
    end
  end

  def email_notify_body(action, from, to, url, comment)
    <<-BODY
      문서제목 :
      #{self.title}

      코멘트:
      #{comment}

      링크:
      #{url}
    BODY
  end
end










