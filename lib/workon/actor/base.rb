module Workon
  module Actor
    class Base
      attr_reader :path
      attr_reader :project
      
      def self.subclasses
        @_subclasses
      end
      
      def self.inherited(base)
        @_subclasses ||= []
        @_subclasses << base
      end
      
      def initialize(path)
        @path = path
      end
      
      def project
        @project ||= @path.split('/').last
      end
      
      def commit
        run command
      end
      
      def system(command)
        puts "Running #{command}"
        Kernel.system command
      end
      
      def run(command)
        puts "Running #{command}"
        output = %x(#{command})
        return output
      end
      
      def screen(command, scope = nil)
        identifier = screen_scope scope
        
        run %(screen -dmS #{identifier} #{command})
        puts %(Reconnect with `screen -r #{identifier}')
      end
      
      def screen_scope(scope = nil)
        scope ||= self.class.name.to_s.split('::').last
        "#{project}.#{scope}".downcase
      end
    end
  end
end
