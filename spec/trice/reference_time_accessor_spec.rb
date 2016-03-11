require 'spec_helper'

describe Trice::ReferenceTimeAccessor do
  let(:ref_time) { Time.iso8601('2016-02-01T00:00:00Z') }

  after  { Trice.reference_time = nil }

  describe 'Trice.reference_time=, with non-time object' do
    specify { expect { Trice.reference_time = Object.new }.to raise_error(ArgumentError) }
  end

  describe 'Trice.reference_time=, accept AS::TWZ' do
    specify { expect { Trice.reference_time = ActiveSupport::TimeZone['UTC'].now }.not_to raise_error }
  end

  describe 'Trice.reference_time=' do
    before { Trice.reference_time = ref_time }

    specify { expect(Trice.reference_time).to eq ref_time }
  end

  describe 'Trice.reference_time, without setting before' do
    specify { expect { Trice.reference_time }.to raise_error(Trice::NoReferenceTime) }
  end

  describe 'Trice.with_reference_time' do
    let(:before_ref_time) { Time.now }

    specify do
      Trice.reference_time = before_ref_time

      Trice.with_reference_time(ref_time) do |t|
        expect(Trice.reference_time).to eq ref_time
        expect(Trice.reference_time).to be t
      end

      flunk 'Remains outside of block' unless Trice.reference_time == before_ref_time
    end
  end
end
