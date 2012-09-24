class ReassociatePaymentRecordsAndBankbooks < ActiveRecord::Migration
  class ::PaymentRecord < ActiveRecord::Base
    has_one :bankbook, as: :holder
  end

  class ::Bankbook < ActiveRecord::Base
    belongs_to :holder, polymorphic: true
  end

  def up
    add_column :payment_records, :bankbook_id, :integer

    PaymentRecord.find_each do |payment_record|
      bankbook = payment_record.bankbook

      if bankbook
        payment_record.update_column(:bankbook_id, bankbook.id)
      end
    end
  end

  def down
    remove_column :payment_records, :bankbook_id
  end
end
