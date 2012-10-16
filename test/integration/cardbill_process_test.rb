# encoding: UTF-8
require 'test_helper'

class CardBillProcessTest < ActionDispatch::IntegrationTest
  fixtures :cardbills
  fixtures :creditcards
  fixtures :access_people
  fixtures :projects
  fixtures :project_assign_infos

  # test 'should see CardBillProcess' do
  #   visit '/'
  #   click_link '신용카드 관리'
  #   click_link '카드 사용내역'
  #   click_link '카드영수증이 없는 목록 보기'
  #   click_link '신용카드 영수증 생성'

  #   select('[개인] 카드영수증 매니저', from: 'owner')

  #   click_button '카드영수증 생성'

  #   assert(page.has_content?('카드영수증 매니저(card_manager) 이(가) 총 1개의 카드영수증을 생성했습니다.'))

  #   clear_session

  #   visit '/'

  #   fill_in "사용자계정", with: "card_manager"
  #   fill_in "비밀번호", with: "1234"

  #   click_button "로그인"

  #   click_link '카드 영수증 목록'
  #   click_link '상세보기'

  #   assert(page.has_content?('김 관리'))
  #   assert(page.has_content?('김 개똥'))
  #   assert(page.has_content?('카드 사용자'))
  #   assert(!page.has_content?('퇴 직자'))

  #   select '카드 사용자', from: 'reporter'
  #   fill_in "코멘트", with: "유저에게 상신"

  #   click_button '상신'

  #   assert(page.has_content?('상태 - 결재 대기 중'))

  #   clear_session

  #   visit '/'

  #   fill_in "사용자계정", with: "card_user"
  #   fill_in "비밀번호", with: "1234"

  #   click_button "로그인"

  #   click_link '카드 영수증 목록'
  #   click_link '상세보기'

  #   # assert(page.has_content?('카드영수증 매니저(card_manager): 카드 사용자(card_user)님에게 결재를 요청하였습니다.'))
  #   assert(page.has_content?('카드 사용자(card_user)님에게 결재를 요청하였습니다.'))
  #   assert(page.has_content?('유저에게 상신'))

  #   click_link '수정하기'

  #   path = File.join(::Rails.root, "test/fixtures/images/cardbill.png")
  #   attach_file('cardbill_attachments_attributes_0_uploaded_file', path)

  #   click_button '카드 영수증 수정하기'

  #   click_link '지출내역서 만들기'

  #   select '테스트 프로젝트', from: 'expense_report_project_id'
  #   fill_in "내역", with: "지출내역서 상세 내역"

  #   click_button '지출 내역서 만들기'

  #   select '김 관리', from: 'reporter'
  #   fill_in '코멘트', with: 'admin에게 상신'

  #   click_button '상신'

  #   assert(page.has_content?('상태 - 결재 대기 중'))

  #   visit '/'

  #   click_link '카드 영수증 목록'
  #   click_link '상세보기'

  #   select '김 관리', from: 'reporter'
  #   fill_in '코멘트', with: 'admin에게 상신'

  #   click_button '상신'

  #   assert(page.has_content?('상태 - 결재 대기 중'))

  #   clear_session

  #   visit '/'

  #   fill_in "사용자계정", with: "admin"
  #   fill_in "비밀번호", with: "1234"

  #   click_button "로그인"

  #   click_link '카드 영수증 목록'
  #   click_link '상세보기'

  #   fill_in '코멘트', with: '카드영수증 내역 승인'

  #   click_button '승인'

  #   visit '/'

  #   click_link '지출내역서 관리'
  #   click_link '상세보기'

  #   fill_in '코멘트', with: '카드영수증 내역 승인'

  #   click_button '승인'
  # end
end