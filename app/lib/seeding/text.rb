# frozen_string_literal: true

class Seeding
  class Text
    REGIONS_AND_SUBREGIONS = {
      "Monitor Magic, Inc." => [
        "Headquarters",
      ],
      "Antarctica" => [
        "East Antarctica", "West Antarctica", "Ross Sea", "Ross Ice Shelf", "Marie Byrd Land",
        "Queen Elizabeth Range", "Dome Circle", "Terre Adelie", "Wilkes Land",
        "Wilhelm II Land", "Ronne Ice Shelf", "Antarctic Peninsula", "Weddell Sea",
        "Bellingshausen Sea", "Amundsen Sea", "Prydz Bay", "Shackleton Ice Shelf",
        "Transantarctic Mountains", "Amery Ice Shelf", "South Pole",
        "Underground Alien Landing Base"
      ].freeze,
      "Australia" => [
        "Australian Capital Territory", "New South Wales", "Northern Territory", "Queensland",
        "South Australia", "Tasmania", "Victoria", "Western Australia", "Blue Mountains",
        "Lake Eyre Basin", "Outback", "Sunraysia", "East Coast of Australia", "Murray-Darling Basin",
        "Capricorn Coast", "Brisbane", "Granite Belt", "Darwin Region", "Top End", "Bottom End",
        "Bogan Country", "Granola Belt", "Kangaroo Country", "Hume", "Steve Irwin's Backyard",
        "Shipwreck Coast", "Great Barrier Reef"
      ].freeze,
      "North America" => [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Connecticut", "Delaware",
        "Florida", "Hawaii", "Idaho", "Indiana", "Iowa", "Kentucky", "Louisiana", "Maryland",
        "Massachusetts", "Minnesota", "Missouri", "Nebraska", "New Hampshire", "New Jersey",
        "New Mexico", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
        "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia",
        "Washington", "West Virginia", "Wisconsin", "Wyoming", "Alberta", "British Columbia",
        "Manitoba", "New Brunswick", "Newfoundland and Labrador", "Northwest Territories",
        "Nova Scotia", "Nunavut", "Rust Belt", "Area 51", "Jersey Shore", "Midwest Area",
        "Northeast Area", "Pacific West Area", "Plains Area", "Southeast Area"
      ].freeze,
      "South America" => [
        "Argentina", "Bolivia", "Brazil", "Chile", "Colombia", "Ecuador", "Guyana", "Paraguay",
        "Peru", "Suriname", "Uruguay", "Venezuela", "Falkland Islands", "South Georgia",
        "South Sandwich Islands", "French Guiana", "Amazon Rain Forest", "Argentine Patagonia",
        "Machu Picchu", "Galapagos Islands", "Chilean Patagonia ", "Easter Island", "Belize",
        "Pampas", "Secret Island", "Floating City (Possibly Not Real)"
      ].freeze,
      "Central America" => [
        "Belize", "Costa Rica", "El Salvador", "Guatemala", "Honduras", "Nicaragua", "Panama",
        "Panama Canal Zone", "Carribean Tectonic Plate", "Volcanic Lair Zone", "Sierra Madre",
        "Jungle Fortress Area", "Subtropical Moist Broadleaf Forests ", "Isla de San Andres ",
        "Isla de Providencia", "Baja Neuvo", "Islas del Cisne ", "Reserva Biologica India Maiz",
        "Santa Ana Volcano"
      ].freeze,
      "Europe" => [
        "Albania", "Andorra", "Armenia", "Austria", "Azerbaijan", "Belarus", "Belgium",
        "Bosnia and Herzegovina", "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Denmark",
        "Estonia", "Finland", "France", "Georgia", "Germany", "Greece", "Hungary", "Iceland",
        "Ireland", "Italy", "Kazakhstan", "Latvia", "Liechtenstein", "Lithuania", "Luxembourg",
        "Macedonia", "Malta", "Moldova", "Monaco", "Montenegro", "Netherlands", "Norway",
        "Poland", "Portugal", "Romania", "Russia", "San Marino", "Serbia", "Slovakia",
        "Slovenia", "Spain", "Sweden", "Switzerland", "Turkey", "Ukraine", "United Kingdom",
        "Vatican City"
      ].freeze,
      "Asia" => [
        "Afghanistan", "Armenia", "Azerbaijan", "Bahrain", "Bangladesh", "Bhutan", "Brunei",
        "Cambodia", "China", "Cyprus", "East Timor", "Egypt", "Georgia", "India", "Indonesia",
        "Iran", "Iraq", "Israel", "Japan", "Jordan", "Kazakhstan", "Kuwait", "Kyrgyzstan",
        "Laos", "Lebanon", "Malaysia", "Maldives", "Mongolia", "Myanmar", "Nepal",
        "North Korea", "Oman", "Pakistan", "Palestine", "Philippines", "Qatar", "Russia",
        "Saudi Arabia", "Singapore", "South Korea", "Sri Lanka", "Syria", "Taiwan",
        "Tajikistan", "Thailand", "Turkey", "Turkmenistan", "United Arab Emirates",
        "Uzbekistan", "Vietnam", "Yemen"
      ].freeze,
      "Mars" => [
        "Aonia Terra", "Arabia Terra", "Terra Cimmeria", "Margaritifer Terra", "Noachis Terra",
        "Promethei Terra", "Terra Sabaea", "Terra Sirenum", "Tempe Terra", "Tyrrhena Terra",
        "Xanthe Terra", "Acidalia Planitia", "Amazonis Planitia", "Arcadia Planitia",
        "Argyre Planitia", "Chryse Planitia", "Elysium Planitia", "Eridania Planitia",
        "Hellas Planitia", "Isidis Planitia", "Utopia Planitia"
      ].freeze,
      "Space" => [
        "Oort Cloud", "Local Galaxy Cluster", "Local Void", "Asteroid Belt", "Low Earth Orbit",
        "Lagrange Point L1", "Lagrange Point L2", "Lagrange Point L3", "Lagrange Point L4",
        "Andromeda Galaxy", "Milky Way (Scutum–Centaurus Arm)", "Milky Way (Carina-Sagittarius Arm)",
        "Milky Way (Orion–Cygnus Arm)", "Milky Way (Perseus Arm)", "Horsehead Nebula",
        "Crab Nebula", "Ring Nebula"
      ].freeze,
      "Mercury" => [
        "Borealis Quadrangle", "Victoria Quadrangle", "Shakespeare Quadrangle", "Kuiper Quadrangle",
        "Beethoven Quadrangle", "Tolstoj Quadrangle", "Discovery Quadrangle", "Michelangelo Quadrangle",
        "Bach Quadrangle", "Caloris Basin ", "Rembrandt Impact Basin", "Alien Base (North)",
        "Alien Base (South)", "Hollow Interior", "Africanus Horton Crater", "Ahmad Baba Crater",
        "Aneirin Crater", "Beethoven Crater", "Cervantes Crater", "Dostoevskij Crater",
        "Ellington Crater", "Goethe Crater", "Faulkner Crater", "Homer Crater", "Jobim Crater"
      ].freeze,
      "Venus" => [
        "Baltis Vallis", "Maat Mons", "Upper Atmosphere", "Lower Atmosphere", "Ishtar Terra",
        "Aphrodite Terra", "Lakshmi Planum", "Sedna Planitia", "Anala Mons", "Gula Mons",
        "Sacajawea Patera", "Sapas Mons", "Renpet Mons", "Ozza Mons ", "Jaszai Patera", "Ushas Mons",
        "Addams Crater", "Rosa Bonheur Crater", "Sabin Crater ", "Saskla Crater ", "Seiko Crater",
        "Tsvetayeva Crater ", "Truth Crater", "Vigée-Lebrun Crater"
      ].freeze,
      "Moon" => [
        "Moon Kingdom", "Moon Castle", "Tycho crater", "Copernicus crater", "Oceanus Procellarum",
        "Oceanus Procellarum", "Mare Frigoris", "Mare Imbrium", "Mare Fecunditatis", "Mare Tranquillitatis",
        "Catena Michelson", "Vallis Snellius", "Vallis Planck", "Mons Huygens", "Mons Hadley",
        "Mons Bradley", "Montes Rook", "Mons Ampère", "Mons Wolff", "Palus Epidemiarum", "Palus Somni",
        "Mare Nectaris", "Von Braun Base", "Anaheim Electronics", "Granada City"
      ].freeze,
      "Jupiter" => [
        "Io", "Europa", "Ganymede", "Callisto", "Leda", "Himalia", "Lysithea", "Great Red Spot",
        "Metallic Planetary Core", "Halo Ring", "Gossamer Ring", "Main Ring", "Amalthea", "Metis",
        "Orbiting Labratory", "Space Station XHG-13", "Dimensional Gate ", "Astral Gate",
        "Floating Continent"
      ].freeze,
      "Saturn" => [
        "Aegaeon", "Alkyonides", "Atlas", "Daphnis", "Dione", "Enceladus", "Epimetheus", "Hyperion",
        "Iapetus", "Janus", "Mimas", "Norse", "Pan", "Pandora", "Prometheus", "Rhea", "Tethys",
        "Titan", "A Ring", "B Ring", "C Ring", "D Ring", "E Ring ", "Roche Division", "Phoebe Ring",
        "Encke Gap"
      ].freeze,
      "Neptune" => [
        "Naiad", "Thalassa", "Despina", "Galatea", "Larissa", "Hippocamp", "Proteus", "Triton",
        "Nereid", "Halimede", "Sao", "Laomedeia", "Psamathe", "Neso", "Space Station A",
        "Alien Base 5892.X", "Interstellar Rest Stop", "McDonalds #48993"
      ].freeze,
    }.freeze

    ECCENTRIC_FACILITY_ADJECTIVES = %w{
      experimental secret special evil tantric advanced secret
      metaphysical transcendental spiritual combat speculative
      alchemical randomized nuclear chemical cybernetic augmented
      psychic paranormal esoteric theoretical supernatural incorporeal
      alien dark nuclear advanced ceremonial astral esoteric
      gnostic applied cosmic
    }.freeze

    SCIENCE_ADJECTIVES = %w{
      superheated radioactive ionized theoretical quantum
      laser crystallized supercharged synthesized
    }.freeze

    BORING_FACILITY_TYPES = %w{
      headquarters HQ offices complex facility building compound
    }.freeze

    ORGANIZATIONAL_UNITS = %w{
      team department organization corps resources squad experts
      section bureau agency ministry wing unit coven cabal mob lab
      force workshop institute building complex
    }.freeze

    FACTORY_SYNONYMS = %w{
      factory workshop forge mill mine refinery plant
    }.freeze

    DODGY_PROFESSIONS = %w{
      astrology alchemy dowsing exorcism conjuring feng\ shui geomancy
      occultism palmistry
    }.freeze

    REGION_NAME_PREFIXES = %w{
      shadow evil underground bizarro negative mirror-universe
    }.freeze

    ELEMENTS = %w{
      Hydrogen Helium Lithium Beryllium Boron Carbon Nitrogen Oxygen Fluorine
      Neon Sodium Magnesium Aluminum Silicon Phosphorus Sulfur Chlorine Argon
      Potassium Calcium Scandium Titanium Vanadium Chromium Manganese Iron
      Cobalt Nickel Copper Zinc Gallium Germanium Arsenic Selenium Bromine
      Krypton Rubidium Strontium Yttrium Zirconium Niobium Molybdenum Technetium
      Ruthenium Rhodium Palladium Silver
    }.freeze

    RESTAURANT_TYPES = %w{
      cafeteria restaurant pub gastropub café grill catering diner bistro
      truck sports\ bar bar dive\ bar hut zone shack brewpub
    }.freeze

    FOOD_CATEGORIES = %w{
      pizza italian\ food chinese-american BBQ random\ fried\ objects sushi
      burgers asian curry american\ food soul\ food hot\ dogs ice\ cream tacos
      frozen\ yogurt steak seafood donuts
    }.freeze

    COMBINATION_WORDS = %w{
      amalgamated allied cooperative united
    }.freeze

    RESTAURANT_ADJECTIVES = %w{
      fast greasy spicy hot tasty delicious fried outrageous fancy authentic
      frozen premium
    }.freeze

    FOOD_AND_EATING_TERMS = %w{
      food grub dining experience delights cuisine
    }.freeze

    RESTAURANT_JOIN_WORDS = %w{+ & n'}.freeze

    RESTAURANT_PREFIXES = %w{uptown downtown famous original oldfashioned homestyle}.freeze

    COLD_LIQUID_FOODS = %w{
      milkshake gazpacho iced\ tea beer soda water juice pudding custard protein
      butter sherbert whipped\ cream borscht mayo butter
    }.freeze

    HOT_LIQUID_FOODS = %w{
      soup gravy cheese\ dip chili stew marinara\ sauce mashed\ potatoes broth tea
    }.freeze

    HOT_SOLID_FOODS = [
      "chicken", "hamburger", "french fries", "cheesesteaks", "fried chicken",
      "nachos", "meatloaf", "waffle", "pancake", "sandwich", "chili dog", "spaghetti",
      "gnocchi", "noodles", "ramen", "quesdilla", "salisbury steak", "brisket", "curry",
      "broccoli", "panini", "omelette", "flounder"
    ].freeze

    COLD_SOLID_FOODS = %w{
      tomato pickle lettuce radish cheese sushi salad tuna\ salad
      onions apple orange
    }.freeze

    ALL_SOLID_FOODS = (COLD_SOLID_FOODS + HOT_SOLID_FOODS).freeze

    ALL_LIQUID_FOODS = (COLD_LIQUID_FOODS + HOT_LIQUID_FOODS).freeze

    ALL_FOODS = (ALL_SOLID_FOODS + ALL_LIQUID_FOODS).freeze

    ALCOHOLIC_BEVERAGES = %w{
      beer wine gin ale grog vodka cognac Bud\ Light Coors brandy
      beer beer beer beer
    }.freeze

    LIQUID_DEVICES = %w{
      fountain trough nozzle pool squirter dispenser drizzler hose tap
      keg chiller collar gun sprayer
    }.freeze

    COOKING_DEVICES = %w{
      steamer oven fryer furnace microwave rotisserie warmer toaster grill
      roaster inferno
    }.freeze

    COOLING_DEVICES = %w{fridge freezer chiller cooler}.freeze

    CLEANING_VERBS = %w{
      mop sweep bleach disinfect clean sterilize wipe scrub obliterate scrape hose\ down
    }.freeze

    CLEANING_AREAS = %w{kitchen floor entrance tables booths bathrooms everything}.freeze

    CLEANING_ADJECTIVES = %w{thoroughly quickly violently meticulously ruthlessly carefully}.freeze

    CLEANING_SUBSTANCES = %w{bleach harsh\ language fire soap ammonia water sulphuric\ acid}.freeze

    MISC_RESTAURANT_TASKS = [
      "count money", "lock doors", "unlock doors", "exterminate all customers",
      "trash rival restaurants", "falsify accounting documents", "bribe safety inspectors",
      "test fire sprinklers", "refill napkins", "refill dispensers", "get drunk", "wipe down menus",
      "put quarters in jukebox", "look for rats", "reconsider life options", "choose new career",
      "replace air filters", "wash uniforms", "swear oath of secrecy", "placate mafia",
      "evacuate customers for no apparent reason", "alphabetize spice rack",
    ].freeze

    FOOD_VERBS = %w{
      fry bake cook freeze decontaminate prep fondle fricasse pound tenderize warm
      chill blend puree chop grease oil
    }.freeze

    THINGS_TO_CHECK_FOR = %w{
      leaks radiation stains rats pests foul\ odors
      ice\ crystals signs\ of\ life moondust spoilage
    }.freeze

    RESTAURANT_NO_QUESTIONS = [
      "Is the restaurant on fire?", "Does the entire staff appear to be on drugs?",
      "Are you on drugs?", "Have all the cooks quit?", "Were there any stabbings today?",
      "Are the customers brawling?"
    ].freeze

    LIQUID_CONSUMPTION_VERBS = %w{quaff guzzle sip slurp taste chug drink swill}.freeze

    EQUIPMENT_VERBS = %w{
      refurbish admire calibrate power-cycle reboot arm discharge jiggle
      upgrade replace shake focus
    }.freeze

    PLACEMENT_VERBS = %w{place stuff insert cram shove toss drop}.freeze

    SYNONYMS_FOR_CHECKING = %w{check ponder confirm examine}.freeze

    POSTPRANDIAL_DISPOSITIONS = %w{happy full somebody\ says\ stop satisfied}.freeze

    UNFAVORABLE_DISPOSITION = %w{shortage disaster crisis incident panic calamity}.freeze

    FUTURISTIC_COMPANY_ADJECTIVES = %w{
      interplanetary orbital space holographic cybernetic cyborg extraterrestrial
    }.freeze

    COMPANY_PREFIX = %w{hyper cyber mega giga nano bio micro omni}.freeze

    COMPANY_SUFFIX = %w{tech dyne corp mega gen com}.freeze

    STANDARD_SENSOR_TYPES = {
      indoor_temp: {
        name: "Indoor Temp",
        units_numerator: "Centigrade",
        units_numerator_abbreviation: "°C",
        fake_data_min: 0,
        fake_data_max: 40,
        fake_data_mean: 21,
        fake_data_standard_deviation: 5,
      },
      outdoor_temp: {
        name: "Outdoor Temp",
        units_numerator: "Centigrade",
        units_numerator_abbreviation: "°C",
        fake_data_min: -10,
        fake_data_max: 50,
        fake_data_mean: 21,
        fake_data_standard_deviation: 10,
      },
      barometer: {
        name: "Barometer",
        units_numerator: "Millibars",
        units_numerator_abbreviation: "mb",
        fake_data_min: 870,
        fake_data_max: 1084,
        fake_data_mean: 1013,
        fake_data_standard_deviation: 50,
      },
      humidity: {
        name: "Humidity",
        units_numerator: "%",
        units_numerator_abbreviation: "%",
        fake_data_min: 20,
        fake_data_max: 100,
        fake_data_mean: 65,
        fake_data_standard_deviation: 10,
      },
      radiation: {
        name: "Radiation",
        units_numerator: "Sieverts",
        units_numerator_abbreviation: "Sv",
        units_denominator: "Hour",
        units_denominator_abbreviation: "Hr",
        fake_data_min: 0,
        fake_data_max: 10,
        fake_data_mean: 1,
        fake_data_standard_deviation: 1,
      },
    }
  end
end
