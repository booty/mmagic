# == Schema Information
#
# Table name: sensor_types
#
#  id                             :integer          not null, primary key
#  fake_data_max                  :decimal(16, 4)
#  fake_data_mean                 :decimal(16, 4)
#  fake_data_min                  :decimal(16, 4)
#  fake_data_standard_deviation   :decimal(16, 4)
#  name                           :string           not null
#  units_denominator              :string
#  units_denominator_abbreviation :string
#  units_numerator                :string           not null
#  units_numerator_abbreviation   :string           not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
require "test_helper"

class SensorTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
