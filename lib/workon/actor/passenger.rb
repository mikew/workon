module Workon
  module Actor
    class Passenger < Base
      def is_rack_app?
        !Dir['config.ru'].empty?
      end
      
      def passenger_standalone_available?
        !`which passenger`.empty?
      end
      
      def commit
        screen "passenger start" if is_rack_app? && passenger_standalone_available?
      end
    end
  end
end