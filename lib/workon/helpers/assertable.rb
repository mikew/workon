module Workon::Helpers::Assertable
  def has_command?(command)
    !`command -v '#{command}'`.empty?
  end

  def project_has_file?(file)
    !Dir[file].empty?
  end

  def project_has_one_of?(*files)
    files.any? { |f| project_has_file? f }
  end

  def project_has_folder?(folder)
    File.directory? folder
  end
end
