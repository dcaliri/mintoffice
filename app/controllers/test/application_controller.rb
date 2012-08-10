class Test::ApplicationController < ApplicationController
  skip_before_filter :authorize
  skip_before_filter :set_global_current_person_and_company
  skip_before_filter :verify_authenticity_token
end