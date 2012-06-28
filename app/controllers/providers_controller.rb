class ProvidersController < ApplicationController
  skip_before_filter :authorize

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_omniauth(auth)

    if user
      session[:user_id] = user.id
      if user.not_joined?
        redirect_to :apply, :notice => I18n.t("applies.success")
      else
        redirect_to :root, :notice => I18n.t("users.login.successfully_signed_in")
      end
    else
      redirect_to try_apply_path(provider: auth["provider"], email: auth['info']['email'])
    end
  end
end