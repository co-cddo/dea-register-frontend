class CreatePowerAgreements < ActiveRecord::Migration[7.0]
  def change
    create_join_table :powers, :agreements, table_name: :power_agreements do |t|
      t.index %i[power_id agreement_id]
      t.index %i[agreement_id power_id]
    end
  end
end
