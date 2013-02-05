# encoding: UTF-8
require 'test_helper'

class GetEmploymentProofTest < ActionDispatch::IntegrationTest
  fixtures :contacts
  fixtures :contact_emails
  fixtures :contact_email_tags
  fixtures :contact_email_tags_contact_emails
  fixtures :contact_addresses
  fixtures :contact_address_tags
  fixtures :contact_address_tags_contact_addresses
  fixtures :contact_phone_numbers
  fixtures :contact_phone_number_tags
  fixtures :contact_phone_number_tags_contact_phone_numbers
  fixtures :contact_others
  fixtures :contact_other_tags
  fixtures :contact_other_tags_contact_others
  fixtures :required_tags
  fixtures :tags
  fixtures :companies

  test 'admin should get his proof' do
    switch_to_selenium

    class ::Company < ActiveRecord::Base
      def seal
        "#{Rails.root}/test/fixtures/images/120731092154_Untitled.png"
      end
    end
    
    visit '/'
    click_link '인사관리'
    click_link '인사정보관리 - 사원목록'

    visit '/employees/1'
    click_link '재직증명서'

    fill_in "용도", with: "test"
    click_button '출력'

    assert(page.has_content?('재직증명서'))
  end

  test 'admin should get another employee proof' do
    switch_to_selenium

    class ::Company < ActiveRecord::Base
      def seal
        "#{Rails.root}/test/fixtures/images/120731092154_Untitled.png"
      end
    end
    
    visit '/'
    click_link '인사관리'
    click_link '인사정보관리 - 사원목록'

    visit '/employees/2'

    click_link '재직증명서'


    fill_in "용도", with: "test"
    click_button '출력'

    assert(page.has_content?('재직증명서'))
  end  

  test 'normal user should get his proof' do
    switch_to_selenium

    class ::Company < ActiveRecord::Base
      def seal
        "#{Rails.root}/test/fixtures/images/120731092154_Untitled.png"
      end
    end
    
    normal_user_access

    click_link '인사관리'
    click_link '인사정보관리 - 사원목록'

    visit '/employees/2'

    click_link '재직증명서'

    fill_in "용도", with: "test"
    click_button '출력'

    assert(page.has_content?('재직증명서'))
  end

  test 'normal user should not get another employee proof' do
    class ::Company < ActiveRecord::Base
      def seal
        "#{Rails.root}/test/fixtures/images/120731092154_Untitled.png"
      end
    end
    
    normal_user_access

    click_link '인사관리'
    click_link '인사정보관리 - 사원목록'

    visit '/employees/1/employment_proof'

    assert(page.has_content?("You don't have to permission"))
  end
end