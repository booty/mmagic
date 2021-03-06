# == Schema Information
#
# Table name: sensors
#
#  id                           :integer          not null, primary key
#  active                       :boolean
#  fake_data_max                :decimal(16, 4)
#  fake_data_mean               :decimal(16, 4)
#  fake_data_min                :decimal(16, 4)
#  fake_data_standard_deviation :decimal(16, 4)
#  name                         :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  place_id                     :integer          not null
#  sensor_type_id               :integer          not null
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
require "test_helper"

class SensorTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end
end
