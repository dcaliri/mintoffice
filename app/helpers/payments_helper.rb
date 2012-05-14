module PaymentsHelper
  def next_payment(paid_at)
    return
  end

  def payment_step
    pay_start = DateTime.parse_by_params(params[:payments], :pay_start).to_time
    pay_end = DateTime.parse_by_params(params[:payments], :pay_end).to_time
    pay_at = params[:payments][:pay_at].to_i
    amount = params[:payments][:amount].to_i

    before = pay_start.dup
    after = pay_start.dup
    while after < pay_end
      after = if pay_at == after.day
                after + 1.month
              elsif pay_at > after.day
                after.change(day: pay_at)
              elsif pay_at < after.day
                after.change(day: pay_at) + 1.month
              end

      after = pay_end.dup if after > pay_end

      percentage = ((after - before) / 1.day)
      percentage = if percentage < 28
                    percentage / 30.0
                   else
                     1.0
                   end

      yield before, after, percentage * amount

      before = after + 1.day
    end
  end
end