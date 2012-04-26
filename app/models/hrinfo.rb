class Hrinfo < ActiveRecord::Base
  belongs_to :user
  has_one :contact, :as => :target

  has_many :hrinfo_histories, :class_name => "HrinfoHistory", :foreign_key => "hrinfo_id"

  validates_format_of :juminno, :with => /^\d{6}-\d{7}$/, :message => I18n.t('hrinfos.error.juminno_invalid')
  validates_uniqueness_of :juminno
  validates_numericality_of :companyno
  validates_uniqueness_of :companyno

  def fullname
    if lastname == nil || firstname == nil
      "unknown"
    else
      lastname + " " + firstname
    end
  end

  def self.search(text)
    text = "%#{text || ""}%"
    joins(:user).where('users.name LIKE ? OR hrinfos.email LIKE ? OR users.notify_email LIKE ? OR firstname like ? OR lastname LIKE ? OR address LIKE ? OR position LIKE ? OR mphone LIKE ?', text, text, text, text, text, text, text, text)
  end
end
