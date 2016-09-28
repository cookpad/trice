module Trice
  module ControllerMethods
    class ReferenceTimeAssignment

      QUERY_STUB_KEY  = '_requested_at'.freeze
      HEADER_STUB_KEY = 'X-REQUESTED-AT'.freeze

      def initialize(config)
        @stub_configuration = config
      end

      def around(controller, &action)
        t = stubbed_requested_at(controller) || Time.now

        Trice.with_reference_time(t, &action)
      end

      private

      def stubbed_requested_at(controller)
        requested_at = requested_at_string(controller.request)

        if requested_at && @stub_configuration.stubbable?(controller)
          Time.zone.parse(requested_at)
        end
      end

      def requested_at_string(request)
        request.params[QUERY_STUB_KEY] || request.headers[HEADER_STUB_KEY]
      end
    end
  end
end
