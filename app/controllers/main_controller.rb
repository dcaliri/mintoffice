class MainController < ApplicationController
  layout "main", :except => ['login', 'pdf']

  def index
      @reports = Report.for_timeline
      @page = params[:page].nil? ? 0 : params[:page].to_i
      @start_day = (Time.zone.now + @page.week).beginning_of_week
      @end_day = (Time.zone.now + @page.week).end_of_week
      @holidays = Holiday.during(@start_day.to_date..@end_day.to_date)      
      @vacations = UsedVacation.report_status(:reported).during(@start_day..@end_day)
  end

  def pdf
  end

# if RAILS_ENV == 'development'
if ENV["RAILS_ENV"] == "development"
  def method_missing(name, *args)
    render(:inline => %{
      <h2>Unknown action: #{name}</h2>
      Here are the request parameters:<br />
      <%= debug(params) %>
    })
  end
end
end