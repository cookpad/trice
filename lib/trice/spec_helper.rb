require 'trice/errors'

module Trice
  module SpecHelper
    def self.extract_time(runtime, static_time, block)
      block ? runtime.instance_eval(&block) : static_time
    end

    def stub_requested_at(static_time = nil, &block)
      before(:each) do |ex|
        time = SpecHelper.extract_time(self, static_time, block)

        case ex.metadata[:type]
        when :controller
          request.headers['X-Requested-At'] = time.iso8601
        when :feature
          set_header 'X-Requested-At', time.iso8601
        else
          raise Trice::TestStubbingNotSupported, "Test stubbing for type: #{ex.metadata[:type]} is not supported"
        end
      end
    end
  end
end
