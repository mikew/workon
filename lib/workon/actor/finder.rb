module Workon
  module Actor
    class Finder < Base
      def command
        open_with_default path
      end
    end
  end
end