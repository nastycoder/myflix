require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do
    it 'renders show template if token is valid' do
      user = Fabricate(:user)
      get :show, id: user.token
      expect(response).to render_template(:show)
    end
    it 'redirects to expired token path with invalid token' do
      get :show, id: 'alsjdhf'
      expect(response).to redirect_to(expired_token_path)
    end
    it 'assigns @user' do
      user = Fabricate(:user)
      get :show, id: user.token
      expect(assigns[:user]).to eql(user)
    end
  end
  describe 'POST create' do
    context 'with valid token' do
      let(:user) { Fabricate(:user) }
      it 'updates the user password' do
        old_password_digest = user.password_digest
        post :create, token: user.token, password: 'mynewpassword'
        expect(user.reload.password_digest).not_to eql(old_password_digest)
      end
      it 'redirects to sign in page' do
        post :create, token: user.token, password: 'mynewpassword'
        expect(response).to redirect_to(sign_in_path)
      end
      it 'sets success flash' do
        post :create, token: user.token, password: 'mynewpassword'
        expect(flash[:success]).to be_present
      end
      it 'updates the user token' do
        old_token = user.token
        post :create, token: user.token, password: 'mynewpassword'
        expect(user.reload.token).not_to eql(old_token)
      end
    end
    context 'with invalid token' do
      it 'redirects to expired token page' do
        post :create, token: 'asdfasdf', password: 'mynewpassword'
        expect(response).to redirect_to(expired_token_path)
      end
    end
  end
end
