require 'spec_helper'

describe Workon::Command do
  before { disable_banners! }

  it "runs a command" do
    cmd = described_class.new 'date'
    Kernel.should_receive(:system).with({}, 'date')
    cmd.run
  end

  it "displays a banner" do
    cmd     = 'date'
    banner  = 'foo'
    command = described_class.new cmd, banner: banner

    STDOUT.should_receive(:puts).with(banner)
    Kernel.should_receive :system

    command.run
  end

  it "can capture commands" do
    string  = 'foo'
    command = described_class.new "echo #{string}"

    command.capture.chomp.should == string
  end

  it "can wrap itself for bundler, etc" do
    command = described_class.new "date"
    Kernel.should_receive(:system).with Hash.new, 'bar foo date'

    command.wrap!('foo %s').wrap! 'bar %s'
    command.run
  end

  it 'knows to wrap using a method when symbol passed' do
    command = described_class.new 'date'
    Kernel.should_receive(:system).with Hash.new, 'bundle exec date'

    command.wrap! :bundler
    command.run
  end

  describe "sets the ENV" do
    let(:sample_env) { { foo: 'bar' } }
    subject          { described_class.new 'echo $foo', sample_env }

    it "stringifies the ENVs keys" do
      subject.env['foo'].should == sample_env[:foo]
    end

    it "expands ENV for when hash not applicable" do
      subject.expanded_env.should == 'foo=bar'
    end

    it "accepts an ENV hash" do
      subject.capture.chomp.should == sample_env[:foo]
    end
  end
end
