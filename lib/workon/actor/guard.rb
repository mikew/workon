module Workon
  module Actor
    class Guard < Base
      def command
        screen bundle_command("guard --clear") if has_guardfile?
      end

      private
      def has_guardfile?
        project_has_file? 'Guardfile'
      end
    end
  end
end

