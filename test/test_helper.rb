# encoding: UTF-8

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  fixtures :users, :people, :companies, :companies_people, :hrinfos_permissions, :permissions, :hrinfos, :groups_hrinfos, :groups
  setup :global_setup
  teardown :global_teardown

  self.use_transactional_fixtures = false

  Capybara.default_driver = :selenium
  DatabaseCleaner.strategy = :truncation

  private
  def global_setup
    simple_authenticate
  end

  def global_teardown
    DatabaseCleaner.clean
    Capybara.reset_sessions!
  end

  def simple_authenticate
    visit '/test/sessions?user_id=1'
  end

  def clear_session
    visit '/test/sessions/clear'
  end
end

class ActionController::TestCase
  setup :global_setup
  teardown :global_teardown

  # fixtures :users, :companies, :companies_users, :groups, :groups_users
  
  fixtures :users, :people, :hrinfos, :companies_people, :groups_hrinfos, :groups, :companies

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
      @user.hrinfo.groups.create!(name: "admin")
    end
    @user
  end

  def current_company
    @company ||= companies(:fixture)
  end
end

class ActiveSupport::TestCase
  setup :global_setup
  teardown :global_teardown

  DatabaseCleaner.strategy = :truncation
  def global_setup
    DatabaseCleaner.start
  end

  def global_teardown
    DatabaseCleaner.clean
  end
end