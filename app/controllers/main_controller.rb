class MainController < ApplicationController
  layout "main", :except => ['login', 'pdf']

  def index
      @user = User.find(session[:user_id])
      @start_day = Time.zone.now.beginning_of_week
      @end_day = Time.zone.now.end_of_week
      @holidays = Holiday.during(@start_day..@end_day)
      @vacations = UsedVacation.during(@start_day..@end_day)
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
