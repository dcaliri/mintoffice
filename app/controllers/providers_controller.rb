class ProvidersController < ApplicationController
  skip_before_filter :authorize

  def create
    auth = request.env["omniauth.auth"]

    user = User.find_by_omniauth(auth)
    user = User.create_from_omniauth(auth) unless User

    session[:user_id] = user.id

    if user.joined?
      redirect_to :root, :notice => I18n.t("users.login.successfully_signed_in")
    else
      redirect_to [:dashboard, :enrollments]
    end
    # elsif user.not_joined? && my_enrollment.present?
    #   redirect_to [:edit, my_enrollment], :notice => I18n.t("enrollments.success")
    # elsif user.not_joined? && my_enrollment.blank?
    #   redirect_to [:new, :enrollment]
    # end
  end
end