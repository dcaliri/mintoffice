class ProvidersController < ApplicationController
  skip_before_filter :authorize

  def create
    auth = request.env["omniauth.auth"]

    account = Account.find_by_omniauth(auth)
    account = Account.create_from_omniauth(auth) unless account

    session[:account_id] = account.id

    if account.joined?
      redirect_to :root, :notice => I18n.t("accounts.login.successfully_signed_in")
    else
      redirect_to [:dashboard, :enrollments]
    end
  end
end