require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'assigns @user to be new_record' do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of User
    end
  end

  describe 'GET new_from_invite' do
    it 'sets @user' do
      invite = Fabricate(:invite)
      get :new_from_invite, invite_token: invite.token
      expect(assigns(:user)).not_to be_nil
    end
    it 'sets @invite_token' do
      invite = Fabricate(:invite)
      get :new_from_invite, invite_token: invite.token
      expect(assigns(:invite_token)).not_to be_nil
    end
    it 'sets user email from invite' do
      invite = Fabricate(:invite)
      get :new_from_invite, invite_token: invite.token
      expect(assigns(:user).email).to eq(invite.email)
    end
    it 'redirects to expired token page with expired token' do
      get :new_from_invite, invite_token: 'asdfasdf'
      expect(response).to redirect_to(expired_token_path)
    end
  end

  describe 'GET show' do
    let(:user) { Fabricate(:user) }
    before { set_current_user }

    it 'assigns @user' do
      get :show, id: user.id
      expect(assigns(:user)).not_to be_nil
    end

    it_behaves_like('require sign in') do
      let(:action) { get :show, id: user.id }
    end
  end

  describe 'POST create' do
    let(:token) { '123' }
    before do
      charge = double('charge')
      charge.stub(:successful?).and_return(true)
      StripeWrapper::Charge.stub(:create).and_return(charge)
    end
    it 'created new record' do
      post :create, user: Fabricate.attributes_for(:user), stripeToken: token
      expect(User.count).to eq(1)
    end
    it 'redirects to sign in path with valid params' do
      post :create, user: Fabricate.attributes_for(:user), stripeToken: token
      expect(response).to redirect_to sign_in_path
    end
    it 'renders :new template with invalid params' do
      post :create, user: { full_name: 'John Doe', email: 'john_doe@example.com' }, stripeToken: token
      expect(response).to render_template :new
    end
    it 'accepts the invite with invite' do
      post :create, user: Fabricate.attributes_for(:user), stripeToken: token, invite_token: Fabricate(:invite).token
      expect(Invite.first).to be_accepted
    end
  end
end
