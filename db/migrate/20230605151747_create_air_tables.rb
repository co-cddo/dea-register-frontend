class CreateAirTables < ActiveRecord::Migration[7.0]
  def change
    create_table :air_tables do |t|
      t.string :name
      t.json :fields
      t.string :record_id
      t.string :type

      t.timestamps
    end
  end
end
