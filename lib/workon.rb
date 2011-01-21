$:.push File.expand_path("../", __FILE__)
require 'workon/actor'

module Workon
  WORK_DIRS = '/Users/mike/Work/*/*'
  
  def self.all_directories
    @_all_directories ||= Dir[WORK_DIRS]
  end
  
  def self.find(str)
    candidate = all_directories.find { |d| d.end_with? "/#{str}" }
    commit candidate unless candidate.nil?
  end
  
  def self.commit(path)
    Workon::Actor.all.each do |klass|
      klass.new(path).commit
    end
  end
end

Workon.find "workon" if __FILE__ == $0
