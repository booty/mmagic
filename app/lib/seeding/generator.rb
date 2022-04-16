# frozen_string_literal: true

class Seeding
  # Words and generators for place names
  class Generator
    def self.coinflip(*strings)
      strings.sample
    end

    def self.roll_d100
      rand(1..100)
    end

    def self.restaraunt_possessive
      words = []

      case rand(1..5)
      when 1..3
        if roll_d100 < 30
          words << Faker::Name.first_name
          words << Seeding::Text::RESTAURANT_JOIN_WORDS.sample
        end
        words << Faker::Name.first_name.possessive
      when 4
        words << Faker::Name.last_name.possessive
      when 5
        words << Faker::Name.last_name
        words << "Bros." if roll_d100 < 30
      end
    end

    def self.corporation_name
      require "faker"
      words = []
      case rand(0..4)
      when 0
        words << Faker::Company.name
        words << Seeding::Text::FUTURISTIC_COMPANY_ADJECTIVES.sample if roll_d100 < 75
        words << Faker::Company.industry
        words << Faker::Company.suffix if roll_d100 < 25
      when 1
        words << Faker::TvShows::RickAndMorty.location
        words << Faker::Science.science
        words << "&"
        words << Seeding::Text::SCIENCE_ADJECTIVES.sample if roll_d100 < 50
        words << Seeding::Text::DODGY_PROFESSIONS.sample
      when 2
        words << Seeding::Text::ECCENTRIC_FACILITY_ADJECTIVES.sample
        words << Faker::IndustrySegments.industry
      when 3
        words << Seeding::Text::COMBINATION_WORDS.sample
        words << Seeding::Text::ELEMENTS.sample
        words << Seeding::Text::FACTORY_SYNONYMS.sample.pluralize
      when 4
        words << "#{Seeding::Text::COMPANY_PREFIX.sample}#{Seeding::Text::COMPANY_SUFFIX.sample}"
        if roll_d100 < 50
          words << Seeding::Text::ECCENTRIC_FACILITY_ADJECTIVES.sample if roll_d100 < 33
          words << Faker::Science.science
        end
      end

      case rand(0..5)
      when 0
        words << ", Inc."
      when 1
        words << ", LLC"
      when 2
        words << "Corp."
      when 3
        words << "Company"
      end

      words.join(" ").gsub("\s,", ",").smart_titleize
    end

    def self.restaurant_name
      require "faker"
      words = []

      words << restaraunt_possessive if roll_d100 < 60
      words << Seeding::Text::RESTAURANT_PREFIXES.sample if roll_d100 < 20
      words << Seeding::Text::RESTAURANT_ADJECTIVES.sample if roll_d100 < 60
      words << Seeding::Text::ECCENTRIC_FACILITY_ADJECTIVES.sample if roll_d100 < 10
      words << Seeding::Text::SCIENCE_ADJECTIVES.sample if roll_d100 < 20
      if roll_d100 < 50
        words << coinflip(Faker::Dessert.variety, Seeding::Text::FOOD_CATEGORIES.sample)
        words << "& #{Seeding::Text::FOOD_CATEGORIES.sample}" if roll_d100 < 33
      else
        words << Faker::Food.ethnic_category
        words << coinflip(Faker::Dessert.variety, Seeding::Text::FOOD_CATEGORIES.sample) if roll_d100 < 20
        words << Seeding::Text::FOOD_AND_EATING_TERMS.sample if roll_d100 < 50
      end
      words << Seeding::Text::RESTAURANT_TYPES.sample if roll_d100 < 80

      words.join(" ").smart_titleize
    end

    def self.facility_name
      require "faker"
      words = []

      case rand(0..6)
      when 0
        words << Seeding::Text::ECCENTRIC_FACILITY_ADJECTIVES.sample
        words << Faker::Science.science
        words << Seeding::Text::ORGANIZATIONAL_UNITS.sample
      when 1
        words << Faker::Science.modifier
        words << Seeding::Text::ELEMENTS.sample
        words << Seeding::Text::FACTORY_SYNONYMS.sample
      when 2
        words << Seeding::Text::ECCENTRIC_FACILITY_ADJECTIVES.sample if roll_d100 < 20
        words << Faker::Science.tool
        words << coinflip(Seeding::Text::ORGANIZATIONAL_UNITS.sample, Seeding::Text::FACTORY_SYNONYMS.sample)
      when 3
        words << Faker::Job.field
        words << coinflip(Faker::University.suffix)
      when 4
        words << Faker::IndustrySegments.industry
        words << Seeding::Text::BORING_FACILITY_TYPES.sample
      when 5
        words << Faker::Science.scientist if roll_d100 < 20
        words << "#{Seeding::Text::ELEMENTS.sample}-#{Seeding::Text::ELEMENTS.sample}"
        words << Seeding::Text::FACTORY_SYNONYMS.sample
      when 6
        words << Seeding::Text::COMBINATION_WORDS.sample if roll_d100 < 30
        words << Seeding::Text::DODGY_PROFESSIONS.sample
        words << " & "
        words << Seeding::Text::ECCENTRIC_FACILITY_ADJECTIVES.sample if roll_d100 < 40
        words << Faker::Job.field
        words << Seeding::Text::ORGANIZATIONAL_UNITS.sample
      end

      words.flatten.join(" ").smart_titleize
    end

    def self.restaurant_checklist_item
      words = []
      completed_or_not_completed = {
        type: "pick_one",
        multiple_choice_values: "completed|not completed",
        multiple_choice_values_correct: "completed",
      }

      item = case rand(0..11)
             when 0
               words << Seeding::Text::CLEANING_ADJECTIVES.sample if roll_d100 < 30
               words << Seeding::Text::CLEANING_VERBS.sample
               words << Seeding::Text::CLEANING_AREAS.sample
               words << "with #{Seeding::Text::CLEANING_SUBSTANCES.sample}" if roll_d100 < 50
               {
                 **completed_or_not_completed,
               }
             when 1
               words << Seeding::Text::SYNONYMS_FOR_CHECKING.sample
               words << "#{Seeding::Text::COLD_SOLID_FOODS.sample}"
               words << "temperature"
               {
                 type: "numeric",
                 numeric_min: rand(-50..-30),
                 numeric_max: rand(-29..0),
                 unit: "deg. centigrade",
               }
             when 2
               words << Seeding::Text::MISC_RESTAURANT_TASKS.sample
               {
                 **completed_or_not_completed,
               }
             when 3
               words << Seeding::Text::FOOD_VERBS.sample
               words << Seeding::Text::HOT_SOLID_FOODS.sample
               {
                 **completed_or_not_completed,
               }
             when 4
               words << Seeding::Text::RESTAURANT_NO_QUESTIONS.sample
               {
                 type: "pick one",
                 multiple_choice_values: "no|not really|mostly|yes",
                 multiple_choice_values_correct: "no|not really",
               }
             when 5
               words << "check"
               words << Seeding::Text::CLEANING_AREAS.sample
               words << "for"
               words << Seeding::Text::THINGS_TO_CHECK_FOR.sample
               {
                 **completed_or_not_completed,
               }
             when 6
               words << "check #{(Seeding::Text::HOT_LIQUID_FOODS + Seeding::Text::HOT_SOLID_FOODS).sample} temperature"
               {
                 type: "numeric",
                 numeric_min: rand(50..99),
                 numeric_max: rand(100..500),
                 unit: "deg. centigrade",
               }
             when 7
               words << Seeding::Text::HOT_SOLID_FOODS.sample.pluralize
               words << "sufficently"
               words << "#{Seeding::Text::RESTAURANT_ADJECTIVES.sample}?"
               {
                 type: "pick one",
                 multiple_choice_values: "no|not really|mostly|yes",
                 multiple_choice_values_correct: "mostly|yes",
               }
             when 8
               words << "have a drink of"
               words << Seeding::Text::ALCOHOLIC_BEVERAGES.sample
               {
                 type: "pick one",
                 multiple_choice_values: "no thanks|okay|thanks I needed that",
                 multiple_choice_values_correct: "okay|thanks I needed that",
               }
             when 9
               words << Seeding::Text::LIQUID_CONSUMPTION_VERBS.sample
               words << Seeding::Text::ALL_LIQUID_FOODS.sample
               words << "until #{Seeding::Text::POSTPRANDIAL_DISPOSITIONS.sample}" if roll_d100 < 33
               {
                 type: "pick one",
                 multiple_choice_values: "oh yeah that's nice|tastes good|tastes bad|something is terribly wrong here",
                 multiple_choice_values_correct: "oh yeah that's nice|tastes good",
               }
             when 9
               words << Seeding::Text::CLEANING_ADJECTIVES.sample if roll_d100 < 25
               words << Seeding::Text::EQUIPMENT_VERBS.sample
               words << Seeding::Text::ALL_LIQUID_FOODS.sample
               words << Seeding::Text::LIQUID_DEVICES.sample
               {
                 **completed_or_not_completed,
               }
             when 10
               words << Seeding::Text::PLACEMENT_VERBS.sample
               words << Seeding::Text::ALL_SOLID_FOODS.sample
               words << "into"
               words << Seeding::Text::ALL_SOLID_FOODS.sample
               words << Seeding::Text::COOLING_DEVICES.sample
               {
                 **completed_or_not_completed,
               }
             when 11
               words << %w{brief consult query inform}.sample
               words << Faker::Job.seniority if roll_d100 < 66
               words << Seeding::Text::ALL_FOODS.sample
               words << Faker::Job.position
               words << "about"
               words << Seeding::Text::UNFAVORABLE_DISPOSITION.sample
               {
                 **completed_or_not_completed,
               }
             end

      item.merge(
        {
          name: words.flatten.join(" ").smart_titleize,
          required: [true, true, true, false].sample,
          active: [true, true, true, false].sample,
        },
      )
    end
  end
end
