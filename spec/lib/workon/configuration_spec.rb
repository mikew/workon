require 'spec_helper'

describe Workon::Configuration do
  subject { described_class.new }

  describe "has defaults" do
    its([:show_project])       { should be_false }
    its([:without])            { should == [] }
    its([:only])               { should == [] }
    its([:install_helper])     { should be_false }
    its([:dump_configuration]) { should be_false }
    its([:project])            { should be_nil }
    its([:show_help])          { should be_false }
    its(:parser)               { should be_an(OptionParser) }

    describe "can be overriden" do
      subject { described_class.new(dump_configuration: true) }

      its([:dump_configuration]) { should be_true }
    end
  end

  describe "works from ARGV (--show-project foo)" do
    subject { described_class.new %w(--show-project foo) }

    its([:project])      { should == "foo" }
    its([:show_project]) { should be_true }
  end

  it "can tell if a key exists" do
    subject.exists?(:foo).should be_false
  end

  it "can set things" do
    new_value = :bar
    subject.set :foo, new_value
    subject[:foo].should == new_value
  end

  it "uses fetch to also set values" do
    default_port = 3000
    subject.fetch(:port, default_port).should == default_port
  end


  describe "with project .workonrc" do
    it "can find project .workonrc" do
      project_path = '/code/foo'
      Workon.stub(:project_path).and_return project_path

      subject.project_rc_path.should == project_path + '/.workonrc'
    end

    it "can merge project .workonrc" do
      stub_projectrc!
      subject.merge_project_rc
      subject[:port].should == 3000
    end
  end
end
