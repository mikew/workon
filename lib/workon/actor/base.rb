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
      
      def run(command)
        puts "Running #{command}"
        %x(#{command})
      end
    end
  end
end
