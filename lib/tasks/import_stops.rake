require 'csv'
# require 'national_grid'
require 'breasal'

namespace :csv do
  desc "Upload bus stop CSV file"
  task :upload_stops => :environment do
    csv_text = File.read File.join(Rails.root, 'lib/assets/bus-stops.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      puts row
      en = Breasal::EastingNorthing.new(easting: row['Location_Easting'].to_f, northing: row['Location_Northing'].to_f)
      latlng = en.to_wgs84 # => {:latitude=>52.67752501534847, :longitude=>-1.8148108086293673}
      latitude = latlng[:latitude]
      longitude = latlng[:longitude]

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
        en = Breasal::EastingNorthing.new(easting: row['Location_Easting'].to_f, northing: row['Location_Northing'].to_f)
        latlng = en.to_wgs84 # => {:latitude=>52.67752501534847, :longitude=>-1.8148108086293673}
        latitude = latlng[:latitude]
        longitude = latlng[:longitude]

        # if row['Run'] == "1" 
        #   puts 1
        # elsif row['Run'] == "2" 
        #   puts 2
        # else
        #   puts ERROR
        #   puts row['Run']
        # end

        if ((row['Run'] == "1") && (Route::WEST_EAST_START1.include? row[0]))
          east_sequence = row['Sequence'].to_f
          west_sequence = nil
        elsif ((row['Run'] == "2") && (Route::WEST_EAST_START1.include? row[0]))
          west_sequence = row['Sequence'].to_f
          east_sequence = nil
        elsif ((row['Run'] == "1") && (Route::EAST_WEST_START1.include? row[0]))
          west_sequence = row['Sequence'].to_f
          east_sequence = nil
        elsif ((row['Run'] == "2") && (Route::EAST_WEST_START1.include? row[0]))
          east_sequence = row['Sequence'].to_f
          west_sequence = nil
        else
          puts ERROR
        end
        # if Route::WEST_EAST_START1.include? row[0] && row['Run'] == "1"
        #   east_sequence = row['Sequence'].to_f
        #   west_sequence = nil
        # elsif Route::WEST_EAST_START1.include? row[0] && row['Run'] == "2"
        #   west_sequence = row['Sequence'].to_f
        #   east_sequence = nil
        # elsif Route::EAST_WEST_START1.include? row[0] && row['Run'] == "1"
        #   west_sequence = row['Sequence'].to_f
        #   east_sequence = nil
        # elsif Route::EAST_WEST_START1.include? row[0] && row['Run'] == "2"
        #   east_sequence = row['Sequence'].to_f
        #   west_sequence = nil
        # else
        #   puts "ERROR"
        # end

        RouteSequence.create(
          :route_name => row[0],
          :direction => row['Run'],
          :sequence => row['Sequence'],
          :east_sequence => east_sequence,
          :west_sequence => west_sequence,
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