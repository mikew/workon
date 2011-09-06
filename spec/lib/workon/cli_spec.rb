require 'spec_helper'
require 'workon/cli'

describe Workon::CLI do
  before(:each) { clear_workon_config! }

  it "shows help when asked" do
    Workon.config show_help: true
    described_class.should_receive(:show_help).and_return { exit }
    expect { described_class.execute }.to raise_error SystemExit
  end

  it "installs bash helper when asked" do
    Workon.config install_helper: true
    described_class.should_receive(:install_helper).and_return { exit }
    expect { described_class.execute }.to raise_error SystemExit
  end

  it "shows project path when asked" do
    Workon.config show_project: true, project: 'foo'
    described_class.should_receive(:show_project).and_return { exit }
    expect { described_class.execute }.to raise_error SystemExit
  end

  it "dumps configuration" do
    Workon.config dump_configuration: true, project: 'foo'
    described_class.should_receive(:dump_configuration).and_return { exit }
    expect { described_class.execute }.to raise_error SystemExit
  end

  it "fails without a project" do
    described_class.stub(:cli_options).and_return []
    Workon.config.merge_options project: nil
    expect { described_class.execute }.to raise_error OptionParser::MissingArgument
  end
end
