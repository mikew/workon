module Workon
  module Actor
    class Base
      attr_reader :path
      attr_reader :project
      
      def self.inherited(base)
        @_subclasses ||= []
        @_subclasses << base
      end
      
      def self.option(*args, &block)
        Workon::Configuration.instance.parser.on(*args) do |v|
          block.call(v)
        end
      end
      
      def self.options
        Workon.config
      end
      
      def self.subclasses
        @_subclasses
      end
      
      def self.before(other = :all)
        Workon::Actor.before self, other
      end
      
      def initialize(path)
        @path = path
      end
      
      def options
        self.class.options
      end
      
      def has_option?(key)
        key = key.to_sym
        
        !options[key].nil? && (options[key] || !options[key].empty?)
      end
      
      def fetch_option(key, default = nil)
        has_option?(key) ? options[key] : default
      end
      
      def project
        @project ||= Workon.project_name
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
