# Sentence model manages to create gif
class Sentence < ApplicationRecord
  def build_gif(extra_params = { delta_before: 0, delta_after: 0 })
    comand = "ffmpeg -ss #{time_start(extra_params[:delta_before]).strftime(time_to_string_ffmpeg)} -loglevel panic -n -i #{Rails.root}/data/#{file_name}.ogg -an -c:v libx264 -preset ultrafast -to #{Time.at(time_end(extra_params[:delta_after])).utc.strftime(time_to_string_ffmpeg)} #{Rails.public_path}/gifs/#{new_name(extra_params)}"
    system(comand)
    "/gifs/#{new_name(extra_params)}"
  end

  def time_to_string
    '%H%M%S%L'
  end

  def time_to_string_ffmpeg
    '%H:%M:%S.%L'
  end

  def new_name(extra_params = { delta_before: 0, delta_after: 0 })
    [file_name, time_start(extra_params[:delta_before]).strftime(time_to_string),
     Time.at(time_end(extra_params[:delta_after])).utc.strftime(time_to_string), '.mp4'].join('-')
  end

  def time_start(delta_before = 0)
    Time.parse(start_time) - delta_before.seconds
  end

  def time_end(delta_after = 0)
    Time.parse(end_time) - Time.parse(start_time) + delta_after.seconds
  end
end
