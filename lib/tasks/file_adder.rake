require "#{Rails.root}/app/helpers/ffmpeg_helper"
include FfmpegHelper

namespace :file_adder do
  desc 'Compress and codec files to .ogg (from data folder) (da testare, forse aggiungere codifica dopo?)'
  task :compress do
    Parallel.each(all_videos, in_threads: 4) do |file_name|
      p "Converto: #{file_name}"
      file_name_clean = file_name_without_extension(file_name)
      # comando per comprimerla bene in webm (stralento)
      comand = "ffmpeg -n -loglevel info -i #{Rails.root.join('data', file_name)} -an -crf 32 -vf \"subtitles=#{Rails.root.join('data', file_name_clean)}.srt:force_style='Fontsize=28', scale=trunc(oh*a/2)*2:480, fps=24\" #{Rails.root.join('data', file_name_clean)}.webm"
      # comando per comprimerla bene in mp4 e vedere se i sottotitoli sono giusti (veloce)
      # speed = 'veryslow'
      # comand = "ffmpeg -n -loglevel info -i #{Rails.root.join('data', file_name)} -codec:v libx264 -preset #{speed} -an -crf 32 -vf \"subtitles=#{Rails.root.join('data', file_name_clean)}.srt:force_style='Fontsize=28', scale=trunc(oh*a/2)*2:480, fps=24\" #{Rails.root.join('data', file_name_clean)}_#{speed}.mp4"
      system(comand)
    end
  end

  namespace :subtitles do
    desc 'Extract subtitles, select channel (0, 1, 2...) depending on file'
    task :out, [:channel] do |_t, args|
      all_videos_each do |file_name|
        p "Analizzo: #{file_name}"
        comand = "ffmpeg -loglevel panic -n -i #{Rails.root.join('data',
                                                                 file_name)} -map 0:s:#{args[:channel]} #{Rails.root.join('data',
                                                                                                                          file_name_without_extension(file_name))}.srt"
        system(comand)
      end
    end
  end
end
