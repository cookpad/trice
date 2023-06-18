require 'spec_helper'
require 'trice_controller_method_test_controller'

describe 'TriceControllerMethodTestController E2E', type: :request do
  scenario 'hi' do
    get '/bang'

    expect(response.status).to eq 400
  end
end

if defined?(ActionController::API)
  describe 'TriceApiControllerMethodTestController E2E', type: :request do
    scenario 'hi' do
      get '/api/bang'

      expect(response.status).to eq 400
    end
  end
end

shared_examples 'trice controller methods' do
  describe '#requested_at should be same time' do
    before do
      get :hi
    end

    specify { expect(assigns(:requested_at_x)).to be_acts_like(:time) }
    specify { expect(assigns(:requested_at_x)).to be assigns(:requested_at_y) }
  end

  describe 'request stubbing' do
    let(:time) { Time.zone.parse('2016-02-01 00:00:00') }

    context 'stubbed by query' do
      before do
        if Rails.gem_version >= Gem::Version.new('5.0.0')
          get :hi, params: { '_requested_at' => time.strftime('%Y%m%d%H%M%S') }
        else
          get :hi, '_requested_at' => time.strftime('%Y%m%d%H%M%S')
        end
      end

      specify { expect(assigns(:requested_at_x)).to eq time }
    end

    context 'stubbed by header' do
      before do
        request.headers['X-Requested-At'] = time.iso8601
        get :hi
      end

      specify { expect(assigns(:requested_at_x)).to eq time }
    end

    context 'StubConfiguration#stubbable? is not evaluated without stubbed by param or header' do
      before do
        expect_any_instance_of(Trice::ControllerMethods::StubConfiguration).not_to receive(:stubbable?)

        get :hi
      end

      specify { expect(assigns(:requested_at_x)).to be_acts_like(:time) }
    end

    context 'stubbed by helper method (static)' do
      t = Time.now
      stub_requested_at t

      before do
        get :hi
      end

      specify { expect(assigns(:requested_at_x)).to eq Time.at(t.to_i).utc }
    end

    context 'stubbed by helper method (block)' do
      let(:time) { Time.zone.parse('2016-02-01 00:00:00') }
      stub_requested_at { time }

      before do
        get :hi
      end

      specify { expect(assigns(:requested_at_x)).to eq time }
    end

    context 'stubbed by both' do
      let(:time) { Time.zone.parse('2016-02-01 00:00:00') }

      before do
        request.headers['X-Requested-At'] = 1.day.ago(time).iso8601

        if Rails.gem_version >= Gem::Version.new('5.0.0')
          get :hi, params: { '_requested_at' => time.strftime('%Y%m%d%H%M%S') }
        else
          get :hi, '_requested_at' => time.strftime('%Y%m%d%H%M%S')
        end
      end

      specify 'prefers query params' do
        expect(assigns(:requested_at_x)).to eq time
      end
    end
  end
end

describe TriceControllerMethodTestController, type: :controller do
  it_behaves_like 'trice controller methods'
end
if defined?(ActionController::API)
  describe TriceApiControllerMethodTestController, type: :controller do
    it_behaves_like 'trice controller methods'
  end
end

describe 'stub_requested_at helper for feature spec', type: :feature do
  let(:time) { Time.zone.parse('2016-02-01 00:00:00') }
  stub_requested_at { time }

  def with_driver(driver, &block)
    saved = Capybara.current_driver
    Capybara.current_driver = driver
    block.call
  ensure
    Capybara.current_driver = saved
  end

  context 'with rack_test driver' do
    around do |example|
      with_driver(:rack_test) do
        example.run
      end
    end

    scenario do
      visit '/hi'
      expect(Time.zone.parse(JSON.parse(page.body)['requested_at_x'])).to eq(time)
    end
  end

  context 'with apparition driver' do
    around do |example|
      with_driver(:apparition) do
        example.run
      end
    end

    scenario do
      visit '/hi'
      # XXX: poltergeist returns `<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">{"requested_at_x":"2016-02-01T00:00:00.000Z","requested_at_y":"2016-02-01T00:00:00.000Z"}</pre></body></html>`
      expect(page.body).to include(time.to_json)
    end
  end
end
