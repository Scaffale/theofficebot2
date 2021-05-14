require "#{Rails.root}/app/helpers/ffmpeg_helper"
include FfmpegHelper

namespace :file_adder do

  desc "Compress and codec files to .ogg (from data folder) (da testare, forse aggiungere codifica dopo?)"
  task :compress do
    Parallel.each(all_videos, in_processes: 4) {|file_name|
      p "Converto: #{file_name}"
      file_name_clean = file_name_without_extension(file_name)
      # comando per comprimerla bene in webm (stralento)
      # comand = "ffmpeg -n -loglevel warning -i #{Rails.root.join('data', file_name)} -an -crf 32 -vf \"subtitles=#{Rails.root.join('data', file_name_clean)}.srt:force_style='Fontsize=32', scale=860:-1, fps=24\" #{Rails.root.join('data', file_name_clean)}.webm"
      # comando per comprimerla bene in mp4 e vedere se i sottotitoli sono giusti (veloce)
      speed = 'veryslow'
      comand = "ffmpeg -n -loglevel info -i #{Rails.root.join('data', file_name)} -codec:v libx264 -preset #{speed} -an -crf 32 -vf \"subtitles=#{Rails.root.join('data', file_name_clean)}.srt:force_style='Fontsize=28', scale=trunc(oh*a/2)*2:480, fps=24\" #{Rails.root.join('data', file_name_clean)}_#{speed}.mp4"
      system(comand)
    }
  end

  namespace :subtitles do
    desc "Extract subtitles (da testare)"
    task :out do
      all_videos_each {|file_name|
        p "Analizzo: #{file_name}"
        comand = "ffmpeg -loglevel panic -n -i #{Rails.root.join('data', file_name)} -map 0:s:0 #{Rails.root.join('data', file_name_without_extension(file_name))}.srt"
        system(comand)
      }
    end

    desc "Insert subtitles (create file with _s at the end)"
    task :in do
      Parallel.each(all_subtitles) do |sub_file|
        file_name = "#{Rails.root.join('data', file_name_without_extension(sub_file))}"
        p "Inserisco: #{file_name}"
        comand = "ffmpeg -loglevel warning -n -i #{file_name}.webm -vf subtitles=#{file_name}.srt -an -crf 26 #{file_name}_s.webm"
        system(comand)
        p comand
      end
    end
  end
end
