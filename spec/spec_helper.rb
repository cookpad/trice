$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.push    File.expand_path('../support', __FILE__)
require 'trice'

Trice.support_requested_at_stubbing = true
