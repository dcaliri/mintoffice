# encoding: UTF-8

class ExpenseReport < ActiveRecord::Base
  belongs_to :hrinfo
  belongs_to :target, polymorphic: true
  belongs_to :project

  by_star_field :expensed_at

  include Reportable

  def make_posting
    posting = Posting.new(
      posted_at: expensed_at
    )
    posting
  end

  class << self
    def filter(params)
      access_list(params[:user]).by_project(params[:project]).by_period(params[:year], params[:month])
    end

    def by_project(project)
      where(project ? {project_id: project.id} : {})
    end

    def by_period(year, month)
      if year and year > 0
        if month and month > 0
          by_month(month, :year => year)
        else
          by_year(year)
        end
      else
        if month and month > 0
          by_month(month)
        else
          where("")
        end
      end
    end

    def oldest_year
      collection = order('expensed_at ASC')
      unless collection.empty?
        collection.first.expensed_at.year
      else
        Date.today.year
      end
    end

    def newest_year
      collection = order('expensed_at DESC')
      unless collection.empty?
        collection.first.expensed_at.year
      else
        Date.today.year
      end
    end

    def total_amount
      sum{|report| report.amount}
    end
  end

end