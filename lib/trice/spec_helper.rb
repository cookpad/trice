require 'trice/errors'

module Trice
  class TestStubbingNotSupported < Error; end

  module SpecHelper
    def self.extract_time(runtime, static_time, block)
      block ? runtime.instance_eval(&block) : static_time
    end

    def set_reference_time(static_time = nil, &block)
      around(:each) do |ex|
        time = SpecHelper.extract_time(self, static_time, block)

        Trice.with_reference_time(time) { ex.run }
      end
    end

    def set_now_as_reference_time
      set_reference_time(Time.now)
    end

    def stub_requested_at(static_time = nil, &block)
      before(:each) do |ex|
        time = SpecHelper.extract_time(self, static_time, block)

        case ex.metadata[:type]
        when :controller
          request.headers['X-Requested-At'] = time.iso8601
        when :feature
          case
          when page.driver.respond_to?(:header)
            # rack-test
            page.driver.header('X-Requested-At', time.iso8601)
          when page.driver.respond_to?(:add_headers)
            page.driver.add_headers('X-Requested-At' => time.iso8601)
          else
            raise Trice::TestStubbingNotSupported, "Test stubbing for driver #{page.driver.class} is not supported"
          end
        else
          raise Trice::TestStubbingNotSupported, "Test stubbing for type: #{ex.metadata[:type]} is not supported"
        end
      end
    end
  end
end
