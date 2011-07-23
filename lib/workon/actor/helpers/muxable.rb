module Workon::Actor::Helpers::Muxable
  def screen(command)
    $has_tmux ||= has_command? 'tmux'
    command = rvm_exec command

    $has_tmux ? _tmux(command) : _screen(command)
  end

  def _screen(command, scope = nil)
    identifier = screen_scope scope

    run %(screen -dmS #{identifier} #{command})
    puts %(Reconnect with `screen -r #{identifier}')
  end

  def _tmux(command)
    initialize_tmux

    run "tmux attach-session -t #{tmux_session} \\; new-window -d -n #{tmux_window} '#{command}' \\; detach-client"
  end

  def initialize_tmux
    $tmux_initialized ||= begin
      run "tmux new-session -s #{tmux_session} \\; set-option -t #{tmux_session} set-remain-on-exit on \\; detach-client"
      true
    end
  end

  def screen_scope(scope = nil)
    scope ||= self.class.actor_name
    "#{project}.#{scope}".downcase
  end

  def tmux_session
    project
  end

  def tmux_window
    self.class.actor_name.downcase
  end

  def rvm_exec(command)
    Dir['./.rvmrc'].empty? ? command : "rvm --with-rubies default-with-rvmrc exec #{command}"
  end
end
