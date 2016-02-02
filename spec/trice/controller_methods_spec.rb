require 'spec_helper'
require 'trice_controller_method_test_controller'

describe TriceControllerMethodTestController, type: :controller do
  describe 'value of #requested_at' do
    before do
      get :hi
    end

    specify { expect(assigns(:requested_at)).to be_acts_like(:time) }
  end
end
