module Workon
  module Actor
    class Server < Base
      option('--server SERVER', 'Use this server (auto,middleman,passenger,pow,unicorn)') { |v| options[:server] = v}
      before :WebBrowser

      def command
        actual = fetch_option :server, 'auto'
        valid = %w(auto middleman passenger pow unicorn)

        return unless valid.include? actual
        send :"command_for_#{actual}"
      end

      private
      def command_for_auto
        command_for_unicorn   and return if project_has_one_of?('unicorn.rb', 'config/unicorn.rb')
        command_for_passenger and return if project_has_file?('config.ru') && has_command?('passenger')
      end

      def command_for_passenger
        bundled_server "passenger start --port %{port}", 3000
      end

      def command_for_middleman
        bundled_server "mm-server --port %{port}", 4567
      end

      def command_for_pow
        options[:port] = nil
        options[:host] = "#{project}.dev"

        nil
      end

      def command_for_unicorn
        bundled_server 'unicorn_rails -c config/unicorn-rb', 8080
      end

      def bundled_server(command, port, new_host = 'localhost')
        options[:host] = new_host
        new_port       = fetch_option :port, port

        mux command % { port: port }, :bundler
      end
    end
  end
end
