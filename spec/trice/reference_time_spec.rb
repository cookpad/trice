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
    specify { expect { my_obj.reference_time }.to raise_error(Trice::NoReferenceTime) }
  end

  context 'Trice.reference_time is set by spec helper' do
    t = Time.now
    set_reference_time t

    specify { expect(my_obj.reference_time).to eq t }
  end

  context 'Trice.reference_time is set by spec helper with block style' do
    set_reference_time { ref_time }

    specify { expect(my_obj.reference_time).to eq ref_time }
  end
end
