# frozen_string_literal: true

class Seeding
  class Seeder
    class SensorReadings
      MINUTES_PER_DAY = 1440

      # 68% of temps will fall within 1stdev
      # Daily temps that fall
      def self.sine_daily_temps(quantity:, min:, max:, standard_deviation:)
        result = Array.new(quantity) { Array.new(2) }

        mean = (min + max) / 2
        current_minute = 0
        step = MINUTES_PER_DAY / quantity
        amplitude = (max - min) / 2

        quantity.times do |index|
          result[index][0] = current_minute
          fuck = (2 * Math::PI * current_minute) / MINUTES_PER_DAY - 120
          result[index][1] = mean - (Math.cos(fuck) * amplitude)
          current_minute += step
        end

        result
      end

      # generate a pure sine wave between max and min
      def self.sine_series(quantity:, min:, max:)
        result = Array.new(quantity)

        mean = (min + max) / 2
        quantity.times do |y|
          result[y - 1] = mean + (Math.sin(y) * (max - mean))
        end
        result
      end
    end
  end
end
