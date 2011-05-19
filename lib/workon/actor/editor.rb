module Workon
  module Actor
    class Editor < Base
      def command
        editor = [ ENV['WORKON_EDITOR'], ENV['EDITOR'] ].find {|e| !e.nil? && !e.empty? }
        "#{editor} #{path}" if editor
      end
    end
  end
end
