require 'workon'
require 'workon/cli/commands'
require 'yaml'

module Workon
  module CLI
    def self.execute
      Workon.load_configuration(ARGV)
      config = Workon.config
      
      if config[:show_help]
        puts Workon::Configuration.instance.parser
        exit
      end
      
      if config[:install_helper]
        Workon::CLI::Commands::InstallHelper.execute
        exit
      end
      
      p config
      exit
      
      raise OptionParser::MissingArgument if config[:project].nil?
      
      if config[:dump_configuration]
        puts config.to_yaml
      end
      
      Workon.find_project config[:project]
    end
  end
end
