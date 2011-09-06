module Workon
  class Command
    autoload :Wrappers, 'workon/command/wrappers'

    include Wrappers

    BANNERS = {
      running:    'Running %s',
      screening:  'Screening %s'
    }.freeze

    def initialize(command, env = {})
      @command = command
      @env     = env

      extract_options
    end

    def extract_options
      @banner     = @env.delete :banner
      @mux_window = @env.delete :mux_window
    end

    def env
      @env.inject({}) do |memo, (key, value)|
        memo[key.to_s] = value
        memo
      end
    end

    def update_env(new_env = {})
      @env.merge! new_env
      extract_options
      self
    end

    def expanded_env
      return if @env.empty?

      @env.inject('') do |memo, (key, value)|
        memo << "#{key.to_s.chomp}=#{value.to_s.chomp}"
      end
    end

    def to_run
      @command
    end

    def wrap!(wrapper)
      if Symbol === wrapper
        wrap_method = :"wrap_for_#{wrapper}"
        raise ArgumentError, "#{self} cannot wrap for #{wrapper}" unless respond_to? wrap_method

        wrapper = send wrap_method
      end

      @command = wrapper % @command
      self
    end

    def run
      display_banner
      Kernel.system env, @command unless Workon.config[:dry_run]
    end

    def capture
      display_banner
      _cmd = [ expanded_env, @command ].compact.join ';'
      %x(#{_cmd}) unless Workon.config[:dry_run]
    end

    def display_banner(banner = BANNERS[:running])
      puts (@banner || banner) % @command
    end
  end
end
