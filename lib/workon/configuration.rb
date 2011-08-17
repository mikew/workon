require 'optparse'
require 'yaml'

module Workon
  class Configuration
    attr_reader :options
    attr_reader :parser

    def initialize(options = nil)
      @options = {
        show_project:        false,
        without:             [],
        only:                [],
        install_helper:      false,
        dump_configuration:  false,
        project:             nil,
        show_help:           false
      }

      merge_options options unless blank? options
    end

    def merge_options(args)
      if Hash === args
        @options.merge! args
      elsif Array === args
        parser.parse! args
        options[:project] = args.first unless args.empty?
      end
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
        o.banner = "Usage: workon [options] project"

        o.on('-w', '--without ACTORS', Array, 'Exclude unwanted actors') do |v|
          options[:without] = v
        end

        o.on('-o', '--only ACTORS', Array, 'Only use certain actors') do |v|
          options[:only] = v
        end

        o.on('-d', '--dump-configuration', 'Dump workon configuration to project_path/.workonrc') do
          options[:dump_configuration] = true
        end

        o.on_tail('--install-helper', 'Install `wo\' helper function to ~/.bash_profile') do
          options[:install_helper] = true
        end

        o.on_tail('-P', '--show-project', TrueClass, "Echo project's directory") do
          options[:show_project] = true
        end

        o.on_tail('-n', '--dry-run', 'Do not run any commands') do
          options[:dry_run] = true
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
        p YAML.load_file(project_rc_path)
        merge_options YAML.load_file(project_rc_path)
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
