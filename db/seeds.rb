# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

routes = Route.create([
  {name: "11", description: "St.Paul's Cathedral, Houses of Parliament and Sloane Square", start_stop: "King's road/Chelsea", end_stop: "Liverpool Street"},
  {name: "15", description: "Regent Street shopping, London City and Tower of London", start_stop: "Regent Street", end_stop: "Tower of London"},
  {name: "14", description: "Museums - V&A, Science, Natural History, British Museum", start_stop: "South Kensington", end_stop: "British Museum"}, 
  {name: "RV1", description: "Covent Garden, Southbank, and Tower Bridge", start_stop: "Covent Garden", end_stop: "Tower of London"},
  {name: "139", description: "Abbey Road, Baker Street, Madame Tussaud's, Oxford Street, Trafalgar Square, Waterloo", start_stop: "Abbey Road", end_stop: "South Bank/Waterloo"}, 
  {name: "9", description: "Pall Mall, St.Jame's Park, Hyde Park, Royal Albert Hall", start_stop: "High Street Kensington", end_stop: "Trafalgar Square/National Gallery"}, 
  {name: "274", description: "Hyde Park, Baker Street, Regent's Park, London Zoo", start_stop: "Lancaster Gate/Hyde Park", end_stop: "Camden Lock Market"}
  ])

# AudioClip.create(
#   name: "GA", 
#   route_id: Route.find_by(name: "11").id,
#   address: "9 Back Hill London EC1R 5EN",
#   image_file: "/assets/ga-london.jpg", 
#   audio_file: "/sounds/general-assembly.mp3"
#   )

# AudioClip.create(
#   name: "Goya Restaurant", 
#   route_id: Route.find_by(name: "11").id,
#   address: "36 Lupus Street London SW1V 3EB",
#   image_file: "/assets/goya.jpg",
#   audio_file: "/sounds/general-assembly.mp3"
#   )

AudioClip.create(
  name: "Bank of England", 
  route_id: Route.find_by(name: "11").id,
  address: "Threadneedle St, London EC2R 8AH",
  image_file: "/assets/bank-of-england.jpg", 
  audio_file: "/sounds/bank-of-england.mp3", 
  west_sequence: 3.1, 
  east_sequence: 35.1 
  )

AudioClip.create(
  name: "St Paul's Cathedral", 
  route_id: Route.find_by(name: "11").id,
  address: "St. Paul's Churchyard, London EC4M 8AD",
  image_file: "/assets/st-pauls-cathedral.jpg", 
  audio_file: "/sounds/st-pauls-cathedral.mp3", 
  west_sequence: 4.1, 
  east_sequence: 32.1, 
  main_attraction: true
  )

AudioClip.create(
  name: "Fleet Street", 
  route_id: Route.find_by(name: "11").id,
  address: "Peterborough Court, 133 Fleet St, London EC4A 2BB",
  image_file: "/assets/fleet-street.jpg", 
  audio_file: "/sounds/fleet-street.mp3", 
  west_sequence: 7.1, 
  east_sequence: 30.1
  )

AudioClip.create(
  name: "Royal Courts of Justice", 
  route_id: Route.find_by(name: "11").id,
  address: "Royal Courts of Justice Strand, London WC2A 2LL",
  image_file: "/assets/royal-courts-of-justice.jpg", 
  audio_file: "/sounds/royal-courts-of-justice.mp3", 
  west_sequence: 10.1, 
  east_sequence: 29.1
  )

AudioClip.create(
  name: "London School of Economics", 
  route_id: Route.find_by(name: "11").id,
  address: "Houghton St, London WC2A 2AE",
  image_file: "/assets/london-school-economics.jpg", 
  audio_file: "/sounds/london-school-economics.mp3", 
  west_sequence: 11.1, 
  east_sequence: 28.1
  )

AudioClip.create(
  name: "Lyceum Theatre", 
  route_id: Route.find_by(name: "11").id,
  address: "21 Wellington Street, London WC2E 7RQ",
  image_file: "/assets/lyceum-theatre.jpg", 
  audio_file: "/sounds/lyceum-theatre.mp3", 
  west_sequence: 12.1, 
  east_sequence: 27.1
  )

AudioClip.create(
  name: "Trafalgar Square", 
  route_id: Route.find_by(name: "11").id,
  address: "Trafalgar Square, Westminster, London WC2N 5DN",
  image_file: "/assets/trafalgar-square.jpg", 
  audio_file: "/sounds/trafalgar-square.mp3", 
  west_sequence: 14.1, 
  east_sequence: 25.1, 
  main_attraction: true
  )

AudioClip.create(
  name: "10 Downing Street", 
  route_id: Route.find_by(name: "11").id,
  address: "10 Downing St, London SW1A 2AA",
  image_file: "/assets/10-downing-street.jpg", 
  audio_file: "/sounds/10-downing-street.mp3", 
  west_sequence: 17.1, 
  east_sequence: 24.1, 
  main_attraction: true
  )

AudioClip.create(
  name: "Houses of Parliament", 
  route_id: Route.find_by(name: "11").id,
  address: "Houses of Parliament London SW1A 0AA",
  image_file: "/assets/houses-of-parliament.jpg", 
  audio_file: "/sounds/houses-of-parliament.mp3", 
  west_sequence: 18.1, 
  east_sequence: 23.2, 
  main_attraction: true
  )

AudioClip.create(
  name: "Westminster Abbey", 
  route_id: Route.find_by(name: "11").id,
  address: "20 Deans Yd, London SW1P 3PA",
  image_file: "/assets/westminster-abbey.jpg", 
  audio_file: "/sounds/westminster-abbey.mp3", 
  west_sequence: 18.2, 
  east_sequence: 23.1, 
  main_attraction: true
  )

AudioClip.create(
  name: "Victoria Station", 
  route_id: Route.find_by(name: "11").id,
  address: "Victoria Station Victoria Street, London, SW1E 5JX",
  image_file: "/assets/victoria-station.jpg", 
  audio_file: "/sounds/victoria-station.mp3", 
  west_sequence: 22.1, 
  east_sequence: 18.1
  )

AudioClip.create(
  name: "Sloane Square", 
  route_id: Route.find_by(name: "11").id,
  address: "Sloane Square London",
  image_file: "/assets/sloane-square.jpg", 
  audio_file: "/sounds/sloane-square.mp3", 
  west_sequence: 28.1, 
  east_sequence: 13.1
  )

AudioClip.create(
  name: "Saatchi Gallery", 
  route_id: Route.find_by(name: "11").id,
  address: "Duke Of York's HQ, King's Rd, London SW3 4RY",
  image_file: "/assets/saatchi-gallery.jpg", 
  audio_file: "/sounds/saatchi-gallery.mp3", 
  west_sequence: 28.2, 
  east_sequence: 12.1
  )

AudioClip.create(
  name: "King's Road", 
  route_id: Route.find_by(name: "11").id,
  address: "77 King's Rd, London SW3 4NX",
  image_file: "/assets/kings-road.jpg", 
  audio_file: "/sounds/kings-road.mp3", 
  west_sequence: 30.1, 
  east_sequence: 11.1
  )

