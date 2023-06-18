require 'action_controller/railtie'
require 'action_view/railtie'
require 'trice/railtie'

ENV['RAILS_ENV'] ||= 'test'

# see https://github.com/kaminari/kaminari/blob/master/kaminari-core/test/fake_app/rails_app.rb

class TriceTestApp < Rails::Application
  config.secret_token = 'b4b25e4573dd9ce866547b49045eff30'
  config.session_store :cookie_store, :key => '_myapp_session'
  config.active_support.deprecation = :log
  config.eager_load = false
  config.root = File.expand_path('../fake_rails_app', (__FILE__))
end
Rails.backtrace_cleaner.remove_silencers!
Rails.application.initialize!
Rails.application.routes.draw do
  get 'hi',   to: 'trice_controller_method_test#hi'
  get 'bang', to: 'trice_controller_method_test#bang'

  scope 'api', module: nil do
    get 'hi',   to: 'trice_api_controller_method_test#hi'
    get 'bang', to: 'trice_api_controller_method_test#bang'
  end
end

TriceTestError = Class.new(StandardError)

class TriceControllerMethodTestController < ActionController::Base
  include Trice::ControllerMethods

  before_action :raise_rescued_exception, only: 'bang'

  rescue_from TriceTestError do
    render json: {expected_requested_at: requested_at}, status: 400
  end

  def hi
    @requested_at_x  = requested_at
    @requested_at_y  = requested_at

    render json: {requested_at_x: @requested_at_x, requested_at_y: @requested_at_y}
  end

  def bang
  end

  private

  def raise_rescued_exception
    raise TriceTestError
  end
end

# AC::API is available since Rails 5.0.
if defined?(ActionController::API)
  class TriceApiControllerMethodTestController < ActionController::API
    include Trice::ControllerMethods

    before_action :raise_rescued_exception, only: 'bang'

    rescue_from TriceTestError do
      render json: {expected_requested_at: requested_at}, status: 400
    end

    def hi
      @requested_at_x  = requested_at
      @requested_at_y  = requested_at

      render json: {requested_at_x: @requested_at_x, requested_at_y: @requested_at_y}
    end

    def bang
    end

    private

    def raise_rescued_exception
      raise TriceTestError
    end
  end
end

# rspec-rails must be initialized after rails
require 'rspec/rails'
require 'capybara/apparition'
