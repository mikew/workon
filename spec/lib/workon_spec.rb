require 'spec_helper'

describe Workon do
  before do
    Workon.stub(:all_directories) { %w(/code/foo /code/bar) }
  end

  before(:each) { Workon.instance_eval { @config = nil } }

  it "finds a project" do
    Workon.config[:project] = 'foo'
    Workon.find_project
    Workon.project_path.should == '/code/foo'
  end

  it "runs nothing when -n passed" do
    Dir.stub(:chdir) { true }

    Workon.config[:dry_run] = true
    Workon.config[:project] = 'foo'
    Workon.find_project
    Workon.commit!

    Kernel.should_not_receive :system
    Kernel.should_not_receive :exec
  end

  it "ignores things in --without" do
    Dir.stub(:chdir).with(Workon.project_path)
    Workon::Actor::Server.should_not_receive :new
    Workon.config project: 'foo', without: 'Server', dry_run: true
    Workon.find_project
    Workon.commit!
  end
end
