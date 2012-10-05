class AssociateCreditcardToRawHistories < ActiveRecord::Migration
  def up
    add_column :shinhan_card_used_histories,     :creditcard_id, :integer
    add_column :shinhan_card_approved_histories, :creditcard_id, :integer
    add_column :hyundai_card_used_histories,     :creditcard_id, :integer
    add_column :hyundai_card_approved_histories, :creditcard_id, :integer
    add_column :oversea_card_approved_histories, :creditcard_id, :integer

    ShinhanCardUsedHistory.find_each do |history|
      creditcard = Creditcard.find_by_short_name(history.card_no)
      history.update_column(:creditcard_id, creditcard.id) if creditcard
    end

    ShinhanCardApprovedHistory.find_each do |history|
      creditcard = Creditcard.find_by_short_name(history.card_name)
      history.update_column(:creditcard_id, creditcard.id) if creditcard
    end

    HyundaiCardUsedHistory.find_each do |history|
      creditcard = Creditcard.find_by_short_name(history.card_no)
      history.update_column(:creditcard_id, creditcard.id) if creditcard
    end

    HyundaiCardApprovedHistory.find_each do |history|
      creditcard = Creditcard.find_by_short_name(history.card_number)
      history.update_column(:creditcard_id, creditcard.id) if creditcard
    end

    OverseaCardApprovedHistory.find_each do |history|
      creditcard = Creditcard.find_by_short_name(history.card_name)
      history.update_column(:creditcard_id, creditcard.id) if creditcard
    end
  end

  def down
    remove_column :oversea_card_approved_histories, :creditcard_id
    remove_column :hyundai_card_approved_histories, :creditcard_id
    remove_column :hyundai_card_used_histories,     :creditcard_id
    remove_column :shinhan_card_approved_histories, :creditcard_id
    remove_column :shinhan_card_used_histories,     :creditcard_id
  end
end
