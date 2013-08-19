require 'thor'

class SourceFile < Thor
  include Thor::Actions

  desc 'fetch source files', 'fetch source files from GitHub'
  def fetch
    self.destination_root = 'vendor/assets'
    remote = 'https://raw.github.com/courtsimas/fondant/master'
    get "#{remote}/src/fondant.coffee", 'javascripts/fondant.coffee'
    get "#{remote}/src/fondant.scss", 'stylesheets/fondant.scss'
    get "#{remote}/VERSION", 'VERSION'

    bump_version
  end

  desc 'clean up source files', 'remove source files no longer needed'
  def cleanup
    self.destination_root = 'vendor/assets'
    remove_file 'VERSION'
  end

  protected

  def bump_version
    inside destination_root do
      version = File.read('VERSION').sub("\n", '')
      gsub_file '../../lib/fondant-rails/version.rb', /VERSION\s=\s'(\d|\.)+'$/ do |match|
        %Q{VERSION = '#{version}'}
      end
      gsub_file '../../README.md', /gem 'fondant-rails', '~>\s(\d|\.)+'/ do |match|
        %Q{gem 'fondant-rails', '~> #{version}'}
      end
    end
  end
end
