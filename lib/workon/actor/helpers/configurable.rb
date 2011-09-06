module Workon::Actor::Helpers::Configurable
  module ClassMethods
    def option(*args, &block)
      Workon.config.parser.on(*args) do |v|
        block.call(v)
      end
    end

    def options
      Workon.config
    end
  end

  module InstanceMethods
    def options
      self.class.options
    end

    def has_option?(key)
      options.exists? key
    end

    def fetch_option(key, default = nil)
      options.fetch key, default
    end
  end

  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send   :include, InstanceMethods
  end
end
