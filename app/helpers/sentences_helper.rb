# Helper used to seed sentences into db
module SentencesHelper
  def time?(line)
    !line.match(/(\d{2}:){2}\d{2},\d{3} --> (\d{2}:){2}\d{2},\d{3}/).nil?
  end

  def new_line?(line)
    line == "\n"
  end

  def number?(line)
    !line.strip.match(/^\d{1,4}$/).nil?
  end

  def extract_time(line)
    return unless time?(line)

    line.split(' --> ').map(&:strip)
  end

  def extract_single_time(time)
    Time.parse(time)
  end

  def split_sentences(opened_file)
    sentences = []
    sentence = []
    time_start = nil
    time_end = nil
    opened_file.each do |line|
      next if new_line?(line) || line.blank?

      if time?(line)
        time_start, time_end = extract_time(line)
        next
      end

      if number?(line)
        next if sentence.blank?

        sentences << { sentence: sentence.join(' '), time_start: time_start, time_end: time_end }
        sentence = []
        next
      end

      sentence += [line.strip]
    end

    sentences << { sentence: sentence.join(' '), time_start: time_start, time_end: time_end }

    sentences
  end
end
