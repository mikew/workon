require 'workon'
require 'workon/cli/commands'
require 'yaml'

module Workon
  module CLI
    def self.execute
      config = Workon.load_configuration(ARGV).options
      
      if config[:install_helper]
        Workon::CLI::Commands::InstallHelper.execute
        exit
      end
      
      raise OptionParser::MissingArgument if config[:project].nil?
      
      if config[:dump_configuration]
        puts config.to_yaml
      end
      
      Workon.find_project config[:project]
    end
  end
end
