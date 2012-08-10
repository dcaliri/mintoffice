module TaxbillsHelper
  def current_year
    params[:at] = Time.zone.now.year unless params[:at]
    Time.zone.parse("#{params[:at]}-01-01 00:00:00")
  end

  def oldest_year
    purchase = @purchases.oldest_at
    sales = @sales.oldest_at
    card = @cards.oldest_at

    [purchase, sales, card].min.year
  end
end