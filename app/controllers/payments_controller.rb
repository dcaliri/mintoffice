class PaymentsController < ApplicationController
  expose(:users) { User.page(params[:page]) }
  expose(:user)
end