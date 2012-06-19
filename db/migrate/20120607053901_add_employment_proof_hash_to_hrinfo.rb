class AddEmploymentProofHashToHrinfo < ActiveRecord::Migration
  def change
    add_column :hrinfos, :employment_proof_hash, :text
  end
end
