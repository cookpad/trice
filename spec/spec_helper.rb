$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.push    File.expand_path('../support', __FILE__)
require 'trice'
require 'pry'

if ActiveSupport.version > Gem::Version.create('5.0')
  require 'rails-controller-testing'
end

Trice.support_requested_at_stubbing = true

RSpec.configure do |config|
  config.extend Trice::SpecHelper
end
