require 'spec_helper'

describe Trice::SpecHelper do
  describe 'stub_requested_at raises error for not supported type' do
    let(:example_group) do
      RSpec.describe('stub_requested_at_not_supported_example', type: :hi) do
        extend Trice::SpecHelper

        stub_requested_at

        specify { 'do something' }
      end
    end

    let(:example) { example_group.examples.first }

    before do
      example_group.run
    end

    specify do
      expect(example.exception).to be_a(Trice::TestStubbingNotSupported)
      expect(example.exception.message).to eq 'Test stubbing for type: hi is not supported'
    end
  end
end
