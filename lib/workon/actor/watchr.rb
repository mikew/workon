module Workon
  module Actor
    class Watchr < Base
      def watchr_file_exists?
        project_has_file? '*.watchr'
      end

      def command
        mux "watchr" if watchr_file_exists?
      end
    end
  end
end
