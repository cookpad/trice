require 'trice/controller_methods/raw_reference_time'
require 'trice/controller_methods/reference_time_assignment'
require 'trice/controller_methods/stub_configuration'

module Trice
  module ControllerMethods

    extend ActiveSupport::Concern

    included do |controller|
      unless controller.middleware_stack.include?(RawReferenceTime)
        controller.use RawReferenceTime
      end

      config = StubConfiguration.new(Trice.support_requested_at_stubbing)
      prepend_around_action ReferenceTimeAssignment.new(config)

      # ActionController::API doesn't have helper_method
      if respond_to?(:helper_method)
        helper_method :requested_at
      end
    end

    private

    def requested_at
      Trice.reference_time
    end
  end
end
