module Workon
  module Actor
    class WebBrowser < Base
      def command
        host_name = %{#{project}.local}
        %{ping -q -c 1 -t 1 #{host_name} && open http://#{host_name}}
      end
    end
  end
end
