# frozen_string_literal: true

# == Schema Information
#
# Table name: sensor_types
#
#  id                             :integer          not null, primary key
#  name                           :string           not null
#  units_denominator              :string
#  units_denominator_abbreviation :string
#  units_numerator                :string           not null
#  units_numerator_abbreviation   :string           not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
class SensorType < ApplicationRecord
end
