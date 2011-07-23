module Workon::Actor::Helpers::Commandable
  def run(command)
    puts "Running #{command}" unless $TESTING
    Kernel.system command unless options[:dry_run]
  end

  def has_command?(command)
    !`command -v '#{command}'`.empty?
  end

  def capture(command)
    puts "Running #{command}" unless $TESTING
    output = %x(#{command}) unless options[:dry_run]
    return output
  end
end
