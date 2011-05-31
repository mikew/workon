module Workon
  module Actor
    class Guard < Base
      def commit
        screen bundle_command("guard --clear") if has_guardfile?
      end

      private
      def has_guardfile?
        !!Dir['Guardfile']
      end
    end
  end
end

