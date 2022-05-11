# frozen_string_literal: true

class Seeding
  class Seeder
    DEFAULT_NUM_CORPORATIONS = 5..5
    DEFAULT_NUM_REGIONS_PER_CORPORATION = 6..6 # 7..7
    DEFAULT_NUM_SUBREGIONS_PER_REGION = 7..7 # 5..15
    DEFAULT_NUM_UNITS_PER_SUBREGION = 9..9 # 25..25 # 10..25
    BATCH_IMPORT_SIZE = 2000
    DEFAULT_SENSORS_PER_PLACE = 1..5
    MONITOR_MAGIC_CORPORATION_NAME = "Monitor Magic, Inc."

    def initialize
      require "faker"
      @start_time = Time.current
      @last_log_time = Time.current
    end

    def seed!
      log_method = method(:log)
      nuke_all!
      Seeding::Seeder::Places.seed!(log_method: log_method)
      Seeding::Seeder::SensorTypes.seed!
      seed_sensors!
      seed_checklists!
    end

    def nuke_all!
      log("nuking old data")
      # SQLite does not have an explicit TRUNCATE command
      # However, DELETE w/o a where clause uses an optimization
      # so it's fase.
      # ref: https://www.sqlite.org/lang_delete.html#the_truncate_optimization
      SensorReading.delete_all
      Sensor.delete_all
      SensorType.delete_all
      ChecklistItem.delete_all
      Checklist.delete_all
      PlaceHierarchy.delete_all
      Place.delete_all
      ActiveRecord::Base.connection.execute("VACUUM;")
    end

    def seed_sensors!
      Seeding::Seeder::Sensors.new.seed!(
        sensors_per_place: DEFAULT_SENSORS_PER_PLACE,
        log_method: method(:log),
      )
    end

    def seed_checklists!
      log("seeding checklists")

      checklist_data = Place.pluck(:id).map do |place_id|
        {
          place_id: place_id,
          name: "Checklist 1",
          contents: {
            item1: {
              name: "Item 1",
              numeric_min: place_id,
              numeric_max: place_id,
            },
            "item#{place_id}": {
              name: "Item #{place_id}",
              numeric_min: place_id,
              numeric_max: place_id,
            },
          },
        }
      end

      ActiveRecord::Base.logger.silence do
        Checklist.import(checklist_data)
      end
    end

    private

    def log(msg)
      location = caller_locations(1, 1)[0]
      caller_method = location.label
      lineno = location.lineno
      elapsed_total = Time.current - @start_time
      elapsed_since_last = Time.current - @last_log_time
      elapsed_total_formatted = sprintf("%2.2f", elapsed_total).rjust(5, " ")
      elapsed_since_last_formatted = sprintf("%2.2f", elapsed_since_last).rjust(5, " ")
      Rails.logger.info "[#{self.class.name}] #{caller_method}:#{lineno} "\
                        "#{elapsed_total_formatted}s /#{elapsed_since_last_formatted}s | "\
                        "#{msg}"

      @last_log_time = Time.current
    end

    # def roll_d100
    #   rand(1..100)
    # end
  end
end
