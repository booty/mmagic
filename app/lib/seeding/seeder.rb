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
      nuke_all!
      seed_places!
      Seeding::Seeder::SensorTypes.seed!
      seed_sensors!
      seed_checklists!
    end

    def nuke_all!
      log(" --- nuking old data ---")
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
      log(" --- start (seeding checklists) ---")

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

    # We do some slightly fugly stuff here in the name of performance
    # so we can rebuild the closure_tree hierarchy later
    # If we switch from SQLite to Postgres we can skip a few steps here
    def seed_places!
      log(" --- start (seeding places) ---")
      mmagic_corporation_place = seed_mmagic_corporation!
      seed_corporations!(
        num_corporations_range: DEFAULT_NUM_CORPORATIONS,
        mmagic_corporation_place: mmagic_corporation_place,
      )
      corporation_places = Place.all - [mmagic_corporation_place]

      seed_regions(
        corporation_places: corporation_places,
        num_regions_per_corporation_range: DEFAULT_NUM_REGIONS_PER_CORPORATION,
      )

      # We can't simply use the records returned by seed_regions, because
      # they won't have id's following the bulk import. This is a limitation
      # of SQLite & activerecord-import; would not be an issue with Postgres
      region_places = Place.all - corporation_places - [mmagic_corporation_place]

      seed_subregions(
        region_places: region_places,
        num_subregions_range: DEFAULT_NUM_SUBREGIONS_PER_REGION,
      )
      subregion_places = Place.all - corporation_places - region_places - [mmagic_corporation_place]

      seed_units(
        subregion_places: subregion_places,
        num_units_range: DEFAULT_NUM_UNITS_PER_SUBREGION,
      )
      unit_places = Place.all - corporation_places - region_places - subregion_places - [mmagic_corporation_place]

      hierarchy_count = rebuild_hierarchy(
        mmagic_corporation_place,
        corporation_places,
        region_places,
        subregion_places,
        unit_places,
      )
    end

    private

    # Closure_tree's .rebuild! method is extremely inefficient; ~13sec for ~3K groups
    # so, we do it ourselves. we can do it quickly because we know the tree structure
    # and even more quickly because we use activerecord-import for a bulk insert
    # Now takes ~0.5sec for ~3K groups
    # TODO: needs tests
    def rebuild_hierarchy(mmagic_corporation_place, corporation_places, region_places, subregion_places, unit_places)
      log(" --- rebuilding places hierarchy ---")

      parent_ids = Place.
        pluck(:id, :parent_id).
        each_with_object({}) { |x, memo| memo[x[0]] = x[1] }

      # ROOT
      # we don't need to insert it, because we inserted the root
      # mmagic place "normally" and not via bulk insert

      # CORPORATIONS
      stuff = corporation_places.map do |corporation_place|
        me = { descendant_id: corporation_place.id }
        [
          { **me, ancestor_id: corporation_place.id, generations: 0 },
          { **me, ancestor_id: mmagic_corporation_place.id, generations: 0 },
        ]
      end

      # REGIONS
      stuff << region_places.map do |region_place|
        id = region_place.id
        corporation_parent_id = parent_ids[id]
        me = { descendant_id: id }
        [
          { **me, ancestor_id: id, generations: 0 },
          { **me, ancestor_id: corporation_parent_id, generations: 1 },
          { **me, ancestor_id: mmagic_corporation_place.id, generations: 2 },
        ]
      end

      # SUBREGIONS
      stuff << subregion_places.map do |subregion_place|
        id = subregion_place.id
        region_parent_id = parent_ids[id]
        corporation_grandparent_id = parent_ids[parent_ids[id]]
        me = { descendant_id: id }
        [
          { **me, ancestor_id: id, generations: 0 },
          { **me, ancestor_id: region_parent_id, generations: 1 },
          { **me, ancestor_id: corporation_grandparent_id, generations: 2 },
          { **me, ancestor_id: mmagic_corporation_place.id, generations: 3 },
        ]
      end

      # UNITS
      stuff << unit_places.map do |unit_place|
        id = unit_place.id
        subregion_parent_id = parent_ids[id]
        region_grandparent_id = parent_ids[parent_ids[id]]
        corporation_ggrandparent_id = parent_ids[parent_ids[parent_ids[id]]]
        me = { descendant_id: id }
        [
          { **me, ancestor_id: id, generations: 0 },
          { **me, ancestor_id: subregion_parent_id, generations: 1 },
          { **me, ancestor_id: region_grandparent_id, generations: 2 },
          { **me, ancestor_id: corporation_ggrandparent_id, generations: 3 },
          { **me, ancestor_id: mmagic_corporation_place.id, generations: 4 },
        ]
      end

      result = ActiveRecord::Base.logger.silence do
        PlaceHierarchy.import(stuff.flatten)
      end
      raise if result.failed_instances.any?

      PlaceHierarchy.count
    end

    def log(msg)
      location = caller_locations(1, 1)[0]
      caller_method = location.label
      lineno = location.lineno
      elapsed_total = Time.current - @start_time
      elapsed_since_last = Time.current - @last_log_time
      elapsed_total_formatted = sprintf("%2.2f", elapsed_total).rjust(5, " ")
      elapsed_since_last_formatted = sprintf("%2.2f", elapsed_since_last).rjust(5, " ")
      Rails.logger.info "#{self.class.name} #{caller_method}:#{lineno} "\
                        "#{elapsed_total_formatted}s /#{elapsed_since_last_formatted}s | "\
                        "#{msg}"

      @last_log_time = Time.current
    end

    def roll_d100
      rand(1..100)
    end

    def seed_mmagic_corporation!
      Place.create(
        name: "Monitor Magic, Inc.",
        place_type: :corporation,
      )
    end

    def seed_corporations!(num_corporations_range:, mmagic_corporation_place:)
      log(" --- seeding corporations ---")

      corporation_places = rand(num_corporations_range).times.map do
        {
          name: Seeding::Generator.corporation_name,
          place_type: :corporation,
          parent_id: mmagic_corporation_place.id,
        }
      end

      log("importing #{corporation_places.length} corporation_places")
      ActiveRecord::Base.logger.silence do
        Place.import(corporation_places)
      end
    end

    def seed_regions(corporation_places:, num_regions_per_corporation_range:)
      log(" --- start (seeding regions) ---")
      regions = corporation_places.map do |corporation_place|
        num_regions = rand(num_regions_per_corporation_range)
        region_names = Seeding::Text::REGIONS_AND_SUBREGIONS.keys.sample(num_regions)
        region_names.map do |region_name|
          {
            name: region_name,
            place_type: :grouping,
            parent_id: corporation_place.id,
          }
        end
      end.flatten

      log("importing #{regions.length} regions")
      ActiveRecord::Base.logger.silence do
        Place.import(regions)
      end
    end

    def seed_subregions(region_places:, num_subregions_range:)
      log(" --- start (seeding subregions) ---")
      subregion_places = region_places.map do |region|
        num_subregions = rand(num_subregions_range)

        subregion_names = Seeding::Text::REGIONS_AND_SUBREGIONS[region.name].
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

      log("importing #{subregion_places.length} subregions")
      ActiveRecord::Base.logger.silence do
        Place.import(subregion_places)
      end
    end

    # TODO: Generating the place names is somewhat slow: ~500msec
    #       for ~3K names. Could probably precalculate 50,000 names,
    #       store them in a file, randomly select from there?
    def seed_units(subregion_places:, num_units_range:)
      log(" --- start (seeding units) ---")
      unit_places = subregion_places.map do |subregion_place|
        rand(num_units_range).times.map do
          {
            name: Seeding::Generator.restaurant_name,
            place_type: :restaurant,
            parent_id: subregion_place.id,
          }
        end
      end.flatten

      log("importing #{unit_places.length} unit_places")
      ActiveRecord::Base.logger.silence do
        Place.import(unit_places, batch_size: BATCH_IMPORT_SIZE)
      end
    end
  end
end
