namespace :help do
  desc 'Install help dependencies'
  task :install do
    Dir.chdir('config/jekyll') do
      Bundler.with_unbundled_env do
        system 'bundle install' or raise 'install error!'
      end
    end
  end

  desc 'Update help dependencies'
  task :update do
    Dir.chdir('config/jekyll') do
      Bundler.with_unbundled_env do
        system 'bundle update' or raise 'update error!'
      end
    end
  end

  desc 'Run Jekyll in config/jekyll directory without having to cd there'
  task :generate do
    Dir.chdir('config/jekyll') do
      Bundler.with_unbundled_env do
        system 'bundle exec jekyll build --trace' or raise 'generate error!'
      end
    end
  end

  desc 'Run Jekyll in config/jekyll directory with --watch'
  task :autogenerate do
    Dir.chdir('config/jekyll') do
      Bundler.with_unbundled_env do
        system 'bundle exec jekyll build --watch' or raise 'autogenerate error!'
      end
    end
  end

  desc 'Link the generated help to public/help'
  task :environment do
    FileUtils.ln_s Rails.root.join('config/jekyll/_site'), Rails.root.join('public/help')
  end
end
