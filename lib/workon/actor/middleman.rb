module Workon
  module Actor
    class Middleman < Base
      option('--middleman', 'Start mm-server') { |v| options[:middleman] = true }
      
      def commit
        if fetch_option :middleman, false
          screen "mm-server"
          run "sleep 3 && open http://localhost:4567/"
        end
      end
    end
  end
end
