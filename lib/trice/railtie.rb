module Trice
  class Railtie < ::Rails::Railtie
    initializer 'trice' do |app|
      if Trice.support_requested_at_stubbing.nil?
        Trice.support_requested_at_stubbing = !Rails.env.production?
      end
    end
  end
end
