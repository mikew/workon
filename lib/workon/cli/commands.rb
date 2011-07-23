module Workon
  module CLI
    module Commands
      module InstallHelper
        BASH_PROFILE_PATH = '~/.bash_profile'

        def self.execute
          install unless installed?
        end

        def self.install
          puts "Installing bash helper function to #{bash_profile_path}"

          begin
            File.open(bash_profile_path, 'a') do |f|
              f.write "\n\n"
              f.write finder
              f.write helper_function
            end

            puts "... Success!"
          rescue => error
            puts "... Failed!"
            puts error
          end
        end

        def self.bash_profile_path
          BASH_PROFILE_PATH.sub '~', ENV['HOME']
        end

        def self.finder
          "# Created by workon\n"
        end

        def self.installed?
          !(File.read(bash_profile_path) =~ /#{finder}/).nil?
        end

        def self.helper_function
          <<'BASH'
wo () {
  PROJECT=${!#}
  PROJECT_PATH=$(workon -P ${PROJECT})

  workon $@
  eval "cd $PROJECT_PATH"
}
BASH
        end
      end
    end
  end
end
