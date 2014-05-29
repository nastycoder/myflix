require 'spec_helper'

describe FollowingController do
  before { set_current_user }

  describe 'GET index' do
    it_behaves_like 'require sign in' do
      let(:action) { get :index }
    end
    it 'assigns @followings' do
      get :index
      expect(assigns(:followings)).not_to be_nil
    end
  end

  describe 'DELETE destroy' do
    let(:following) { Fabricate(:following, follower: current_user) }
    it_behaves_like 'require sign in' do
      let(:action) { delete :destroy, id: Fabricate(:following).id }
    end
    it 'removes the following' do
      delete :destroy, id: following.id
      expect(Following.count).to eq(0)
    end
    it 'does not remove the following if not owned by current user' do
      delete :destroy, id: Fabricate(:following)
      expect(Following.count).to eq(1)
    end
    it 'redirects to people_path' do
      delete :destroy, id: following.id
      expect(response).to redirect_to(people_path)
    end
  end
end
