class Sensor < ApplicationRecord
  belongs_to :sensor_type
  belongs_to :place
end
