class CreateUpdateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :update_logs do |t|
      t.date :updated_on
      t.string :comment
      t.boolean :from_seeds, default: false

      t.timestamps
    end
  end
end
