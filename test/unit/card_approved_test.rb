require 'test_helper'

class CardApprovedTest < ActiveSupport::TestCase
  fixtures :users
  fixtures :cardbills
  fixtures :creditcards
  fixtures :card_approved_sources
  fixtures :card_used_sources
  fixtures :bank_accounts
  fixtures :reports
  fixtures :report_people
  fixtures :report_comments
  fixtures :permissions
  fixtures :permissions_users

  def setup
    User.current_user = users(:admin_account)
  end

  test "admin generate cardbill to manager" do
    next if Cardbill.exists?(approveno: current_card_approved_source.approve_no)

    used_sources = CardUsedSource.where(approve_no: current_card_approved_source.approve_no)
    next if used_sources.empty?
    used_source = used_sources.first

    cardbill = current_card_approved_source.creditcard.cardbills.build(
      amount: 				used_source.price,
      servicecharge: 	used_source.tax,
      vat: 						used_source.tip,
      approveno: 			current_card_approved_source.approve_no,
      totalamount: 		current_card_approved_source.money,
      transdate: 			current_card_approved_source.used_at,
      storename: 			current_card_approved_source.store_name,
      storeaddr: 			used_source.store_addr1 + " " + used_source.store_addr2,
    )

    report = cardbill.build_report
    report.reporters << current_owner.reporters.build(report_id: report, owner: true)

    assert cardbill.save!

    cardbill.report.permission current_owner, :write
  end

  private
  def current_owner
    @owner ||= users(:card_manager_account)
  end

  def current_creditcard
    @creditcard ||= creditcards(:shinhan_card)
  end

  def current_card_used_source
  	@card_used_source ||= card_used_sources(:not_exist_cardbill)
	end

	def current_card_approved_source
  	@card_approved_source ||= card_approved_sources(:not_exist_cardbill)
	end
end