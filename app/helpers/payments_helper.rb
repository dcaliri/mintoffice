module PaymentsHelper
  def next_payment(paid_at)
    return
  end

  def payment_step
    join_at = DateTime.parse_by_params(params[:payments], :join_at).to_date
    pay_end = DateTime.parse_by_params(params[:payments], :pay_finish).to_date
    pay_at = current_company.pay_basic_date
    amount = params[:payments][:amount].to_i

    before = join_at.dup
    after = join_at.dup

    periods = []

    while after < pay_end
      after = if pay_at == after.day
                after + 1.month
              elsif pay_at > after.day
                after.change(day: pay_at)
              elsif pay_at < after.day
                after.change(day: pay_at) + 1.month
              end

      after = pay_end.dup if after > pay_end

      working_day = Holiday.working_days(before, after)
      working_month = Holiday.working_days(after - 1.month + 1.day, after)
      working_day = if working_day < working_month
                    working_day / working_month.to_f
                   else
                    1.0
                   end

      yield before, after, (amount * working_day).to_i

      before = after + 1.day
    end
  end
end