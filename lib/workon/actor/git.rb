module Workon
  module Actor
    class Git < Base
      def project_uses_git?
        project_has_folder? '.git'
      end

      def command
        "git log --oneline -n 10" if project_uses_git?
      end
    end
  end
end
