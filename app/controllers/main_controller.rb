class MainController < ApplicationController
  layout "main", :except => ['login', 'pdf']

  def index
      @user = User.find(session[:user_id])
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
