require 'spec_helper'

describe Trice::ReferenceTime do
  class MyModel
    include Trice::ReferenceTime
  end

  let(:my_obj) { MyModel.new }
  let(:ref_time) { Time.iso8601('2016-02-01T00:00:00Z') }

  context 'Trice.reference_time is set' do
    around {|e| Trice.with_reference_time(ref_time) { e.run } }

    specify { expect(my_obj.reference_time).to eq ref_time }
  end

  context 'Trice.reference_time is NOT set' do
    specify { expect { my_obj.reference_time }.to raise_error(Trice::NoRefrenceTime) }
  end
end
