class Hrinfo < ActiveRecord::Base
  belongs_to :user
  
  has_many :hrinfo_histories, :class_name => "HrinfoHistory", :foreign_key => "hrinfo_id"
  
  validates_format_of :juminno, :with => /^\d{6}-\d{7}$/, :message => I18n.t('hrinfos.error.juminno_invalid')
  validates_uniqueness_of :juminno
  validates_numericality_of :companyno
  validates_uniqueness_of :companyno

  def fullname
    lastname + " " + firstname
  end
  
end
