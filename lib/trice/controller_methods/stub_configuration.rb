module Trice
  module ControllerMethods
    class StubConfiguration
      def initialize(condition)
        @condition = condition
        @is_callable = @condition.respond_to?(:call)
      end

      def stubbable?(request)
        @is_callable ? @condition.call(request) : !!@condition
      end
    end
  end
end
