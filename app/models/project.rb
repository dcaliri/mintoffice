class Project < ActiveRecord::Base
  has_many :documents
  has_and_belongs_to_many :users

  # named_scope :completed, :conditions =>['ended_on is not null'], :order => "started_on ASC"
  # named_scope :inprogress, :conditions =>['ended_on is null'], :order => "started_on ASC"

  scope :completed, :conditions =>['ended_on is not null'], :order => "started_on ASC"
  scope :inprogress, :conditions =>['ended_on is null'], :order => "started_on ASC"

  validates_uniqueness_of :name
  validates_numericality_of :revenue
  
  def completed?
    ! self.ended_on.nil?
  end
end
