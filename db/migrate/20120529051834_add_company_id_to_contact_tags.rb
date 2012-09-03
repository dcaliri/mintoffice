class AddCompanyIdToContactTags < ActiveRecord::Migration
  def change
    # company = Company.find_or_create_by_name("mintech")
    company = Company.first
    [ContactAddressTag, ContactEmailTag, ContactPhoneNumberTag, ContactOtherTag].each do |tag_class|
      add_column tag_class.to_s.tableize.to_sym, :company_id, :integer
      tag_class.update_all(company_id: company.id)
    end
  end
end
