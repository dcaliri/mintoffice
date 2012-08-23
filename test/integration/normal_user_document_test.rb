# encoding: UTF-8
require 'test_helper'

class NUDocumentTest < ActionDispatch::IntegrationTest
  fixtures :documents
  fixtures :document_owners
  fixtures :documents_tags
  fixtures :projects
  fixtures :tags
  fixtures :taggings
  fixtures :reports
  fixtures :report_people
  fixtures :report_comments
  fixtures :access_people

  class ::ReportMailer
    def self.report(target, from, to, subject, message)
    end
  end 

  test 'should visit document list' do
    normal_user_access

    visit '/'
    click_link '문서 관리'

    assert(page.has_content?('문서 관리'))
  end

  test 'should create a new document' do
    normal_user_access

    visit '/'
    click_link '문서 관리'
    click_link '새로운 문서 작성'

    fill_in "문서제목", with: "문서제목 입력 테스트"

    click_button '만들기'

    assert(page.has_content?('문서이(가) 성공적으로 생성되었습니다.'))
  end

  test 'should edit document' do
    normal_user_access

    visit '/'
    click_link '문서 관리'
    click_link '새로운 문서 작성'

    fill_in "문서제목", with: "문서제목 입력 테스트"

    click_button '만들기'

    visit '/'
    click_link '문서 관리'
    select('전체', :from => 'report_status')
    find("tr.selectable").click

    click_link '수정하기'

    fill_in "문서제목", with: "문서제목 수정 테스트"

    click_button '갱신하기'

    assert(page.has_content?('문서이(가) 성공적으로 업데이트 되었습니다.'))
  end

  test 'should destroy document' do
    normal_user_access

    visit '/'
    click_link '문서 관리'
    click_link '새로운 문서 작성'

    fill_in "문서제목", with: "문서제목 입력 테스트"

    click_button '만들기'

    visit '/'
    click_link '문서 관리'
    find("tr.selectable").click

    disable_confirm_box

    click_link '삭제하기'

    assert(!page.has_content?('테스트 문서'))
  end

  test 'should report admin' do
    normal_user_access

    visit '/'
    click_link '문서 관리'
    click_link '새로운 문서 작성'

    fill_in "문서제목", with: "문서제목 입력 테스트"

    click_button '만들기'

    visit '/'
    click_link '문서 관리'
    find("tr.selectable").click

    select '김 관리', from: 'reporter'
    fill_in "코멘트", with: "연차 사용 신청"

    click_button '상신'

    assert(page.has_content?('상태 - 결재 대기 중'))
  end

  test 'should search data' do
    normal_user_access

    visit '/'
    click_link '문서 관리'
    click_link '새로운 문서 작성'

    fill_in "문서제목", with: "문서제목 입력 테스트"

    click_button '만들기'

    visit '/'
    click_link '문서 관리'
    
    find_field('query').set("문서제목 입력 테스트")
    find_field('query').native.send_key(:enter)

    assert(page.has_content?('문서제목 입력 테스트'))

    find_field('query').set("테스트 프로젝트")
    find_field('query').native.send_key(:enter)

    assert(page.has_content?('테스트 프로젝트'))
  end
end