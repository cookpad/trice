module Trice
  module ControllerMethods
    class ReferRequestedAt
      def around(controller, &action)
        t = Time.zone.now

        controller.request.env['trice.reference_time'] = t

        Trice.with_reference_time(Time.now, &action)
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
