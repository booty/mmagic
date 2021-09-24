# frozen_string_literal: true

class Seeding
  class Seeder
    DEFAULT_NUM_REGIONS = 7..7 # 7..7
    DEFAULT_NUM_SUBREGIONS_PER_REGION = 10..10 # 5..15
    DEFAULT_NUM_UNITS_PER_SUBREGION = 20..20 #25..25 # 10..25
    BATCH_IMPORT_SIZE = 2000

    def initialize
      require "faker"
      @start_time = Time.current
      @last_log_time = Time.current
    end

    # We do some slightly fugly stuff here in the name of performance
    # so we can rebuild the closure_tree hierarchy later
    # If we switch from SQLite to Postgres we can skip a few steps here
    def seed_places!
      log(" --- start ---")
      Place.delete_all

      seed_regions(num_regions_range: DEFAULT_NUM_REGIONS)
      # We can't simply use the records returned by seed_regions, because
      # they won't have id's following the bulk import. This is a limitation
      # of SQLite & activerecord-import; would not be an issue with Postgres
      region_places = Place.all
      log("Seeded #{region_places.length} regions")

      seed_subregions(
        region_places: region_places,
        num_subregions_range: DEFAULT_NUM_SUBREGIONS_PER_REGION,
      )
      subregion_places = Place.all - region_places
      log("Seeded #{subregion_places.length} subregions")

      seed_units(
        subregion_places: subregion_places,
        num_units_range: DEFAULT_NUM_UNITS_PER_SUBREGION,
      )
      log("Seeded #{Place.count - region_places.length - subregion_places.length} units")

      hierarchy_count = rebuild_hierarchy(region_places, subregion_places)
      log("Rebuilt #{hierarchy_count} places_hierarchies")
    end

    private

    # Closure_tree's .rebuild! method is extremely inefficient; ~13sec for ~3K groups
    # so, we do it ourselves. we can do it quickly because we know the tree structure
    # and even more quickly because we use activerecord-import for a bulk insert
    # Now takes ~0.5sec for ~3K groupsP
    def rebuild_hierarchy(region_places, subregion_places)
      PlaceHierarchy.delete_all
      region_place_ids = region_places.map(&:id)
      subregion_place_ids = subregion_places.map(&:id)
      region_and_subregion_place_ids = (region_place_ids + subregion_place_ids)

      unit_place_ids = Place.where.not(id: region_and_subregion_place_ids).pluck(:id)

      parent_ids = Place.
        pluck(:id, :parent_id).
        each_with_object({}) { |x, memo| memo[x[0]] = x[1] }

      stuff = []

      stuff << unit_place_ids.map do |unit_place_id|
        parent_id = parent_ids[unit_place_id]
        grandparent_id = parent_ids[parent_ids[unit_place_id]]
        me = { descendant_id: unit_place_id }
        [
          { **me, ancestor_id: unit_place_id, generations: 0 },
          { **me, ancestor_id: parent_id, generations: 1 },
          { **me, ancestor_id: grandparent_id, generations: 2 },
        ]
      end

      stuff << subregion_place_ids.map do |subregion_place_id|
        me = { descendant_id: subregion_place_id }
        [
          { **me, ancestor_id: subregion_place_id, generations: 0 },
          { **me, ancestor_id: parent_ids[subregion_place_id], generations: 1 },
        ]
      end

      stuff << region_place_ids.map do |region_place_id|
        { ancestor_id: region_place_id, descendant_id: region_place_id, generations: 0 }
      end
      PlaceHierarchy.import(stuff.flatten)
      stuff.flatten.length
    end

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

    def seed_subregions(region_places:, num_subregions_range:)
      subregion_places = region_places.map do |region|
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

      Place.import(subregion_places)
      subregion_places
    end

    # TODO:
    #   Generating the place names is somewhat slow: ~500msec for ~3K names
    #   Could probably precalculate 50,000 names, store them in a file, randomly
    #   select from there?
    def seed_units(subregion_places:, num_units_range:)
      unit_places = subregion_places.map do |subregion_place|
        rand(num_units_range).times.map do
          if roll_d100 < 66
            {
              name: Seeding::Generator.restaurant_name,
              place_type: :restaurant,
              parent_id: subregion_place.id,
            }
          else
            {
              name: Seeding::Generator.restaurant_name,
              place_type: :restaurant,
              parent_id: subregion_place.id,
            }
          end
        end
      end.flatten

      Place.import(unit_places, batch_size: BATCH_IMPORT_SIZE)
      unit_places
    end
  end
end
