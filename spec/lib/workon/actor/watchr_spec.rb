require 'spec_helper'

describe Workon::Actor::Watchr do
  before { disable_banners! }
  subject { described_class.new '/code/foo' }

  it 'runs when *.watchr exists' do
    Workon.config.merge_options dry_run: true
    subject.should_receive(:watchr_file_exists?).and_return true
    Workon.stub(:project_name).and_return 'foo'
    subject.command.to_run.should =~ /watchr/
  end

  it 'does nothing otherwise' do
    Workon.config.merge_options dry_run: true
    subject.should_receive(:watchr_file_exists?).and_return false
    subject.command.should be_nil
  end
end
