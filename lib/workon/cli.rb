require 'workon'

module Workon
  module CLI
    autoload :Commands, 'workon/cli/commands'

    def self.show_help
      puts @config.parser
      exit
    end

    def self.install_helper
      Commands::InstallHelper.execute
      exit
    end

    def self.show_project
      puts Workon.project_path
      exit
    end

    def self.dump_configuration
      @config.dump_to_project_rc
      exit
    end

    def self.execute
      Workon.config.merge_options cli_options
      @config = Workon.config

      show_help      if @config[:show_help]
      install_helper if @config[:install_helper]

      raise OptionParser::MissingArgument unless Workon.has_project?

      Workon.find_project

      show_project       if @config[:show_project]
      dump_configuration if @config[:dump_configuration]

      Workon.commit!
    end

    def self.cli_options
      ARGV
    end
  end
end
