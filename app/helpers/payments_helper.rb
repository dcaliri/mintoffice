module PaymentsHelper
  def next_payment(paid_at)
    return
  end

  def payment_step
    join_at = DateTime.parse_by_params(params[:payments], :join_at).to_time
    pay_end = DateTime.parse_by_params(params[:payments], :pay_end).to_time
    pay_at = params[:payments][:pay_at].to_i
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

      percentage = ((after - before) / 1.day)
      percentage = if percentage < 27
                    Holiday.working_days(before.to_date, after.to_date) / 30.0
                   else
                    1.0
                   end

      yield before, after, amount * percentage

      before = after + 1.day
    end
  end
end