# encoding: UTF-8

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  fixtures :accounts, :people, :companies, :companies_people, :employees_permissions, :permissions, :employees, :employees_groups, :groups
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
    visit '/test/sessions?account_id=1'
  end

  def clear_session
    visit '/test/sessions/clear'
  end
end

class ActionController::TestCase
  setup :global_setup
  teardown :global_teardown

  # fixtures :accounts, :companies, :companies_accounts, :groups, :groups_accounts
  
  fixtures :accounts, :people, :employees, :companies_people, :employees_groups, :groups, :companies

  def global_setup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    session[:account_id] = current_account.id
    session[:company_id] = current_company.id

    Account.current_account = current_account
    Company.current_company = current_company
  end

  def global_teardown
    DatabaseCleaner.clean
  end

  def current_account
    unless @account
      @account = accounts(:admin_account)
      @account.employee.groups.create!(name: "admin")
    end
    @account
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