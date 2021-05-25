namespace :gifs do
  desc 'Optimize gifs'
  task :optimize do
    optimized_gifs = open("#{Rails.root.join('public', 'gifs')}/optimized.txt", 'a')
    lines = File.readlines(optimized_gifs)
    lines.map(&:strip!)
    Dir.glob("#{Rails.root.join('public', 'gifs')}/*.mp4").each do |gif|
      next if lines.include?(gif)

      p "Ottimizzo #{gif.split('/').last}"
      system("cp #{gif} optimizing.mp4")
      comand = "ffmpeg -loglevel panic -y -i optimizing.mp4 -an -c:v libx264 -preset veryslow #{gif}"
      system(comand)
      system('rm optimizing.mp4')
      optimized_gifs.write("#{gif}\n")
    end
    optimized_gifs.close
    p 'Aggiornato, ottimizzato e chiuso!'
  end
end
