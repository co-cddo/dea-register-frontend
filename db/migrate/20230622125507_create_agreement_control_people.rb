class CreateAgreementControlPeople < ActiveRecord::Migration[7.0]
  def change
    create_join_table :agreements, :control_people, table_name: :agreement_control_people do |t|
      t.index %i[agreement_id control_person_id], name: "agreement_control_people_by_agreement"
      t.index %i[control_person_id agreement_id], name: "agreement_control_people_by_people"
    end
  end
end
