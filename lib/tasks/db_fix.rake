namespace :db_fix do
  desc 'Add file filter to missing files'
  task :add_missing_file_filter do
    Sentence.where(file_filter: nil).each do |sentence|
      sentence.update(file_filter: file_name.split('.').first)
    end
  end
end
