class RenameAirTables < ActiveRecord::Migration[7.0]
  def change
    rename_table(:air_tables, :data_tables)
  end
end
