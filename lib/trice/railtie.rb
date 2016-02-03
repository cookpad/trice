module Trice
  class Railtie < ::Rails::Railtie
    initializer 'trice' do |app|
      Trice.support_requested_at_stubbing = !Rails.env.production?
    end
  end
end
