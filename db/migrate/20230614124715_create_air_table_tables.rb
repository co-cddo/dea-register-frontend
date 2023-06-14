class CreateAirTableTables < ActiveRecord::Migration[7.0]
  def change
    create_table :air_table_tables do |t|
      t.string :name
      t.string :record_id

      t.timestamps
    end
  end
end
