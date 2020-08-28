class Sentence < ApplicationRecord

  def build_gif(delta_before = 0, delta_after = 0)
    time_start = Time.parse(start_time) - delta_before.seconds
    time_end = Time.parse(end_time) - Time.parse(start_time) + delta_after.seconds
    new_name = "#{file_name}-#{time_start.strftime(time_to_string)}-#{Time.at(time_end).utc.strftime(time_to_string)}"
    comand = "ffmpeg -ss #{time_start.strftime(time_to_string_ffmpeg)} -loglevel panic -n -i #{Rails.root}/data/#{file_name}.mp4 -to #{Time.at(time_end).utc.strftime(time_to_string_ffmpeg)} -c copy #{Rails.public_path}/gifs/#{new_name}.mp4"
    # comand = "ffmpeg -ss #{time_start.strftime(time_to_string_ffmpeg)} -loglevel panic -n -i #{Rails.root}/data/#{file_name}.mp4 -to #{Time.at(time_end).utc.strftime(time_to_string_ffmpeg)} -c copy -avoid_negative_ts 1 #{Rails.public_path}/gifs/#{new_name}.mp4"
    p comand
    system(comand)
    "/gifs/#{new_name}.mp4"
  end

  def time_to_string
    '%H%M%S%L'
  end

  def time_to_string_ffmpeg
    '%H:%M:%S.%L'
  end
end
