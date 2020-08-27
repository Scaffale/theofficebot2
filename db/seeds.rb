Dir.glob("#{Rails.root}/data/*.srt").sort.each do |file|
  file_name = file.split('/').last
  serie = file_name[1..2].to_i
  episode = file_name[4..5].to_i
  p "#{file_name} -> #{serie}, #{episode}"
end
