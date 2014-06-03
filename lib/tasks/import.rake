desc "Import Data From Directory"
require "csv"
require "bson"
require "moped"

task :import => :environment do

  trip = Trip.create
  puts "Folder Name:"
  directory = "public/trip_dir/#{STDIN.gets.chomp}"
  puts "Looking into '#{directory}'"
  frames = Dir.entries(directory + "/images").count.to_s
  puts "Framerate:"
  frame_rate = STDIN.gets.chomp

  puts "Title:"
  title = STDIN.gets.chomp

  puts "Description:"
  description = STDIN.gets.chomp


  start_time = DateTime.new
  end_time = DateTime.new

  x = 1
  File.foreach(directory + '/tracker.csv') do |csv_line|
    row = CSV.parse(csv_line.gsub("|",'"')).first
    unless row[0] == "ID"
      reference_id =  row[0]
      moment_time = row[1].to_datetime.in_time_zone('Pacific Time (US & Canada)')
      if x == 1
        start_time =  moment_time
        x += 1
      end

      end_time  = moment_time
      address   = row[2].strip
      latitude  = row[3]
      longitude = row[4]
      speed     = row[5]
      heading   =  row[6]
      climb     = row[7]
      altitude  =  row[8]

      trip.moments.create(
                         {
                           :coordinates => [latitude,longitude],
                           :address     => address,
                           :speed => speed,
                           :altitude => altitude,
                           :heading => heading,
                           :climb => climb,
                           :reference_id => reference_id
                         })

    end
  end

  trip.start_time   = start_time
  trip.end_time     = end_time
  trip.frames       = frames
  trip.frame_rate   = frame_rate
  trip.title        = title
  trip.description  = description
  trip.vid_location = directory.gsub('public','') + "/images/dashcam.mp4"

  trip.save
  puts "Creating video..."
  system "ffmpeg -start_number 000001 -framerate #{frame_rate} -i #{directory}/images/%06d.png  -vcodec mpeg4  #{directory}/images/dashcam.mp4"
  puts "Cleaning up..."
  system "rm -rf #{directory}/images/*.png"
  system "rm -rf #{directory}/tracker.csv"
  puts "COMPLETE"
end
