# frozen_string_literal: true

require "faker"

NUM_REGIONS = 7
NUM_SUBREGIONS_PER_REGION = 5..15
NUM_UNITS_PER_SUBREGION = 10..25

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

class Seeds
  REGIONS_AND_SUBREGIONS = {
    "Antarctica" => ["East Antarctica", "West Antarctica", "Ross Sea", "Ross Ice Shelf", "Marie Byrd Land", "Queen Elizabeth Range", "Dome Circle", "Terre Adelie", "Wilkes Land", "Wilhelm II Land", "Ronne Ice Shelf", "Antarctic Peninsula", "Weddell Sea", "Bellingshausen Sea", "Amundsen Sea", "Prydz Bay", "Shackleton Ice Shelf", "Transantarctic Mountains", "Amery Ice Shelf", "South Pole", "Underground Alien Landing Base"],
    "Australia" => ["Australian Capital Territory", "New South Wales", "Northern Territory", "Queensland", "South Australia", "Tasmania", "Victoria", "Western Australia", "Blue Mountains", "Lake Eyre Basin", "Outback", "Sunraysia", "East Coast of Australia", "Murray-Darling Basin", "Capricorn Coast", "Brisbane", "Granite Belt", "Darwin Region", "Top End", "Bottom End", "Bogan Country", "Granola Belt", "Kangaroo Country", "Hume", "Steve Irwin's Backyard", "Shipwreck Coast", "Great Barrier Reef"],
    "North America" => ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Connecticut", "Delaware", "Florida", "Hawaii", "Idaho", "Indiana", "Iowa", "Kentucky", "Louisiana", "Maryland", "Massachusetts", "Minnesota", "Missouri", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming", "Alberta", "British Columbia", "Manitoba", "New Brunswick", "Newfoundland and Labrador", "Northwest Territories", "Nova Scotia", "Nunavut", "Rust Belt", "Area 51", "Jersey Shore", "Midwest Area", "Northeast Area", "Pacific West Area", "Plains Area", "Southeast Area"],
    "South America" => ["Argentina", "Bolivia", "Brazil", "Chile", "Colombia", "Ecuador", "Guyana", "Paraguay", "Peru", "Suriname", "Uruguay", "Venezuela", "Falkland Islands", "South Georgia", "South Sandwich Islands", "French Guiana", "Amazon Rain Forest", "Argentine Patagonia", "Machu Picchu", "Galapagos Islands", "Chilean Patagonia ", "Easter Island", "Belize", "Pampas", "Secret Island", "Floating City (Possibly Not Real)"],
    "Central America" => ["Belize", "Costa Rica", "El Salvador", "Guatemala", "Honduras", "Nicaragua", "Panama", "Panama Canal Zone", "Carribean Tectonic Plate", "Volcanic Lair Zone", "Sierra Madre", "Jungle Fortress Area", "Subtropical Moist Broadleaf Forests ", "Isla de San Andres ", "Isla de Providencia", "Baja Neuvo", "Islas del Cisne ", "Reserva Biologica India Maiz", "Santa Ana Volcano"],
    "Europe" => ["Albania", "Andorra", "Armenia", "Austria", "Azerbaijan", "Belarus", "Belgium", "Bosnia and Herzegovina", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "Finland", "France", "Georgia", "Germany", "Greece", "Hungary", "Iceland", "Ireland", "Italy", "Kazakhstan", "Latvia", "Liechtenstein", "Lithuania", "Luxembourg", "Macedonia", "Malta", "Moldova", "Monaco", "Montenegro", "Netherlands", "Norway", "Poland", "Portugal", "Romania", "Russia", "San Marino", "Serbia", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland", "Turkey", "Ukraine", "United Kingdom", "Vatican City"],
    "Asia" => ["Afghanistan", "Armenia", "Azerbaijan", "Bahrain", "Bangladesh", "Bhutan", "Brunei", "Cambodia", "China", "Cyprus", "East Timor", "Egypt", "Georgia", "India", "Indonesia", "Iran", "Iraq", "Israel", "Japan", "Jordan", "Kazakhstan", "Kuwait", "Kyrgyzstan", "Laos", "Lebanon", "Malaysia", "Maldives", "Mongolia", "Myanmar", "Nepal", "North Korea", "Oman", "Pakistan", "Palestine", "Philippines", "Qatar", "Russia", "Saudi Arabia", "Singapore", "South Korea", "Sri Lanka", "Syria", "Taiwan", "Tajikistan", "Thailand", "Turkey", "Turkmenistan", "United Arab Emirates", "Uzbekistan", "Vietnam", "Yemen"],
    "Mars" => ["Aonia Terra", "Arabia Terra", "Terra Cimmeria", "Margaritifer Terra", "Noachis Terra", "Promethei Terra", "Terra Sabaea", "Terra Sirenum", "Tempe Terra", "Tyrrhena Terra", "Xanthe Terra", "Acidalia Planitia", "Amazonis Planitia", "Arcadia Planitia", "Argyre Planitia", "Chryse Planitia", "Elysium Planitia", "Eridania Planitia", "Hellas Planitia", "Isidis Planitia", "Utopia Planitia"],
    "Space" => ["Oort Cloud", "Local Galaxy Cluster", "Local Void", "Asteroid Belt", "Low Earth Orbit", "Lagrange Point L1", "Lagrange Point L2", "Lagrange Point L3", "Lagrange Point L4", "Andromeda Galaxy", "Milky Way (Scutum–Centaurus Arm)", "Milky Way (Carina-Sagittarius Arm", "Milky Way (Orion–Cygnus Arm)", "Milky Way (Perseus Arm)", "Horsehead Nebula", "Crab Nebula", "Ring Nebula"],
    "Mercury" => ["Borealis Quadrangle", "Victoria Quadrangle", "Shakespeare Quadrangle", "Kuiper Quadrangle", "Beethoven Quadrangle", "Tolstoj Quadrangle", "Discovery Quadrangle", "Michelangelo Quadrangle", "Bach Quadrangle", "Caloris Basin ", "Rembrandt Impact Basin", "Alien Base (North)", "Alien Base (South)", "Hollow Interior", "Africanus Horton Crater", "Ahmad Baba Crater", "Aneirin Crater", "Beethoven Crater", "Cervantes Crater", "Dostoevskij Crater", "Ellington Crater", "Goethe Crater", "Faulkner Crater", "Homer Crater", "Jobim Crater"],
    "Venus" => ["Baltis Vallis", "Maat Mons", "Upper Atmosphere", "Lower Atmosphere", "Ishtar Terra", "Aphrodite Terra", "Lakshmi Planum", "Sedna Planitia", "Anala Mons", "Gula Mons", "Sacajawea Patera", "Sapas Mons ", "Renpet Mons", "Ozza Mons ", "Jaszai Patera", "Ushas Mons ", "Addams Crater", "Rosa Bonheur Crater", "Sabin Crater ", "Saskla Crater ", "Seiko Crater", "Tsvetayeva Crater ", "Truth Crater", "Vigée-Lebrun Crater"],
    "Moon" => ["Moon Kingdom", "Moon Castle", "Tycho crater", "Copernicus crater", "Oceanus Procellarum", "Oceanus Procellarum", "Mare Frigoris", "Mare Imbrium", "Mare Fecunditatis", "Mare Tranquillitatis", "Catena Michelson", "Vallis Snellius", "Vallis Planck", "Mons Huygens", "Mons Hadley", "Mons Bradley", "Montes Rook", "Mons Ampère", "Mons Wolff", "Palus Epidemiarum", "Palus Somni", "Mare Nectaris", "Von Braun Base", "Anaheim Electronics", "Granada City"],
    "Jupiter" => ["Io", "Europa", "Ganymede", "Callisto", "Leda", "Himalia", "Lysithea", "Great Red Spot", "Metallic Planetary Core", "Halo Ring", "Gossamer Ring", "Main Ring", "Amalthea", "Metis", "Orbiting Labratory", "Space Station XHG-13", "Dimensional Gate ", "Astral Gate", "Floating Continent"],
    "Saturn" => ["Aegaeon", "Alkyonides‎", "Atlas", "Daphnis", "Dione", "Enceladus‎", "Epimetheus", "Hyperion‎", "Iapetus‎", "Janus", "Mimas‎", "Norse", "Pan", "Pandora", "Prometheus", "Rhea", "Tethys‎", "Titan", "A Ring", "B Ring", "C Ring", "D Ring", "E Ring ", "Roche Division", "Phoebe Ring", "Encke Gap"],
    "Neptune" => ["Naiad", "Thalassa", "Despina", "Galatea", "Larissa", "Hippocamp", "Proteus", "Triton", "Nereid", "Halimede", "Sao", "Laomedeia", "Psamathe", "Neso", "Space Station A", "Alien Base 5892.X", "Interstellar Rest Stop", "McDonalds #48993"],
  }

  ECCENTRIC_FACILITY_ADJECTIVES = ["experimental", "secret", "special", "evil", "tantric", "advanced", "secret", "metaphysical", "transcendental", "spiritual", "combat", "speculative", "alchemical", "randomized", "nuclear", "chemical", "cybernetic", "augmented", "psychic", "paranormal", "esoteric", "theoretical", "supernatural", "incorporeal", "alien", "dark", "nuclear", "advanced", "ceremonial", "astral", "esoteric", "gnostic", "applied", "cosmic"].freeze

  SCIENCE_ADJECTIVES = ["superheated", "radioactive", "ionized", "theoretical", "quantum", "laser", "crystallized", "supercharged", "synthesized"]

  BORING_FACILITY_TYPES = ["headquarters", "HQ", "offices", "complex", "facility", "building", "compound"]

  ORGANIZATIONAL_UNITS = ["team", "department", "organization", "corps", "resources", "squad", "experts", "section", "bureau", "agency", "ministry", "wing", "unit", "coven", "cabal", "mob", "lab", "force", "workshop", "institute", "building", "complex"].freeze

  FACTORY_SYNONYMS = ["factory", "workshop", "forge", "mill", "mine", "refinery", "plant"].freeze

  DODGY_PROFESSIONS = ["astrology", "alchemy", "dowsing", "exorcism", "conjuring", "feng shui", "geomancy", "occultism", "palmistry"].freeze

  REGION_NAME_PREFIXES = ["shadow", "evil", "underground", "bizarro", "negative", "mirror universe", "Grimdark"].freeze

  ELEMENTS = ["Hydrogen", "Helium", "Lithium", "Beryllium", "Boron", "Carbon", "Nitrogen", "Oxygen", "Fluorine", "Neon", "Sodium", "Magnesium", "Aluminum", "Silicon", "Phosphorus", "Sulfur", "Chlorine", "Argon", "Potassium", "Calcium", "Scandium", "Titanium", "Vanadium", "Chromium", "Manganese", "Iron", "Cobalt", "Nickel", "Copper", "Zinc", "Gallium", "Germanium", "Arsenic", "Selenium", "Bromine", "Krypton", "Rubidium", "Strontium", "Yttrium", "Zirconium", "Niobium", "Molybdenum", "Technetium", "Ruthenium", "Rhodium", "Palladium", "Silver"].freeze

  RESTAURANT_TYPES = ["cafeteria", "restaurant", "pub", "gastropub", "café", "grill", "catering", "diner", "bistro", "truck", "sports bar", "bar", "dive bar", "hut", "zone", "shack", "brewpub"].freeze

  FOOD_CATEGORIES = ["pizza", "italian food", "chinese-american", "BBQ", "random fried objects", "sushi", "burgers", "asian", "curry", "american food", "soul food", "hot dogs", "ice cream", "tacos", "frozen yogurt", "steak", "seafood", "donuts"].freeze

  COMBINATION_WORDS = ["amalgamated", "allied", "cooperative", "united"].freeze

  RESTAURANT_ADJECTIVES = %w{fast greasy spicy hot tasty delicious fried outrageous fancy authentic frozen discount premium}.freeze

  FOOD_AND_EATING_TERMS = %w{food grub dining experience delights cuisine}.freeze

  RESTAURANT_JOIN_WORDS = %w{+ & n'}.freeze

  RESTAURANT_PREFIXES = %w{uptown downtown famous original}.freeze

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
        words << RESTAURANT_JOIN_WORDS.sample
      end
      words << Faker::Name.first_name.possessive
    when 4
      words << Faker::Name.last_name.possessive
    when 5
      words << Faker::Name.last_name
      words << "Bros." if roll_d100 < 30
    end
  end

  def self.restaurant_name
    words = []

    words << restaraunt_possessive if roll_d100 < 60
    words << RESTAURANT_PREFIXES.sample if roll_d100 < 20
    words << RESTAURANT_ADJECTIVES.sample if roll_d100 < 60
    words << ECCENTRIC_FACILITY_ADJECTIVES.sample if roll_d100 < 10
    words << SCIENCE_ADJECTIVES.sample if roll_d100 < 20
    if roll_d100 < 50
      words << coinflip(Faker::Dessert.variety, FOOD_CATEGORIES.sample)
      words << "& #{FOOD_CATEGORIES.sample}" if roll_d100 < 33
    else
      words << Faker::Food.ethnic_category
      words << coinflip(Faker::Dessert.variety, FOOD_CATEGORIES.sample) if roll_d100 < 20
      words << FOOD_AND_EATING_TERMS.sample if roll_d100 < 50
    end
    words << RESTAURANT_TYPES.sample if roll_d100 < 80

    words.join(" ").smart_titleize
  end

  def self.facility_name(debug: false)
    words = []

    case rand(0..6)
    when 0
      words << "(0)" if debug
      words << Seeds::ECCENTRIC_FACILITY_ADJECTIVES.sample
      words << Faker::Science.science
      words << Seeds::ORGANIZATIONAL_UNITS.sample
    when 1
      words << "(1)" if debug
      words << Faker::Science.modifier
      words << Seeds::ELEMENTS.sample
      words << Seeds::FACTORY_SYNONYMS.sample
    when 2
      words << "(2)" if debug
      words << ECCENTRIC_FACILITY_ADJECTIVES.sample if roll_d100 < 20
      words << Faker::Science.tool
      words << coinflip(Seeds::ORGANIZATIONAL_UNITS.sample, Seeds::FACTORY_SYNONYMS.sample)
    when 3
      words << "(3)" if debug
      words << Faker::Job.field
      words << coinflip(Faker::University.suffix)
    when 4
      words << "(4)" if debug
      words << Faker::IndustrySegments.industry
      words << Seeds::BORING_FACILITY_TYPES.sample
    when 5
      words << "(5)" if debug
      words << Faker::Science.scientist if roll_d100 < 20
      words << "#{Seeds::ELEMENTS.sample}-#{Seeds::ELEMENTS.sample}"
      words << Seeds::FACTORY_SYNONYMS.sample
    when 6
      words << "(6)" if debug
      words << Seeds::COMBINATION_WORDS.sample if roll_d100 < 30
      words << Seeds::DODGY_PROFESSIONS.sample
      words << " & "
      words << Seeds::ECCENTRIC_FACILITY_ADJECTIVES.sample if roll_d100 < 40
      words << Faker::Job.field
      words << Seeds::ORGANIZATIONAL_UNITS.sample
    end

    words.flatten.join(" ").smart_titleize
  end

  def self.seed_places!
    Place.delete_all

    # Create "regions"
    region_names = Seeds::REGIONS_AND_SUBREGIONS.keys.sample(rand(NUM_REGIONS))
    regions = region_names.map do |region_name|
      Place.new(
        {
          name: region_name,
          place_type: :grouping,
        },
      )
    end
    Rails.logger.info("Importing #{regions.length} regions")
    Place.import(regions)
    # TODO: reload all Places so we get id's

    # Create geographic "subregions" under the regions
    subregions = regions.map do |region|
      num_subregions = rand(NUM_SUBREGIONS_PER_REGION)
      subregion_names = Seeds::REGIONS_AND_SUBREGIONS[region.name].sample(num_subregions)
      Rails.logger.debug("  will create #{num_subregions} subregions for region #{region.name}")

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
    Rails.logger.info("Importing #{subregions.length} subregions")
    Place.import(subregions)
    # TODO: reload all Places so we get id's

    # Create "units" (facilities, restaurants) under the "divisions"
    units = subregions.map do |subregion|
      # rand(NUM_UNITS_PER_SUBREGION)
      rand(NUM_UNITS_PER_SUBREGION).times.map do
        if roll_d100 < 66
          Place.new(
            name: facility_name,
            place_type: :facility,
            parent: subregion,
          )
        else
          Place.new(
            name: restaurant_name,
            place_type: :restaurant,
            parent: subregion,
          )
        end
      end
    end.flatten
    Rails.logger.info("Importing #{units.length} units")
    Place.import(units)
  end
end
