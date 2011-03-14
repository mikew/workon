module Workon
  module Actor
    class Middleman < Base
      before :web_browser
      
      option('--middleman', 'Start mm-server') { |v| options[:middleman] = true }
      
      def commit
        screen "mm-server" if fetch_option :middleman, false
      end
    end
  end
end
