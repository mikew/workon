module Workon
  module Actor
    class Finder < Base
      def command
        "open #{path}"
      end
    end
  end
end