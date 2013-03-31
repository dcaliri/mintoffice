module Api
  class VacationsController < ::ApplicationController
    skip_before_filter :authorize

    def check_period
      deductible = VacationType.find(params[:vacation_type_id]).deductible? ? 1 : 0
      from = Date.new(params[:from_year].to_i, params[:from_month].to_i, params[:from_day].to_i)
      to = Date.new(params[:to_year].to_i, params[:to_month].to_i, params[:to_day].to_i)
      used = UsedVacation.new(from: from, to: to, from_half: params[:from_half], to_half: params[:to_half])
      render text: "$(used_vacation_period).val('#{used.calculate_period * deductible}')"
    end
  end
end