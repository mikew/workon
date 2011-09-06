module Workon::Command::Wrappers
  include Workon::Helpers

  @@default_open     = nil
  @@tmux_initialized = false

  def wrap_for_bundler
    'bundle exec %s'
  end

  def wrap_for_default_open
    @@default_open ||= has_command?('xdg-open') ? 'xdg-open %s' : 'open %s'
  end

  def wrap_for_rvm
    project_has_file?('.rvmrc') ? "rvm --with-rubies default-with-rvmrc exec %s" : '%s'
  end

  def wrap_for_mux
    $has_tmux ||= has_command? 'tmux'
    wrap! :rvm

    $has_tmux ? _tmux : _screen
  end

  def _screen
    identifier = mux_scope

    puts %(Reconnect with `screen -r #{identifier}')
    %(screen -dmS #{identifier} %s)
  end

  def _tmux
    initialize_tmux

    %(tmux attach-session -t #{mux_session} \\; new-window -d -n #{mux_window} '%s' \\; detach-client)
  end

  def initialize_tmux
    return if @@tmux_initialized

    tmux_commands = [
      "new-session -s #{mux_session}",
      "set-option -t #{mux_session} set-remain-on-exit on",
      "detach-client"
    ].join ' \; '

    initializer = Workon::Command.new "tmux #{tmux_commands}"#, banner: 'Initializing tmux session ...'
    initializer.run

    @@tmux_initialized = true
  end

  def mux_scope
    [ mux_session, mux_window ].join '.'
  end

  def mux_session
    Workon.project_name.downcase
  end

  def mux_window
    @mux_window.downcase
  end
end
