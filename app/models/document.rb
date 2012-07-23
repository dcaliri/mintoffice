class Document < ActiveRecord::Base
  belongs_to :company

  belongs_to :project
  has_many :document_owners
  has_many :hrinfos, :through => :document_owners, :source => :hrinfo
  # has_many :users, :through => :document_owners, :source => :user

  # validates_presence_of :title

  include Attachmentable
  include Taggable
  include Reportable

  self.per_page = 20

  class << self
    def filter_by_params(params)
      result = report_status(params[:report_status]).search(params[:query])
      result = if params[:empty_permission] == 'true'
                result.no_permission
              else
                result.access_list(params[:user])
              end
      result
    end
    def latest
      order('documents.created_at DESC')
    end
  end

  def add_tags(tag_list)
    unless tag_list.blank?
      tag_list.split(',').each do |tag|
        tags << Company.current_company.tags.find_or_create_by_name(tag)
      end
    end
  end

  def user_for_tag(tag_name)
    tag_names = self.tags.index_by {|t1| t1.name }
    all_user = User.all.index_by {|u| u.name}
    target_user = tag_names.keys & all_user.keys

    if (tag_names.keys.include? (tag_name)) && target_user.size == 1
      User.find_by_name(target_user[0])
    else
      nil
    end
  end

  def project_name
    if project then project.name else "none" end
  end

  def self.search(query)
    query = "%#{query}%"
    includes(:project).includes(:tags).where('title like ? OR projects.name like ? OR tags.name LIKE ?', query, query, query)
  end
end










