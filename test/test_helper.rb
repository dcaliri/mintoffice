# encoding: UTF-8

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  fixtures :users, :companies, :companies_users, :permissions_users, :permissions
  setup :global_setup
  teardown :global_teardown

  self.use_transactional_fixtures = false

  # Capybara.default_driver = :selenium
  DatabaseCleaner.strategy = :truncation

  private
  def global_setup
    login
  end

  def global_teardown
    DatabaseCleaner.clean
    Capybara.reset_sessions!
  end

  def login
    visit '/'

    fill_in "사용자계정", with: "admin"
    fill_in "비밀번호", with: "1234"

    click_button "로그인"
  end

  def logout
    click_link "로그아웃"
  end
end

class ActionController::TestCase
  setup :global_setup
  teardown :global_teardown

  fixtures :users, :companies, :companies_users, :groups, :groups_users

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
      @user = users(:fixture)
      @user.groups.create!(name: "admin")
    end
    @user
  end

  def current_company
    @company ||= companies(:fixture)
  end
end