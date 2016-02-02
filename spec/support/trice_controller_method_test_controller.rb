require 'action_controller/railtie'
require 'action_view/railtie'
require 'rspec/rails'

ENV['RAILS_ENV'] ||= 'test'

# see https://github.com/amatsuda/kaminari/blob/master/spec/fake_app/rails_app.rb

app = Class.new(Rails::Application)
app.config.secret_token = 'b4b25e4573dd9ce866547b49045eff30'
app.config.session_store :cookie_store, :key => '_myapp_session'
app.config.active_support.deprecation = :log
app.config.eager_load = false
app.config.root = File.expand_path('../fake_rails_app', (__FILE__))
Rails.backtrace_cleaner.remove_silencers!
app.initialize!
app.routes.draw do
  get 'hi', to: 'trice_controller_method_test#hi'
end

class TriceControllerMethodTestController < ActionController::Base
  include Trice::ControllerMethods

  def hi
    @requested_at = requested_at
    render text: @requested_at.iso8601
  end
end
