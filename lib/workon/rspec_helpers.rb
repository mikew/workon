module Workon
  module RSpecHelpers
    def stub_projectrc!(rc_file = 'projectrc')
      fixtures_path = File.expand_path '../../../spec/fixtures', __FILE__
      fixture_path  = fixtures_path + "/#{rc_file}.yml"

      subject.stub(:project_rc_exists?).and_return true
      subject.stub(:project_rc_path).and_return    fixture_path
    end

    def stub_directories!(dirs = %w(/code/foo /code/bar))
      Workon.stub(:all_directories) { dirs }
    end

    def clear_workon_config!
      Workon.instance_eval { @config = nil }
    end

    def disable_banners!
      STDOUT.stub :puts
    end
  end
end
