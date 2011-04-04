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
      
      def self.actor_name
        name.split('::').last
      end
      
      def initialize(path)
        @path = path
      end
      
      def options
        self.class.options
      end
      
      def has_option?(key)
        options.exists? key
      end
      
      def fetch_option(key, default = nil)
        options.fetch key, default
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
        output = %x(#{command}) unless options[:dry_run]
        return output
      end
      
      def screen(command)
        @has_tmux ||= `which tmux`.length > 0
        
        @has_tmux ? _tmux(command) : _screen(command)
      end
      
      def _screen(command, scope = nil)
        identifier = screen_scope scope
        
        run %(screen -dmS #{identifier} #{command})
        puts %(Reconnect with `screen -r #{identifier}')
      end
      
      def _tmux(command)
        initialize_tmux
        
        run "tmux attach-session -t #{tmux_session} \\; new-window -d -n #{tmux_window} '#{command}' \\; detach-client"
      end
      
      def initialize_tmux
        @tmux_initialized ||= begin
          run "tmux new-session -s #{tmux_session} \\; set-option -t #{tmux_session} set-remain-on-exit on \\; detach-client"
          true
        end
      end
      
      def screen_scope(scope = nil)
        scope ||= self.class.actor_name
        "#{project}.#{scope}".downcase
      end
      
      def tmux_session
        project
      end
      
      def tmux_window
        self.class.actor_name.downcase
      end
    end
  end
end
