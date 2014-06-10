require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    before { set_current_admin }
    context 'with user not admin' do
      let(:action) { get :new }
      before { set_current_user }
      it_behaves_like('require sign in')
      it_behaves_like('ensure admin')
    end
    it 'assigns @video' do
      get :new
      expect(assigns(:video)).not_to be_nil
    end
  end
end
