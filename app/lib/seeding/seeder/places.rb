# frozen_string_literal: true

class Seeding
  class Seeder
    class Places
      # We do some slightly fugly stuff here in the name of performance
      # so we can rebuild the closure_tree hierarchy later
      # If we switch from SQLite to Postgres we can skip a few steps here
      def self.seed!(log_method:)
        log_method.call("seeding places")
        ActiveRecord::Base.logger.silence do
          mmagic_corporation_place = seed_mmagic_corporation!
          seed_corporations!(
            num_corporations_range: DEFAULT_NUM_CORPORATIONS,
            mmagic_corporation_place: mmagic_corporation_place,
          )
          corporation_places = Place.all - [mmagic_corporation_place]

          # We can't simply use the records returned by seed_regions, because
          # they won't have id's following the bulk import. This is a limitation
          # of SQLite & activerecord-import; would not be an issue with Postgres
          seed_regions(
            corporation_places: corporation_places,
            num_regions_per_corporation_range: DEFAULT_NUM_REGIONS_PER_CORPORATION,
          )
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

          rebuild_hierarchy(
            log_method,
            mmagic_corporation_place,
            corporation_places,
            region_places,
            subregion_places,
            unit_places,
          )
        end
      end

      # Closure_tree's .rebuild! method is extremely inefficient; ~13sec for ~3K groups
      # so, we do it ourselves. we can do it quickly because we know the tree structure
      # and even more quickly because we use activerecord-import for a bulk insert
      # Now takes ~0.5sec for ~3K groups
      # TODO: needs tests
      private_class_method def self.rebuild_hierarchy(log_method, mmagic_corporation_place, corporation_places, region_places, subregion_places, unit_places)
        log_method.call("rebuilding places hierarchy")
        mmagic_place_id = mmagic_corporation_place.id

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
            { **me, ancestor_id: mmagic_place_id, generations: 0 },
          ]
        end

        # REGIONS
        stuff << region_places.map(&:id).map do |id|
          me = { descendant_id: id }
          [
            { **me, ancestor_id: id, generations: 0 },
            { **me, ancestor_id: parent_ids[id], generations: 1 },
            { **me, ancestor_id: mmagic_place_id, generations: 2 },
          ]
        end

        # SUBREGIONS
        stuff << subregion_places.map(&:id).map do |id|
          me = { descendant_id: id }
          [
            { **me, ancestor_id: id, generations: 0 },
            { **me, ancestor_id: parent_ids[id], generations: 1 },
            { **me, ancestor_id: get_ancestor_id(parent_ids, id, 2), generations: 2 },
            { **me, ancestor_id: mmagic_place_id, generations: 3 },
          ]
        end

        # UNITS
        stuff << unit_places.map(&:id).map do |id|
          me = { descendant_id: id }
          [
            { **me, ancestor_id: id, generations: 0 },
            { **me, ancestor_id: parent_ids[id], generations: 1 },
            { **me, ancestor_id: get_ancestor_id(parent_ids, id, 2), generations: 2 },
            { **me, ancestor_id: get_ancestor_id(parent_ids, id, 3), generations: 3 },
            { **me, ancestor_id: mmagic_place_id, generations: 4 },
          ]
        end

        result = PlaceHierarchy.import(stuff.flatten)
        raise if result.failed_instances.any?
      end

      private_class_method def self.get_ancestor_id(array, id, generations)
        return array[array[array[id]]] if generations == 3
        return array[array[id]] if generations == 2
        raise "This hacky method has nothing for you"
      end

      private_class_method def self.seed_mmagic_corporation!
        Place.create(
          name: "Monitor Magic, Inc.",
          place_type: :corporation,
        )
      end

      private_class_method def self.seed_corporations!(num_corporations_range:, mmagic_corporation_place:)
        corporation_places = Array.new(rand(num_corporations_range)) do
          {
            name: Seeding::Generator.corporation_name,
            place_type: :corporation,
            parent_id: mmagic_corporation_place.id,
          }
        end

        Place.import(corporation_places)
      end

      private_class_method def self.seed_regions(corporation_places:, num_regions_per_corporation_range:)
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

        Place.import(regions)
      end

      private_class_method def self.seed_subregions(region_places:, num_subregions_range:)
        subregion_places = region_places.map do |region|
          num_subregions = rand(num_subregions_range)

          subregion_names = Seeding::Text::REGIONS_AND_SUBREGIONS[region.name].
            sample(num_subregions)

          Array.new(num_subregions) do
            Place.new(
              {
                name: subregion_names.pop || Faker::Books::Dune.city,
                place_type: :grouping,
                parent: region,
              },
            )
          end
        end

        Place.import(subregion_places.flatten)
      end

      # TODO: Generating the place names is somewhat slow: ~500msec
      #       for ~3K names. Could probably precalculate 50,000 names,
      #       store them in a file, randomly select from there?
      private_class_method def self.seed_units(subregion_places:, num_units_range:)
        unit_places = subregion_places.map do |subregion_place|
          Array.new(rand(num_units_range)) do
            {
              name: Seeding::Generator.restaurant_name,
              place_type: :restaurant,
              parent_id: subregion_place.id,
            }
          end
        end

        Place.import(unit_places.flatten, batch_size: BATCH_IMPORT_SIZE)
      end
    end
  end
end
