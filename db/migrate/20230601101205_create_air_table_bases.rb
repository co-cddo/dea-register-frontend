class CreateAirTableBases < ActiveRecord::Migration[7.0]
  def change
    create_table :air_table_bases do |t|
      t.string :name
      t.string :permission_level
      t.string :base_id

      t.timestamps
    end
  end
end
