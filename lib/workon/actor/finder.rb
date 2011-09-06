module Workon
  module Actor
    class Finder < Base
      def command
        run path, :default_open
      end
    end
  end
end
