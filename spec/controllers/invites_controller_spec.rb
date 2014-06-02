require 'spec_helper'

describe InvitesController do
  before do
    set_current_user
  end

  describe 'GET new' do
    it_behaves_like 'require sign in' do
      let(:action) { get :new }
    end
    it 'assigns @invite' do
      get :new
      expect(assigns(:invite)).not_to be_nil
    end
  end
  describe 'POST create' do
    it_behaves_like('require sign in') do
      let(:action) { post :create, invite: Fabricate.attributes_for(:invite) }
    end
    it 'saves new invite' do
      post :create, invite: Fabricate.attributes_for(:invite, user: current_user)
      expect(Invite.count).to eq(1)
    end
    it 'redirects to new invite page' do
      post :create, invite: Fabricate.attributes_for(:invite, user: current_user)
      expect(response).to redirect_to(new_invite_path)
    end
    it 'sets success flash' do
      post :create, invite: Fabricate.attributes_for(:invite, user: current_user)
      expect(flash[:success]).not_to be_blank
    end
    it 'renders new template with invalid params' do
      post :create, invite: { name: 'Some One', message: 'Not going to work without email' }
      expect(response).to render_template(:new)
    end
  end
end
