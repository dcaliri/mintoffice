class Test::SessionsController < Test::ApplicationController
  def show
    options = params.reject do |key, value| 
      ['controller', 'action'].include? key
    end

    options.each do |key, value|
      session[key] = value
    end

    redirect_to :root
  end

  def destroy
    session.clear
    redirect_to :root
  end
end