module SentencesHelper
  def time?(line)
    !line.match(/(\d{2}:){2}\d{2},\d{3} --> (\d{2}:){2}\d{2},\d{3}/).nil?
  end

  def new_line?(line)
    line == "\n"
  end

  def number?(line)
    !line.match(/^\d{1,4}\n$/).nil?
  end

  def extract_time(line)
    return unless time?(line)

    times = line.split('-->')
    time_start = extract_single_time(times[0])
    time_end = extract_single_time(times[1])
    return time_start, time_end
  end

  def extract_single_time(time)
    times = time.split(':').map(&:to_i)
    (times[0] * 60 + times[1]) * 60 + times[2]
  end

  def split_sentences(opened_file)
    sentences = []
    sentence = ''
    time_start, time_end = 0,0
    opened_file.each do |line|
      next if new_line?(line)

      if time?(line)
        time_start, time_end = extract_time(line)
        next
      end

      if number?(line)
        next if sentence == ''
        sentences << {sentence: sentence, time_start: time_start, time_end: time_end}
        sentence = ''
        next
      end

      sentence += line.strip + ' '
    end

    sentences << {sentence: sentence, time_start: time_start, time_end: time_end}

    return sentences
  end
end
