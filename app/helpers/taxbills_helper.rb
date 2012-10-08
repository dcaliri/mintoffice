module TaxbillsHelper
  def current_year
    params[:at] = Time.zone.now.year unless params[:at]
    Time.zone.parse("#{params[:at]}-01-01 00:00:00")
  end

  def oldest_year
    purchase = @purchases.oldest_at
    sales = @sales.oldest_at

    [purchase, sales].min.year
  end

  def options_for_bill_type_select(billtype=nil)
    options_for_select([t('taxbills.purchase_bill'),t('taxbills.sales_bill')].zip(Taxbill::BILL_TYPE), billtype)
  end
end