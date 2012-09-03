module CreditcardsHelper
  def render_card_list(card_type)
    folder = case card_type
             when "default_card_used_sources"
               "card_used_sources"
             when "default_card_approved_sources"
               "card_approved_sources"
             when "oversea_card_approved_sources"
               "card_approved_sources"
             else
              card_type
             end
    render "#{folder}/list", folder.to_sym => @collection
  end
end
