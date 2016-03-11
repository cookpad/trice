require 'spec_helper'

describe Trice::SpecHelper do
  describe 'stub_requested_at raises error for not supported type', type: :hi do

    stub_requested_at

    around do |example|
      example.run
      expect(example.exception).to be_a(Trice::TestStubbingNotSupported)
      expect(example.exception.message).to eq 'Test stubbing for type: hi is not supported'
      skip
    end

    specify { 'raises error for not supported type' }
  end
end
