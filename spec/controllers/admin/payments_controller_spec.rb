require 'spec_helper'

describe Admin::PaymentsController do
  describe 'GET index' do
    context 'with user not admin' do
      let(:action) { get :index }
      before { set_current_user }
      it_behaves_like 'require sign in'
      it_behaves_like 'ensure admin'
    end
    context 'with admin user' do
      before do
        set_current_admin
        get :index
      end
      it 'assigns @payments' do
        expect(assigns(:payments)).not_to be_nil
      end
    end
  end
end
