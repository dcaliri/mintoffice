class ProvidersController < ApplicationController
  skip_before_filter :authorize

  def create
    auth = request.env["omniauth.auth"]

    @account = Account.find_by_omniauth(auth)
    @account = Account.create_from_omniauth(auth) unless @account
    raise @account.errors.inspect if @account.invalid?

    session[:person_id] = @account.person.id

    if @account.needs_apply?
      redirect_to [:dashboard, :enrollments]
    else
      redirect_to :root, :notice => I18n.t("accounts.login.successfully_signed_in")
    end
  end
end