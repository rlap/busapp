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
  {name: "9", description: "Royal Parks - Pall Mall, St.Jame's Park, Hyde Park, Royal Albert Hall", start_stop: "High Street Kensington", end_stop: "Trafalgar Square/National Gallery"}, 
  {name: "274", description: "Royal Parks - Hyde Park, Baker Street, Regent's Park, London Zoo", start_stop: "Lancaster Gate/Hyde Park", end_stop: "Camden Lock Market"}
  ])

AudioClip.create(
  name: "Buckingham Palace", 
  route_id: Route.find_by(name: "11").id,
  address: "Buckingham Palace London SW1A 1AA"
  )

AudioClip.create(
  name: "GA", 
  route_id: Route.find_by(name: "11").id,
  address: "9 Back Hill London EC1R 5EN"
  )

AudioClip.create(
  name: "British Museum", 
  route_id: Route.find_by(name: "11").id,
  address: "The British Museum Great Russell St London WC1B 3DG"
  )

AudioClip.create(
  name: "Goya Restaurant", 
  route_id: Route.find_by(name: "11").id,
  address: "36 Lupus Street London SW1V 3EB"
  )


