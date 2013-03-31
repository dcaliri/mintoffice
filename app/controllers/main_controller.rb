class MainController < ApplicationController
  layout "main", :except => ['login', 'pdf']

  def index
      @reports = Report.for_timeline
      # @page = params[:page].nil? ? 0 : params[:page].to_i
      # @start_day = (Time.zone.now + @page.week).beginning_of_week
      # @end_day = (Time.zone.now + @page.week).end_of_week
      # @holidays = Holiday.during(@start_day.to_date..@end_day.to_date)
      # @vacations = UsedVacation.report_status(:reported).during(@start_day..@end_day)

      year = params[:year].nil? ? Time.zone.now.year : params[:year].to_i
      month = params[:month].nil? ? Time.zone.now.month : params[:month].to_i

      startdate = Time.zone.local(year, month, 1, 0,0,0) - 1.month
      enddate = startdate.end_of_month + 2.month
      
      @holidays = Holiday.during(startdate..enddate)
      @vacations = UsedVacation.report_status(:all).during(startdate..enddate)

      @events = @holidays + @vacations.collect { |vacation| vacation.events }.flatten

      startdate2 = Time.zone.local(year, month, 1, 0,0,0)
      enddate2 = startdate.end_of_month
      
      @vacations2 = UsedVacation.report_status(:all).during(startdate..enddate)
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