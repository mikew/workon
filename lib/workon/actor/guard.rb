module Workon
  module Actor
    class Guard < Base
      def command
        return unless has_guardfile?

        mux 'guard --clear', :bundler
      end

      private
      def has_guardfile?
        project_has_file? 'Guardfile'
      end
    end
  end
end

