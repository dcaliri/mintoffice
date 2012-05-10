class Cardbill < ActiveRecord::Base
  belongs_to :creditcard

  include Historiable
  include Attachmentable

  def history_info
    {
      :creditcard_id => proc { |cardbill, v| Creditcard.find(v).cardno }
    }
  end

  # validates_presence_of :cardno
  validates_presence_of :totalamount
  validates_presence_of :approveno
  validates_numericality_of :totalamount
  validates_numericality_of :amount
  validates_numericality_of :servicecharge
  validates_numericality_of :vat

  before_save :strip_approve_no
  def strip_approve_no
    approveno.strip!
  end


  def used
    collection = CardUsedSource.where(approve_no: approveno)
    return collection.first unless collection.empty?
  end

  def approved
    collection = CardApprovedSource.where(approve_no: approveno)
    return collection.first unless collection.empty?
  end

  def cardno_long
    unless self.creditcard.nil?
      self.creditcard.cardno_long
    else`x`
      cardno
    end
  end

  def approved_mismatch
    mismatch?(:totalamount) || mismatch?(:transdate)
  end

  def mismatch?(type=nil)
    if type == nil
      types = [:totalamount, :transdate]
    else
      types = [type]
    end

    result = types.any? do |type|
      case type
      when :totalamount
        approved &&  totalamount != approved.money
      when :transdate
        approved && transdate.between?(approved.used_at - 1.hour, approved.used_at + 1.hour) == false
      else
        false
      end
    end

    result ? 'misnatch-sources' : nil
  end

  def status
    if approved == nil || used == nil
      "not-connected-to-sources"
    elsif mismatch?
      "misnatch-sources"
    else
      ""
    end
  end

  def self.search(query)
    query = "%#{query}%"
    where('storename like ? OR storeaddr like ?', query, query)
  end

  def self.searchbycreditcard(query)
    if query == nil or query == ""
      where("")
    else
      where("creditcard_id = ?", query)
    end
  end
end
