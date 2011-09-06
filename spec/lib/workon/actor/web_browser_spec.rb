require 'spec_helper'

describe Workon::Actor::WebBrowser do
  subject { described_class.new Workon.project_path }

  it "simply opens the URL" do
    host = 'somehost'
    port = 3000

    Workon.config[:host] = host
    Workon.config[:port] = port

    subject.command.to_run.should == "open http://#{host}:#{port}"
  end
end
