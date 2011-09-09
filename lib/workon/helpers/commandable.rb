module Workon::Helpers::Commandable
  def run(command, *wrappers)
    interpret_command(command, *wrappers)
  end

  def mux(command, *wrappers)
    wrappers, env    = wrappers_and_env(wrappers)
    env[:mux_window] = env.delete(:mux_window) || self.class.actor_name

    interpret_command(command, *wrappers, env).wrap!(:mux)
  end

  def default_open(command, *wrappers)
    interpret_command(command, *wrappers).wrap!(:default_open)
  end

  private
  def interpret_command(command, *wrappers)
    wrappers, env = wrappers_and_env wrappers
    command = Workon::Command === command ? command : Workon::Command.new(command)

    command.update_env env
    wrappers.each do |wrapper|
      command.wrap! wrapper
    end

    command
  end

  def wrappers_and_env(wrappers)
    env = Hash === wrappers.last ? wrappers.pop : Hash.new

    [ wrappers, env ]
  end
end
