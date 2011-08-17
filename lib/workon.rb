module Workon
  autoload :Configuration, 'workon/configuration'
  autoload :Actor, 'workon/actor'
  autoload :Version, 'workon/version'

  WORK_DIRS = (ENV['WORKON_ROOT'] || ENV['HOME'] + '/Work') + '/*/*'

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
      config.merge_project_rc
    end
  end

  def self.commit!
    Dir.chdir project_path

    Workon::Actor.ordered.each do |klass|
      klass.new(project_path).commit
    end
  end

  def self.config(args = [])
    @config ||= Configuration.new args
  end
end
