# Helper used to send ffmpeg commands
module FfmpegHelper
  VIDEO_FORMATS = %w[mp4 mkv avi].freeze

  def all_videos_each
    VIDEO_FORMATS.each do |video_format|
      p "Vedo i #{video_format}"
      Dir.glob("#{Rails.root}/data/*.#{video_format}").each do |file|
        file_name = file.split('/').last
        yield(file_name)
      end
    end
    p '👍'
  end

  def all_videos
    result = []
    VIDEO_FORMATS.each do |video_format|
      Dir.glob("#{Rails.root}/data/*.#{video_format}").each do |file|
        file_name = file.split('/').last
        result << file_name
      end
    end
    result
  end

  def all_subtitles_each
    Dir.glob("#{Rails.root}/data/*.srt").each do |file|
      file_name = file.split('/').last
      yield(file_name)
    end
    p '👍'
  end

  def all_subtitles
    Dir.glob("#{Rails.root}/data/*.srt").map(&method(:file_name_no_dir))
  end

  def file_name_without_extension(file_name)
    file_name.split('.')[0..-2].join('.')
  end

  private

  def file_name_no_dir(file)
    file.split('/').last
  end
end
