class CreateAgreementProcessors < ActiveRecord::Migration[7.0]
  def change
    create_join_table :agreements, :processors, table_name: :agreement_processors do |t|
      t.index %i[agreement_id processor_id], name: "agreement_processors_by_agreement"
      t.index %i[processor_id agreement_id], name: "agreement_processors_by_processor"
    end
  end
end
