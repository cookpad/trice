$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.push    File.expand_path('../support', __FILE__)
require 'trice'
require 'pry'

Trice.support_requested_at_stubbing = true

RSpec.configure do |config|
  config.extend Trice::SpecHelper
end
