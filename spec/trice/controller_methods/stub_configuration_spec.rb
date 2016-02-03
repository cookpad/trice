require 'spec_helper'
require 'ipaddr'
require 'trice/controller_methods/stub_configuration'

describe Trice::ControllerMethods::StubConfiguration do
  def init_with(object)
    Trice::ControllerMethods::StubConfiguration.new(object)
  end

  context 'initialized by normal object' do
    let(:request) { double('request') }

    specify { expect(init_with(true).stubbable?(request)).to be true }
    specify { expect(init_with(1).stubbable?(request)).to be true }
    specify { expect(init_with(false).stubbable?(request)).to be false }
  end

  context 'initialized by callable' do
    let(:controller) { double('controller') }

    let(:config) do
      init_with ->(c) { IPAddr.new('192.168.0.1/30').include?(c.request.remote_ip) }
    end

    specify do
      expect(controller).to receive_message_chain(:request, :remote_ip).and_return('192.168.0.2')
      expect(config.stubbable?(controller)).to be true
    end

    specify do
      expect(controller).to receive_message_chain(:request, :remote_ip).and_return('192.168.1.2')
      expect(config.stubbable?(controller)).to be false
    end
  end
end
