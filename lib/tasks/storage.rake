namespace :storage do
  desc 'Migrate files from Carrierwave to ActiveStorage'
  task migrate: :environment do
    migrate_comment_files
    migrate_script_files
    migrate_server_credentials
  end
end

private

  def migrate_comment_files
    Account.on_each do
      comments = Comment.where.not file: nil

      comments.find_each do |comment|
        path = comment.file.path
        name = File.basename path

        if File.exists? path
          comment.attachment.attach io: File.open(path), filename: name

          File.delete path
        end
      end

      comments.update_all file: nil
    end
  end

  def migrate_script_files
    Account.on_each do
      scripts = Script.where.not file: nil

      scripts.find_each do |script|
        path = script.file.path
        name = File.basename path

        if File.exists? path
          script.attachment.attach io: File.open(path), filename: name

          File.delete path
        end
      end

      scripts.update_all file: nil
    end
  end

  def migrate_server_credentials
    Account.on_each do
      servers = Server.where.not credential: nil

      servers.find_each do |server|
        path = server.credential.path
        name = File.basename path

        if File.exists? path
          server.key.attach io: File.open(path), filename: name

          File.delete path
        end
      end

      servers.update_all credential: nil
    end
  end
