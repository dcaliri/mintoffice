class CardApprovedSource < ActiveRecord::Base
  belongs_to :creditcard
  include StylesheetParseable

  self.per_page = 20

  DEFAULT = {
    :name => :default,
    :keys => {
      :approve_no => :integer
    },
    :columns => [
      :used_at,
      :approve_no,
      :card_no,
      :card_holder_name,
      :store_name,
      :money,
      :used_type,
      :monthly_duration,
      :card_type,
      :canceled_at,
      :status,
      :will_be_paied_at
    ],
    :position => {
      :start => {
        x: 2,
        y: 1
      },
      :end => 0
    }
  }

  set_parser_options DEFAULT

  def cardbill
    collection = Cardbill.where(approveno: approve_no)
    collection.first unless collection.empty?
  end

  def used_at_to_s
    attribute = read_attribute(:used_at)
    attribute.blank? ? "" : attribute.strftime("%Y.%m.%d %H:%M")
  end

  def canceled_at_to_s
    attribute = read_attribute(:canceled_at)
    attribute.blank? ? "" : attribute.strftime("%Y %m.%d")
  end


  def will_be_paied_at_to_s
    attribute = read_attribute(:will_be_paied_at)
    attribute.blank? ? "" : attribute.strftime("%Y %m.%d")
  end

  class << self
    def open_and_parse_stylesheet(card, upload)
      @card = card
      super(upload)
    end

    def before_parser_filter(params)
      @card.short_name == params[:card_no]
    end
  end

  def self.latest
    order("used_at DESC")
  end
end