require 'spec_helper'

describe Workon do
  before do
    Workon.stub(:all_directories) { %w(/code/foo /code/bar) }
  end

  it "should find a project" do
    Workon.config[:project] = 'foo'
    Workon.find_project
    Workon.project_path.should == '/code/foo'
  end

  it "should run nothing when -n passed" do
    Dir.stub(:chdir) { true }

    Workon.config[:dry_run] = true
    Workon.config[:project] = 'foo'
    Workon.find_project
    Workon.commit!

    Kernel.should_not_receive :system
    Kernel.should_not_receive :exec
  end
end
