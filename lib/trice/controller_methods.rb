module Trice
  module ControllerMethods
    class ReferRequestedAt
      QUERY_STUB_KEY  = '_requested_at'.freeze
      HEADER_STUB_KEY = 'X-REQUESTED-AT'.freeze

      def around(controller, &action)
        t = extract_requested_at(controller.request)

        controller.request.env['trice.reference_time'] = t

        Trice.with_reference_time(t, &action)
      end

      private

      def extract_requested_at(request)
        if request.params[QUERY_STUB_KEY]
          Time.zone.parse(request.params[QUERY_STUB_KEY])
        elsif request.headers[HEADER_STUB_KEY]
          Time.zone.parse(request.headers[HEADER_STUB_KEY])
        else
          Time.now
        end
      end
    end

    extend ActiveSupport::Concern

    included do |controller|
      if controller.ancestors.include?(ActionController::Base)
        prepend_around_action ReferRequestedAt.new

        helper_method :requested_at
        hide_action   :requested_at
      end
    end

    def requested_at
      Trice.reference_time
    end
  end
end
