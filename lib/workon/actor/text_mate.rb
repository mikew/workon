module Workon
  module Actor
    class TextMate < Base
      def command
        "mate #{path}"
      end
    end
  end
end
