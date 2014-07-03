require 'csv'
require 'national_grid'
require 'pry-rails'

namespace :csv do
  desc "Upload bus stop CSV file"
  task :upload_stops => :environment do
    csv_text = File.read File.join(Rails.root, 'lib/assets/bus-stops.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      puts row

      longitude = NationalGrid::EastingNorthing.new(row['Location_Easting'].to_f, row['Location_Northing'].to_f).to_latitude_longitude.longitude unless NationalGrid::EastingNorthing.new(row['Location_Easting'].to_f, row['Location_Northing'].to_f).to_latitude_longitude.nil?

      latitude = NationalGrid::EastingNorthing.new(row['Location_Easting'].to_f, row['Location_Northing'].to_f).to_latitude_longitude.latitude unless NationalGrid::EastingNorthing.new(row['Location_Easting'].to_f, row['Location_Northing'].to_f).to_latitude_longitude.nil?

      Stop.create(
        :stop_code => row['Bus_Stop_Code'],
        :stop_name => row['Stop_Name'],
        :easting => row['Location_Easting'],
        :northing => row['Location_Northing'],
        :longitude => longitude,
        :latitude => latitude
        )
      puts 
    end
  end

  desc "Upload bus sequence CSV file"
  task :upload_sequences => :environment do
    csv_text = File.read File.join(Rails.root, 'lib/assets/bus-sequences.csv')
    csv = CSV.parse(csv_text, :headers => true)
    routes = Route.all.map(&:name)
    puts routes.inspect
    csv.each do |row|
      if routes.include? row[0]
        puts row

        longitude = NationalGrid::EastingNorthing.new(row['Location_Easting'].to_f, row['Location_Northing'].to_f).to_latitude_longitude.longitude unless NationalGrid::EastingNorthing.new(row['Location_Easting'].to_f, row['Location_Northing'].to_f).to_latitude_longitude.nil?

        latitude = NationalGrid::EastingNorthing.new(row['Location_Easting'].to_f, row['Location_Northing'].to_f).to_latitude_longitude.latitude unless NationalGrid::EastingNorthing.new(row['Location_Easting'].to_f, row['Location_Northing'].to_f).to_latitude_longitude.nil?

        RouteSequence.create(
          :route_name => row[0],
          :direction => row['Run'],
          :sequence => row['Sequence'],
          :stop_code => row['Bus_Stop_Code'],
          :stop_name => row['Stop_Name'],
          :northing => row['Location_Northing'],
          :easting => row['Location_Easting'],
          :latitude => latitude,
          :longitude => longitude,
          :stop_id => Stop.find_by(stop_code: row['Bus_Stop_Code']).id,
          :route_id => Route.find_by(name: row[0]).id
        )
      end
    end
  end
end