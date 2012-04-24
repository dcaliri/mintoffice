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