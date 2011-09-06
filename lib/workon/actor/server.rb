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
        options[:host] = 'localhost'
        port = fetch_option :port, 3000
        mux "passenger start --port #{port}", :bundler
      end

      def command_for_middleman
        options[:host] = 'localhost'
        port = fetch_option :port, 4567
        mux "mm-server --port #{port}", :bundler
      end

      def command_for_pow
        options[:port] = nil
        options[:host] = "#{project}.dev"
        nil
      end

      def command_for_unicorn
        options[:host] = 'localhost'
        port = fetch_option :port, 8080
        mux 'unicorn_rails -c config/unicorn-rb', :bundler
      end
    end
  end
end
