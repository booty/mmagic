class AddFakeDataFieldsToSensors < ActiveRecord::Migration[7.0]
  def change
    add_column :sensors, :fake_data_min, :decimal, precision: 16, scale: 4
    add_column :sensors, :fake_data_max, :decimal, precision: 16, scale: 4
    add_column :sensors, :fake_data_mean, :decimal, precision: 16, scale: 4
    add_column :sensors, :fake_data_standard_deviation, :decimal, precision: 16, scale: 4
  end
end
