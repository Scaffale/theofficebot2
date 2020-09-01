# Sentence model manages to create gif
class Sentence < ApplicationRecord
  def build_gif(_delta_before = 0, _delta_after = 0)
    comand = "ffmpeg -ss #{time_start.strftime(time_to_string_ffmpeg)} -loglevel panic -n -i #{Rails.root}/data/#{file_name}.ogg -an -c:v libx264 -preset superfast -to #{Time.at(time_end).utc.strftime(time_to_string_ffmpeg)} #{Rails.public_path}/gifs/#{new_name}"
    system(comand)
    "/gifs/#{new_name}"
  end

  def time_to_string
    '%H%M%S%L'
  end

  def time_to_string_ffmpeg
    '%H:%M:%S.%L'
  end

  def new_name(delta_before = 0, delta_after = 0)
    [file_name, time_start(delta_before).strftime(time_to_string),
     Time.at(time_end(delta_after)).utc.strftime(time_to_string), '.mp4'].join('-')
  end

  def time_start(delta_before = 0)
    Time.parse(start_time) - delta_before.seconds
  end

  def time_end(delta_after = 0)
    Time.parse(end_time) - Time.parse(start_time) + delta_after.seconds
  end
end
