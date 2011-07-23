module Workon::Actor::Helpers::Bundler
  def bundle_command(command)
    project_uses_bundler? ? "bundle exec #{command}" : command
  end

  def project_uses_bundler?
    $project_uses_bundler ||= File.exists? './Gemfile'
  end
end
