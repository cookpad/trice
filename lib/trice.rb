require 'active_support/all'

require 'trice/errors'
require 'trice/reference_time'
require 'trice/reference_time_accessor'
require 'trice/version'

module Trice
  extend ReferenceTimeAccessor
end
