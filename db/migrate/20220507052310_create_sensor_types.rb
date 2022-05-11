class CreateSensorTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :sensor_types do |t|
      t.string :name, null: false, length: 100
      t.string :units_numerator, null: false, length: 100
      t.string :units_denominator, null: true, length: 100, default: nil
      t.string :units_numerator_abbreviation, null: false, length: 100
      t.string :units_denominator_abbreviation, null: true, length: 100, default: nil
      t.timestamps
    end
  end
end
