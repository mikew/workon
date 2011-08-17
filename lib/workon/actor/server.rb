module Workon
  module Actor
    class Server < Base
      option('--server SERVER', 'Use this server (auto,middleman,passenger,pow,unicorn)') { |v| options[:server] = v}
      before :WebBrowser

      def commit
        actual = fetch_option :server, 'auto'
        valid = %w(auto middleman passenger pow unicorn)

        return unless valid.include? actual
        send :"commit_for_#{actual}"
      end

      private
      def commit_for_auto
        commit_for_unicorn   and return if project_has_one_of?('unicorn.rb', 'config/unicorn.rb')
        commit_for_passenger and return if project_has_file?('config.ru') && has_command?('passenger')
      end

      def commit_for_passenger
        port = fetch_option :port, 3000
        screen bundle_command("passenger start --port #{port}")
      end

      def commit_for_middleman
        port = fetch_option :port, 4567
        screen bundle_command("mm-server --port #{port}")
      end

      def commit_for_pow
        options[:port] = nil
        options[:host] = "#{project}.dev"
      end

      def commit_for_unicorn
        port = fetch_option :port, 8080
        screen bundle_command("unicorn_rails -c #{path}/config/unicorn.rb -l #{port}")
      end
    end
  end
end
