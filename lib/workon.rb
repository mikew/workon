$LOAD_PATH.unshift File.expand_path("../", __FILE__)

require 'workon/configuration'
require 'workon/actor'
require "workon/version"

module Workon
  WORK_DIRS = '/Users/mike/Work/*/*'
  
  def self.all_directories
    @_all_directories ||= Dir[WORK_DIRS]
  end
  
  def self.find_project(str)
    candidate = all_directories.find { |d| d.end_with? "/#{str}" }
    commit_path candidate unless candidate.nil?
  end
  
  def self.commit_path(path)
    Dir.chdir path
    
    Workon::Actor.all.each do |klass|
      klass.new(path).commit
    end
    
    Workon::CLI::Commands::InstallHelper.helper_message(path)
  end
  
  def self.load_configuration(args)
    Workon::Configuration.instance.parse_options args
  end
  
  def self.config
    Workon::Configuration.instance.options  
  end
end
