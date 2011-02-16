require 'optparse'

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
  end
end
