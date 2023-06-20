class CreatePowerControlPeople < ActiveRecord::Migration[7.0]
  def change
    create_join_table :powers, :control_people, table_name: :power_control_people do |t|
      t.index %i[power_id control_person_id]
      t.index %i[control_person_id power_id]
    end
  end
end
