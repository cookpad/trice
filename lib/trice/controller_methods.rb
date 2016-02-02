module Trice
  module ControllerMethods
    extend ActiveSupport::Concern

    def requested_at
      Time.now
    end
  end
end
