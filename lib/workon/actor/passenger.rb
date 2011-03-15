module Workon
  module Actor
    class Passenger < Base
      before :WebBrowser
      
      def is_rack_app?
        !Dir['config.ru'].empty?
      end
      
      def passenger_standalone_available?
        !`which passenger`.empty?
      end
      
      def commit
        if is_rack_app? && passenger_standalone_available?
          port = fetch_option :port, 3000
          screen "passenger start --port #{port}"
        end
      end
    end
  end
end