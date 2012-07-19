class ProvidersController < ApplicationController
  skip_before_filter :authorize

  def create
    auth = request.env["omniauth.auth"]

    user = User.find_by_omniauth(auth)
    user = User.create_from_omniauth(auth) unless user

    session[:user_id] = user.id

    if user.joined?
      redirect_to :root, :notice => I18n.t("users.login.successfully_signed_in")
    else
      redirect_to [:dashboard, :enrollments]
    end
  end
end