namespace :files do
  desc 'Move files from public/upload to private'
  task :move do
    move_to_private
    move_to_default_tenant
  end
end

private

  def private_path
    "#{Rails.root}/private"
  end

  def move_to_private
    %w(comment script server).each do |dir|
      "#{Rails.root}/public/uploads/#{dir}".tap do |path|
        if File.directory?(path)
          FileUtils.mv path, "#{private_path}/#{dir}"
        end
      end
    end
  end

  def move_to_default_tenant
    unless File.directory?("#{private_path}/default")
      FileUtils.mkdir_p "#{private_path}/default"

      %w(comment script server).each do |dir|
        path = "#{private_path}/#{dir}"

        if File.directory?(path)
          FileUtils.mv path, "#{private_path}/default/#{dir}"
        end
      end
    end
  end
