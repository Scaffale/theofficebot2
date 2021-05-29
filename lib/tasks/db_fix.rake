namespace :db_fix do
  desc 'Add file filter to missing files'
  task :add_missing_file_filter => :environment do
    Sentence.where(file_filter: nil).each do |sentence|
      sentence.update(file_filter: sentence.file_name.split('.').first)
    end
  end

  desc 'Add words'
  task :add_words => :environment do
    Sentence.all.pluck(:id, :text).each { |id, sentence|
      sentence.split.each { |word|
        Word.first_or_create(text: word) do |created_word|
          created_word.sentences << Sentence.find(id)
        end
      }
    }
  end
end
