class CreateSensors < ActiveRecord::Migration[7.0]
  def change
    create_table :sensors do |t|
      t.string :name
      t.references :sensor_type, null: false, foreign_key: true
      t.references :place, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
