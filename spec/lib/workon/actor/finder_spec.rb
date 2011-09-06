require 'spec_helper'

describe Workon::Actor::Finder do
  before            { disable_banners! }
  let(:project_dir) { '/code/foo' }
  subject           { described_class.new project_dir }

  it 'lets you browse your project' do
    Kernel.should_receive(:system).with Hash.new, 'open /code/foo'
    subject.commit
  end
end
