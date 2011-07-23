require 'workon/actor/helpers/configurable'
require 'workon/actor/helpers/commandable'
require 'workon/actor/helpers/muxable'
require 'workon/actor/helpers/bundler'

module Workon
  module Actor
    class Base
      include Workon::Actor::Helpers::Configurable
      include Workon::Actor::Helpers::Commandable
      include Workon::Actor::Helpers::Muxable
      include Workon::Actor::Helpers::Bundler

      attr_reader :path
      attr_reader :project

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
        @path = path
      end

      def project
        @project ||= Workon.project_name
      end

      def commit
        run command unless command.nil? || command.empty?
      end

      def open_with_default(thing)
        $open_command ||= has_command?('xdg-open') ? 'xdg-open' : 'open'

        "#{$open_command} #{thing}"
      end
    end
  end
end
