# frozen_string_literal: true

class Seeding
  class Seeder
    class SensorTypes
      def self.seed!
        sensor_types = Seeding::Text::STANDARD_SENSOR_TYPES.values.map do |val|
          SensorType.new(val)
        end

        ActiveRecord::Base.logger.silence do
          SensorType.import(sensor_types)
        end
      end
    end
  end
end
