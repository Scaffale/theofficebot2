class Sentence < ApplicationRecord

  def build_gif(delta_before = 0, delta_after = 0)
    time_start = start_time + delta_before
    time_end = end_time + delta_after
    new_name = "#{file_name}-#{time_start}-#{time_end}"
    comand = "ffmpeg -ss #{time_start} -loglevel panic -n -i #{Rails.root}/data/#{file_name}.mp4 -t #{time_end - time_start} -c copy -avoid_negative_ts 1 #{Rails.public_path}/gifs/#{new_name}.mp4"
    system(comand)
  end
end
