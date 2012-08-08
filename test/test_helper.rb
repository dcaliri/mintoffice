# encoding: UTF-8

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  fixtures :accounts, :people, :companies, :companies_people, :people_permissions, :permissions, :employees, :groups_people, :groups
  setup :global_setup
  teardown :global_teardown

  self.use_transactional_fixtures = false

  Capybara.default_driver = :selenium
  DatabaseCleaner.strategy = :truncation

  protected
  def switch_to_rack_test
    browser = Capybara.current_session.driver.browser
    browser.manage.delete_all_cookies

    Capybara.current_driver = :rack_test
    simple_authenticate
  end

  private
  def global_setup
    simple_authenticate
  end

  def global_teardown
    DatabaseCleaner.clean
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def simple_authenticate
    visit '/test/sessions?person_id=1'
  end

  def clear_session
    visit '/test/sessions/clear'
  end
end

class ActionController::TestCase
  setup :global_setup
  teardown :global_teardown

  fixtures :accounts, :people, :employees, :companies_people, :groups_people, :groups, :companies

  def global_setup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    session[:person_id] = current_person.id
    session[:company_id] = current_company.id

    Person.current_person = current_person
    Company.current_company = current_company
  end

  def global_teardown
    DatabaseCleaner.clean
  end

  def current_person
    unless @person
      @person = people(:fixture)
      @person.groups.create!(name: "admin")
    end
    @person
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