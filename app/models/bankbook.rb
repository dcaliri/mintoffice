# encoding: UTF-8

class Bankbook < ActiveRecord::Base
  belongs_to :holder, polymorphic: true
  has_many :payment_records
  has_one :employee
  has_one :dayworker

  validates :name, presence: true
  validates :number, presence: true
  validates :account_holder, presence: true

  include Attachmentable

  CODE_COLLECTION = [
    ["기업은행", 3],
    ["국민은행", 4],
    ["우리은행", 20],
    ["신한은행", 88],
    ["하나은행", 81],
    ["농협",    11],
    ["단위농협", 12],
    ["SC은행",  23],
    ["외환은행", 5],
    ["한국씨티은행", 27],
    ["우체국", 71],
    ["경남은행", 39],
    ["광주은행", 34],
    ["대구은행", 31],
    ["도이치", 55],
    ["부산은행", 32],
    ["산림조합", 64],
    ["산업은행", 2],
    ["상호저축은행", 50],
    ["새마을금고", 45],
    ["수협", 7],
    ["신협중앙회", 48],
    ["전북은행", 37],
    ["제주은행", 35],
    ["BOA", 60],
    ["HSBC", 54],
    ["JP모간", 57],
    ["교보증권", 261],
    ["대신증권", 267],
    ["대우증권", 238],
    ["동부증권", 279],
    ["동양증권", 209],
    ["메리츠증권", 287],
    ["미래에셋", 230],
    ["부국증권", 290],
    ["삼성증권", 240],
    ["솔로몬투자증권", 268],
    ["신영증권", 291],
    ["우리투자증권", 278],
    ["유진투자증권", 280],
    ["이트레이드증권", 265],
    ["키움증권", 264],
    ["하나대투", 270],
    ["하나투자", 262],
    ["한국투자", 243],
    ["한화증권", 269],
    ["현대증권", 218],
    ["HMC증권", 263],
    ["LIG투자증권", 292],
    ["NH증권", 289],
    ["SK증권", 266]
  ]

  def bankname
    code = CODE_COLLECTION.find {|codes| codes[1] == bank_code}
    code[0] if code
  end

  class << self
    def no_holder
      where(holder_id: nil)
    end
  end
end