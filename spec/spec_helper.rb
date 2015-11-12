$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'clockwork/test'

require 'pry'
require 'rspec/its'

RSpec.configure do |config|
  config.include(Clockwork::Test::RSpec::Matchers)
end
