# Helper used to send ffmpeg commands
module FfmpegHelper
  VIDEO_FORMATS = %w[mp4 mkv avi]

  def all_video_commands(&block)
    VIDEO_FORMATS.each do |video_format|
      p "Vedo i #{video_format}"
      Dir.glob("#{Rails.root}/data/*.#{video_format}").sort.each do |file|
        file_name = file.split('/').last
        yield(file_name)
      end
    end
    p "👍"
  end

  def file_name_without_extension(file_name)
    file_name.split('.')[0..-2].join('.')
  end
end
