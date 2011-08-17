$TESTING = true

require 'workon'
require 'workon/rspec_helpers'

RSpec.configure do |c|
  c.include Workon::RSpecHelpers
end
