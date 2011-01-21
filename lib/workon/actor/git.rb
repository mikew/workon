module Workon
  module Actor
    class Git < Base
      def project_uses_git?
        Dir.exists? %{#{path}/.git}
      end
      
      def commit
        run "git log" if project_uses_git?
      end
    end
  end
end
