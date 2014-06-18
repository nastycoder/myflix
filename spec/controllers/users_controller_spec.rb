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
    context 'successful user sign up' do
      before do
        result = double('user sign up', successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: token
      end
      it 'redirect to the sign in page' do
        expect(response).to redirect_to(sign_in_path)
      end
      it 'sets success flash' do
        expect(flash[:success]).to be_present
      end
    end
    context 'failed user sign up' do
      before do
        result = double('user sign up', successful?: false, error_message: 'It did not work')
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: { full_name: 'John Doe', email: 'john_doe@example.com' }, stripeToken: token
      end
      it 'renders :new template' do
        expect(response).to render_template :new
      end
      it 'sets error flash' do
        expect(flash[:error]).to be_present
      end
    end
  end
end
