# frozen_string_literal: true

class Seeding
  class Seeder
    class Sensors
      def seed!(sensors_per_place:, log_method:)
        log_method.call(" --- start (seeding sensors) ---")

        sensor_types = SensorType.all

        sensors = Place.all.map do |place|
          Array.new(rand(sensors_per_place)) do
            # TODO: creative name, etc
            # TODO: vary the fake data values instead of copying verbatim
            sensor_type = sensor_types.sample
            {
              active: true,
              place_id: place.id,
              sensor_type_id: sensor_type.id,
              fake_data_min: sensor_type.fake_data_min,
              fake_data_max: sensor_type.fake_data_max,
              fake_data_mean: sensor_type.fake_data_mean,
              fake_data_standard_deviation: sensor_type.fake_data_standard_deviation,
            }
          end
        end.flatten

        Sensor.import(sensors)
      end
    end
  end
end
