class DropPeopleAndPowersTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :people do |t|
      t.string :name
      t.json :fields
      t.string :record_id

      t.timestamps
    end

    drop_table :powers do |t|
      t.string :name
      t.json :fields
      t.string :record_id

      t.timestamps
    end
  end
end
