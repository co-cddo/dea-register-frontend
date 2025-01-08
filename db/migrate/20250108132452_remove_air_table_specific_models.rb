class RemoveAirTableSpecificModels < ActiveRecord::Migration[7.0]
  def change
    drop_table :air_table_bases do |t|
      t.string :name
      t.string :permission_level
      t.string :base_id

      t.timestamps
    end

    drop_table :air_table_tables do |t|
      t.string :name
      t.string :record_id

      t.timestamps
    end
  end
end
