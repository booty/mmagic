# frozen_string_literal: true

class Seeding
  class Seeder
    DEFAULT_NUM_REGIONS = 7..7 # 7..7
    DEFAULT_NUM_SUBREGIONS_PER_REGION = 15..15 # 5..15
    DEFAULT_NUM_UNITS_PER_SUBREGION = 25..25 # 10..25
    BATCH_IMPORT_SIZE = 1000

    def initialize
      @start_time = Time.current
      @last_log_time = Time.current
    end

    def seed_places!
      Place.delete_all

      regions = seed_regions(
        num_regions_range: DEFAULT_NUM_REGIONS,
      )
      log("Seeded #{regions.length} regions")

      subregions = seed_subregions(
        regions: regions,
        num_subregions_range: DEFAULT_NUM_UNITS_PER_SUBREGION,
      )
      log("Seeded #{subregions.length} subregions")

      units = seed_units(
        subregions: subregions,
        num_units_range: DEFAULT_NUM_UNITS_PER_SUBREGION,
      )
      log("Seeded #{units.length} units")

      [regions, subregions, units].sum(&:length)
    end

    private

    def log(msg)
      location = caller_locations(1, 1)[0]
      caller_method = location.label
      lineno = location.lineno
      elapsed_total = Time.current - @start_time
      elapsed_since_last = Time.current - @last_log_time
      elapsed_total_formatted = ("%2.2f" % elapsed_total).rjust(5, " ")
      elapsed_since_last_formatted = ("%2.2f" % elapsed_since_last).rjust(5, " ")
      Rails.logger.info "#{self.class.name} #{caller_method}##{lineno} "\
                        "#{elapsed_total_formatted}s /#{elapsed_since_last_formatted}s | "\
                        "#{msg}"

      @last_log_time = Time.current
    end

    def roll_d100
      rand(1..100)
    end

    def seed_regions(num_regions_range:)
      num_regions = rand(num_regions_range)
      region_names = Seeding::Generator::REGIONS_AND_SUBREGIONS.keys.sample(num_regions)

      regions = region_names.map do |region_name|
        Place.new(
          {
            name: region_name,
            place_type: :grouping,
          },
        )
      end

      Place.import(regions)
      regions
    end

    def seed_subregions(regions:, num_subregions_range:)
      subregions = regions.map do |region|
        num_subregions = rand(num_subregions_range)
        subregion_names = Seeding::Generator::REGIONS_AND_SUBREGIONS[region.name].
          sample(num_subregions)

        num_subregions.times.map do
          Place.new(
            {
              name: subregion_names.pop || Faker::Books::Dune.city,
              place_type: :grouping,
              parent: region,
            },
          )
        end
      end.flatten

      Place.import(subregions)

      subregions
    end

    def seed_units(subregions:, num_units_range:)
      units = subregions.map do |subregion|
        rand(num_units_range).times.map do
          if roll_d100 < 66
            # Place.new(
            #   name: Seeding::Generator.facility_name,
            #   place_type: :facility,
            #   parent: subregion,
            # )
            {
              name: Seeding::Generator.restaurant_name,
              place_type: :restaurant,
            }
          else
            # Place.new(
            #   name: Seeding::Generator.restaurant_name,
            #   place_type: :restaurant,
            #   parent: subregion,
            # )
            {
              name: Seeding::Generator.restaurant_name,
              place_type: :restaurant,
            }
          end
        end
      end.flatten

      Place.import(units, batch_size: BATCH_IMPORT_SIZE)
      units
    end
  end
end
