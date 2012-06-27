class ProvidersController < ApplicationController
  skip_before_filter :authorize

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_omniauth(auth)

    if user
      session[:user_id] = user.id
      redirect_to :root, :notice => I18n.t("users.login.successfully_signed_in")
    else
      redirect_to users_login_path(), :notice => I18n.t("users.login.not_registered")
    end
  end
end