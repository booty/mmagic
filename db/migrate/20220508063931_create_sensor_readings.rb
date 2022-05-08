class CreateSensorReadings < ActiveRecord::Migration[7.0]
  def change
    create_table :sensor_readings do |t|
      t.references :sensor, null: false, foreign_key: true
      t.decimal :value, null: false, precision: 16, scale: 4
      t.timestamp :created_at
    end
  end
end
