# Sentence model manages to create gif
class Sentence < ApplicationRecord
  def build_gif(_delta_before = 0, _delta_after = 0)
    comand = "ffmpeg -ss #{time_start.strftime(time_to_string_ffmpeg)} -loglevel panic -n
             -i #{Rails.root}/data/#{file_name}.mp4
             -to #{Time.at(time_end).utc.strftime(time_to_string_ffmpeg)} -c copy
             #{Rails.public_path}/gifs/#{new_name}.mp4"
    # comand = "ffmpeg -ss #{time_start.strftime(time_to_string_ffmpeg)}
    # -loglevel panic -n -i #{Rails.root}/data/#{file_name}.mp4
    # -to #{Time.at(time_end).utc.strftime(time_to_string_ffmpeg)} -c copy
    # -avoid_negative_ts 1 #{Rails.public_path}/gifs/#{new_name}.mp4"
    system(comand)
    "/gifs/#{new_name}.mp4"
  end

  def time_to_string
    '%H%M%S%L'
  end

  def time_to_string_ffmpeg
    '%H:%M:%S.%L'
  end

  def new_name(delta_before = 0, delta_after = 0)
    [file_name, time_start(delta_before).strftime(time_to_string),
     Time.at(time_end(delta_after)).utc.strftime(time_to_string)].join('-')
  end

  def time_start(delta_before = 0)
    Time.parse(start_time) - delta_before.seconds
  end

  def time_end(delta_after = 0)
    Time.parse(end_time) - Time.parse(start_time) + delta_after.seconds
  end
end
