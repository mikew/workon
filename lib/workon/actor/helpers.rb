module Workon
  module Actor
    module Helpers
      autoload :Bundler, 'workon/actor/helpers/bundler'
      autoload :Commandable, 'workon/actor/helpers/commandable'
      autoload :Configurable, 'workon/actor/helpers/configurable'
      autoload :Muxable, 'workon/actor/helpers/muxable'
    end
  end
end
