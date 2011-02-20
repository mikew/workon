module Workon
  module Actor
    class WebBrowser < Base
      option('--host HOST', 'Ping this host') { |v| options[:host] = v}
      
      def command
        host_name = fetch_option :host, %{#{project}.local}
        %{ping -q -c 1 -t 1 #{host_name} && open http://#{host_name}}
      end
    end
  end
end
