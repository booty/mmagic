# == Schema Information
#
# Table name: sensors
#
#  id             :integer          not null, primary key
#  active         :boolean
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  place_id       :integer          not null
#  sensor_type_id :integer          not null
#
# Indexes
#
#  index_sensors_on_place_id        (place_id)
#  index_sensors_on_sensor_type_id  (sensor_type_id)
#
# Foreign Keys
#
#  place_id        (place_id => places.id)
#  sensor_type_id  (sensor_type_id => sensor_types.id)
#
class Sensor < ApplicationRecord
  belongs_to :sensor_type
  belongs_to :place
end
