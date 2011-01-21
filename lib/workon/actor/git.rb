module Workon
  module Actor
    class Git < Base
      def project_uses_git?
        Dir.exists? %{#{path}/.git}
      end
      
      def commit
        output = %x(git log --oneline -n 10) if project_uses_git?
        puts output
      end
    end
  end
end
