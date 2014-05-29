require 'spec_helper'

describe RelationshipsController do
  before { set_current_user }

  describe 'GET index' do
    it_behaves_like 'require sign in' do
      let(:action) { get :index }
    end
    it 'assigns @relationships' do
      get :index
      expect(assigns(:relationships)).not_to be_nil
    end
  end

  describe 'DELETE destroy' do
    let(:relationship) { Fabricate(:relationship, follower: current_user) }
    it_behaves_like 'require sign in' do
      let(:action) { delete :destroy, id: Fabricate(:relationship).id }
    end
    it 'removes the following' do
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end
    it 'does not remove the following if not owned by current user' do
      delete :destroy, id: Fabricate(:relationship).id
      expect(Relationship.count).to eq(1)
    end
    it 'redirects to people_path' do
      delete :destroy, id: relationship.id
      expect(response).to redirect_to(people_path)
    end
  end

  describe 'POST create' do
    it_behaves_like 'require sign in' do
      let(:action) { post :create, followed_id: Fabricate(:user).id }
    end 
    it 'saves following' do
      post :create, followed_id: Fabricate(:user).id
      expect(Relationship.count).to eq(1)
    end
    it 'redirect to people path' do
      post :create, followed_id: Fabricate(:user).id
      expect(response).to redirect_to(people_path)
    end
    it 'does not allow current user to follow the same user twice' do
      another_user = Fabricate(:user)
      Fabricate(:relationship, follower: current_user, followed: another_user)
      post :create, followed_id: another_user.id
      expect(Relationship.count).to eq(1)
    end
    it 'does not allow current user to follow themselves' do
      post :create, followed_id: current_user.id
      expect(Relationship.count).to eq(0)
    end
  end
end
