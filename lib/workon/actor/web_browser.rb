module Workon
  module Actor
    class WebBrowser < Base
      option('--host HOST', 'Open host in your default browser')        { |v| options[:host] = v}
      option('--port PORT', Integer, 'Use this port for the webserver') { |v| options[:port] = v}

      def command
        host_name   = fetch_option :host, %{#{project}.local}
        port_number = fetch_option :port, nil
        qualified   = [ host_name, port_number ].compact.join ':'

        default_open "http://#{qualified}"
      end
    end
  end
end
