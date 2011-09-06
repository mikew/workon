module Workon
  module Actor
    class Base
      include Workon::Helpers
      include Workon::Actor::Helpers::Commandable
      include Workon::Actor::Helpers::Configurable

      attr_reader :path, :project

      def self.inherited(base)
        @_subclasses ||= []
        @_subclasses << base
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
        @path    = path
        @project = Workon.project_name
      end

      def commit
        return if command.nil?

        to_run = interpret_command command
        to_run.run if !!to_run
      end
    end
  end
end
