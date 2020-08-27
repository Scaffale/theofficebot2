Sentence.delete_all

include SentencesHelper

Dir.glob("#{Rails.root}/data/*.srt").sort.each do |file|
  file_name = file.split('/').last
  serie = file_name[1..2].to_i
  episode = file_name[4..5].to_i
  file_name = file_name.split('.srt')[0]
  p "Analizzo: #{file_name} -> #{serie}, #{episode}"
  opened_file = open(file).readlines
  split_sentences(opened_file).each do |sentence_analized|
    Sentence.create(season: serie, episode: episode, file_name: file_name, end_time: sentence_analized[:time_end],
                    start_time: sentence_analized[:time_start], text: sentence_analized[:sentence])
  end
end
