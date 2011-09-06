require 'spec_helper'

describe Workon::Actor::Guard do
  before { disable_banners! }
  subject { described_class.new '/code/foo' }

  it 'runs when ./Guardfile exists' do
    Workon::Command.any_instance.stub(:mux_session).and_return 'foo'
    Workon.config.merge_options dry_run: true
    subject.should_receive(:has_guardfile?).and_return true
    subject.command.to_run.should =~ /guard/
  end

  it 'does nothing otherwise' do
    Workon.config.merge_options dry_run: true
    subject.should_receive(:has_guardfile?).and_return false
    subject.command.should be_nil
  end
end
