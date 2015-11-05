$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'clockwork/test'

require 'pry'
require 'rspec/its'

Dir[File.expand_path('spec/matchers/**/*.rb')].each { |f| require f }
