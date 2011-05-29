require 'workon'
require 'workon/cli/commands'

module Workon
  module CLI
    def self.execute
      config = Workon.config ARGV
      
      if config[:show_help]
        puts Workon::Configuration.instance.parser
        exit
      end
      
      if config[:install_helper]
        Workon::CLI::Commands::InstallHelper.execute
        exit
      end
      
      raise OptionParser::MissingArgument unless Workon.has_project?
      
      Workon.find_project
      
      if config[:show_project]
        puts Workon.project_path
        exit
      end

      if config[:dump_configuration]
        Workon::Configuration.instance.dump_to_project_rc
        exit
      end
      
      Workon.commit!
    end
  end
end
