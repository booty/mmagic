# frozen_string_literal: true

class Seeding
  class Seeder
    DEFAULT_NUM_CORPORATIONS = 5..5
    DEFAULT_NUM_REGIONS_PER_CORPORATION = 6..6 # 7..7
    DEFAULT_NUM_SUBREGIONS_PER_REGION = 7..7 # 5..15
    DEFAULT_NUM_UNITS_PER_SUBREGION = 9..9 #25..25 # 10..25
    BATCH_IMPORT_SIZE = 2000
    MONITOR_MAGIC_CORPORATION_NAME = "Monitor Magic, Inc."

    def initialize
      require "faker"
      @start_time = Time.current
      @last_log_time = Time.current
    end

    def seed!
      seed_places!
      seed_checklists!
    end

    def seed_checklists!
      log(" --- start (seeding checklists) ---")
      Checklist.delete_all

      checklist_data = Place.pluck(:id).map do |place_id|
        {
          place_id: place_id,
          name: "Checklist 1",
          contents: {
            "item1": {
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
      Place.delete_all

      seed_corporations!(num_corporations_range: DEFAULT_NUM_CORPORATIONS)
      corporation_places = Place.all.where.not(name: MONITOR_MAGIC_CORPORATION_NAME)
      log("Seeded #{corporation_places.length} corporations")

      seed_regions(
        corporation_places: corporation_places,
        num_regions_per_corporation_range: DEFAULT_NUM_REGIONS_PER_CORPORATION,
      )

      # We can't simply use the records returned by seed_regions, because
      # they won't have id's following the bulk import. This is a limitation
      # of SQLite & activerecord-import; would not be an issue with Postgres
      region_places = Place.all - corporation_places
      log("Seeded #{region_places.length} regions")

      seed_subregions(
        region_places: region_places,
        num_subregions_range: DEFAULT_NUM_SUBREGIONS_PER_REGION,
      )
      subregion_places = Place.all - corporation_places - region_places
      log("Seeded #{subregion_places.length} subregions")

      seed_units(
        subregion_places: subregion_places,
        num_units_range: DEFAULT_NUM_UNITS_PER_SUBREGION,
      )
      total_place_count = Place.count
      unit_place_count = total_place_count - corporation_places.length - region_places.length - subregion_places.length
      log("Seeded #{unit_place_count} units")

      hierarchy_count = rebuild_hierarchy(region_places, subregion_places)
      log("Rebuilt #{hierarchy_count} places_hierarchies for #{total_place_count} places")
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
      ActiveRecord::Base.logger.silence do
        PlaceHierarchy.import(stuff.flatten)
      end
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

    def seed_corporations!(num_corporations_range:)
      mmagic_corporation_place = Place.create(
        name: "Monitor Magic, Inc.",
        place_type: :corporation,
      )

      corporation_places = rand(num_corporations_range).times.map do
        {
          name: Seeding::Generator.corporation_name,
          place_type: :corporation,
          parent_id: mmagic_corporation_place.id,
        }
      end

      ActiveRecord::Base.logger.silence do
        Place.import(corporation_places)
      end
    end

    def seed_regions(corporation_places:, num_regions_per_corporation_range:)
      regions = corporation_places.each.map do |corporation_place|
        num_regions = rand(num_regions_per_corporation_range)
        region_names = Seeding::Text::REGIONS_AND_SUBREGIONS.keys.sample(num_regions)
        region_names.map do |region_name|
          {
            name: region_name,
            place_type: :grouping,
            parent_id: corporation_place.id,
          }
        end
      end
      ActiveRecord::Base.logger.silence do
        Place.import(regions.flatten)
      end
    end

    def seed_subregions(region_places:, num_subregions_range:)
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

      ActiveRecord::Base.logger.silence do
        Place.import(subregion_places)
      end
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

      ActiveRecord::Base.logger.silence do
        Place.import(unit_places, batch_size: BATCH_IMPORT_SIZE)
      end
    end
  end
end
