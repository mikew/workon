module Workon
  module Actor
    class Watchr < Base
      def watchr_file_exists?
        !Dir['*.watchr'].empty?
      end
      
      def commit
        screen "watchr" if watchr_file_exists?
      end
    end
  end
end
