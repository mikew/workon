module Workon
  module Actor
    class Unicorn < Base
      before :WebBrowser

      def has_unicorn_config?
        !Dir['config/unicorn.rb'].empty?
      end

      def unicorn_available?
        has_command? 'unicorn_rails'
      end

      def commit
        if has_unicorn_config? && unicorn_available?
          port = fetch_option :port, 8080
          screen bundle_command("unicorn_rails -c config/unicorn.rb -l #{port}")
        end
      end
    end
  end
end

