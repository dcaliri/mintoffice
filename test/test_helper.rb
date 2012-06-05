ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  setup :global_setup
  teardown :global_teardown

  fixtures :companies

  def global_setup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    session[:user_id] = current_user.id
    session[:company_id] = current_company.id

    User.current_user = current_user
    Company.current_company = current_company
  end

  def global_teardown
    DatabaseCleaner.clean
  end

  def current_user
    unless @user
      @user = User.create!(name: "admin", password: "1234", password_confirmation: "1234")
      @user.groups.create!(name: "admin")
    end
    @user
  end

  def current_company
    @company ||= companies(:fixture)
  end
end