namespace :files do
  desc 'Move files from public/upload to private'
  task :move do
    dirs = ['comment', 'script', 'server']

    dirs.each do |dir|
      "#{Rails.root}/public/uploads/#{dir}".tap do |path|
        if File.directory?(path)
          FileUtils.mv path, "#{Rails.root}/private/#{dir}"
        end
      end
    end
  end
end
