module Workon
  module Actor
    class Middleman < Base
      before :WebBrowser
      option('--middleman', 'Start mm-server') { |v| options[:middleman] = true }
      
      def commit
        if fetch_option :middleman, false
          port = fetch_option :port, 4567
          screen "mm-server --port #{port}"
        end
      end
    end
  end
end
