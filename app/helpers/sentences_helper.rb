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

        sentences << { sentence: join_sentences(sentence), time_start: time_start, time_end: time_end }
        sentence = []
        next
      end

      sentence += purge_and_split(line)
    end

    sentences << { sentence: join_sentences(sentence), time_start: time_start, time_end: time_end }

    sentences
  end

  def uniq_id(long_id)
    if long_id.size < 40
      long_id
    else
      long_id[-40..-6]
    end
  end

  def purge_and_split(line)
    line.gsub(%r{</?\w>}, '')
        .gsub(/\{pos\(.+\)\}/, '')
        .gsub(/\W/, ' ')
        .downcase
        .strip
        .split
        .uniq
  end

  def join_sentences(sentences)
    sentences.flatten.uniq.join(' ')
  end
end
