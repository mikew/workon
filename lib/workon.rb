$LOAD_PATH.unshift File.expand_path("../", __FILE__)

require 'workon/configuration'
require 'workon/actor'
require "workon/version"

module Workon
  WORK_DIRS = '/Users/mike/Work/*/*'
  
  def self.all_directories
    @_all_directories ||= Dir[WORK_DIRS]
  end
  
  def self.project_name
    config[:project]
  end
  
  def self.project_path
    @_path
  end
  
  def self.has_project?
    !project_name.nil? && 0 < project_name.to_s.length
  end
  
  def self.find_project(str = project_name)
    candidate = all_directories.find { |d| d.end_with? "/#{str}" }
    
    unless candidate.nil?
      @_path = candidate
      Workon::Configuration.instance.merge_project_rc
    end
  end
  
  def self.commit!
    Dir.chdir project_path
    
    Workon::Actor.ordered.each do |klass|
      klass.new(project_path).commit
    end
    
    Workon::CLI::Commands::InstallHelper.helper_message(project_path)
  end
  
  def self.load_configuration(args)
    Workon::Configuration.instance.parse_options args
  end
  
  def self.config(args = [])
    load_configuration args unless args.empty?
    Workon::Configuration.instance
  end
end
