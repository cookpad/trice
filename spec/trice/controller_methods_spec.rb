require 'spec_helper'
require 'trice_controller_method_test_controller'

describe TriceControllerMethodTestController, type: :controller do
  describe '#requested_at should be same time' do
    before do
      get :hi
    end

    specify { expect(assigns(:requested_at_x)).to be_acts_like(:time) }
    specify { expect(assigns(:requested_at_x)).to be assigns(:requested_at_y) }
  end
end
