# frozen_string_literal: true

# == Schema Information
#
# Table name: sensor_readings
#
#  id         :integer          not null, primary key
#  value      :decimal(16, 4)   not null
#  created_at :datetime
#  sensor_id  :integer          not null
#
# Indexes
#
#  index_sensor_readings_on_sensor_id  (sensor_id)
#
# Foreign Keys
#
#  sensor_id  (sensor_id => sensors.id)
#
class SensorReading < ApplicationRecord
  belongs_to :sensor
end
