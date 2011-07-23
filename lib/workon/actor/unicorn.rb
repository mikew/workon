module Workon
  module Actor
    class Unicorn < Base
      before :WebBrowser

      def has_unicorn_config?
        !Dir['config/unicorn.rb'].empty?
      end

      def commit
        if has_unicorn_config?
          port = fetch_option :port, 8080
          screen bundle_command("unicorn_rails -c #{path}/config/unicorn.rb -l #{port}")
        end
      end
    end
  end
end

