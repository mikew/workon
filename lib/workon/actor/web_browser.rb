module Workon
  module Actor
    class WebBrowser < Base
      option('--host HOST', 'Ping this host') { |v| options[:host] = v}
      option('--port PORT', Integer, 'Use this port for Middleman/Passenger') { |v| options[:port] = v}

      def command
        host_name   = fetch_option :host, %{#{project}.local}
        port_number = fetch_option :port, nil

        command, qualified  = port_number.nil? ? ping_test(host_name) : netstat_test(port_number)
        opener              = open_with_default "http://#{qualified}"
        %(#{command} && #{opener})
      end

      private
      def ping_test(host_name)
        command = %{ping -q -c 1 -t 1 #{host_name}}
        [ command, host_name ]
      end

      def netstat_test(port)
        command = %{sleep 3 && netstat -na | egrep 'tcp4*6* +([0-9]+ +){2}(\\*|([0-9]+\\.)+[0-9]+)(:|\\.)#{port}'}
        [ command, "localhost:#{port}" ]
      end
    end
  end
end
