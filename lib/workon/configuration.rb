require 'optparse'
require 'yaml'

module Workon
  class Configuration
    attr_reader :options
    attr_reader :parser
    
    def self.instance(*args)
      @_instance ||= new(*args)
    end
    
    def initialize(*args)
      @options = { without: [], only: [], install_helper: false, dump_configuration: false, project: nil, show_help: false }
      parse_options args.first unless args.empty?
    end
    
    def parse_options(args)
      parser.parse! args
      options[:project] = args.first unless args.empty?
    end
    
    def exists?(key)
      key = key.to_sym
      !blank? options[key]
    end
    
    def set(key, value)
      key = key.to_sym
      options[key] = value
    end
    
    def fetch(key, default = nil)
      key = key.to_sym
      
      if !exists?(key) && !blank?(default)
        set key, default
      end
      
      options[key]
    end
    
    def [](key)
      fetch key
    end
    
    def []=(key, value)
      set key, value
    end
    
    def parser
      @parser ||= OptionParser.new do |o|
        o.banner = "Usage: #{File.basename($0)} [options] project"
        
        o.on('-w', '--without ACTORS', Array, 'Exclude unwanted actors') do |v|
          options[:without] = v
        end
        
        o.on('-o', '--only ACTORS', Array, 'Only use certain actors') do |v|
          options[:only] = v
        end
        
        o.on('-d', '--dump-configuration', 'Dump workon configuration to project_path/.workon.yml') do
          options[:dump_configuration] = true
        end
        
        o.on_tail('--install-helper', 'Install `wo` helper function to ~/.bash_profile') do
          options[:install_helper] = true
        end
        
        o.on_tail('-v', '--version', 'Show version information') do
          puts Workon::VERSION
          exit
        end
        
        o.on_tail('-h', '--help', 'Show this help information') do
          options[:show_help] = true
          # exit
        end
      end
    end
    
    def project_rc_path
      @project_rc_path ||= File.join Workon.project_path, '.workonrc'
    end
    
    def project_rc_exists?
      File.exist? project_rc_path
    end
    
    def merge_project_rc
      if project_rc_exists?
        opts = YAML.load_file(project_rc_path)
        @options.merge! opts
      end
    end
    
    def dump_to_project_rc
      o = options.dup
      o.delete :install_helper
      o.delete :dump_configuration
      o.delete :project
      o.delete :show_help
      
      begin
        File.open(project_rc_path, 'w') do |f|
          YAML.dump o, f
        end
        
        puts %(Saved workon configuration to #{project_rc_path})
      rescue
        STDERR.puts %(Could not save workon configuration to #{project_rc_path})
      end
    end
    
    private
    def blank?(object)
      object.respond_to?(:empty?) ? object.empty? : !object
    end
  end
end
