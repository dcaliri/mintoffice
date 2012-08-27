# encoding: UTF-8

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  fixtures :accounts, :people, :companies, :companies_people, :people_permissions, :permissions, :employees, :groups_people, :groups, :contacts

  setup :global_setup
  teardown :global_teardown

  self.use_transactional_fixtures = false


  driver = ENV['driver']
  if driver
    Capybara.default_driver = driver.to_sym
  end

  DatabaseCleaner.strategy = :truncation

  def click_link(locator)
    if Capybara.current_driver == :selenium and locator == "상세보기"
      find("tr.selectable").click
    else
      super
    end
  end

  protected
  def switch_to_selenium
    Capybara.current_driver = :selenium
    simple_authenticate
  end

  def switch_to_rack_test
    return if Capybara.current_driver == :rack_test

    browser = Capybara.current_session.driver.browser
    browser.manage.delete_all_cookies

    Capybara.current_driver = :rack_test
    simple_authenticate
  end

  def disable_confirm_box
    if Capybara.default_driver == :selenium
      page.evaluate_script('window.confirm = function() { return true; }')
    end
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

  def get_now_time
    Time.zone.now.strftime("%Y-%m-%d")
  end

  def get_payment_day
    if Time.zone.now.month < 10
      Time.zone.now.year.to_s + ".0" + Time.zone.now.month.to_s + ".25"
    else
      Time.zone.now.year.to_s + "." + Time.zone.now.month.to_s + ".25"
    end
  end

  def simple_authenticate
    visit '/test/sessions?person_id=1'
  end

  def clear_session
    visit '/test/sessions/clear'
  end

  def normal_user_access
    visit '/test/sessions?person_id=2'
  end

  def project_admin_access
    visit '/test/sessions?person_id=3'
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

  def switch_to_normal
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    session[:person_id] = normal_person.id
    session[:company_id] = current_company.id

    Person.current_person = normal_person
    Company.current_company = current_company
  end

  def normal_person
    @person = people(:normal)
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