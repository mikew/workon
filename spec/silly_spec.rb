require 'spec_helper'

class TestActor < Workon::Actor::Base
  def command; nil; end
end

describe TestActor do
  subject { described_class.new '/code/foo' }

  it "has shorthands for running commands" do
    subject.run('date').should be_a(Workon::Command)
  end

  it "has a shorthand for wrapping" do
    command = Workon::Command.new 'date'
    command.should_receive(:wrap!).with(:bundler).ordered
    command.should_receive(:wrap!).with(:rvm).ordered

    subject.run command, :bundler, :rvm, banner: 'test banner'
  end
end
