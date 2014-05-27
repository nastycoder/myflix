require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    it 'redirects to home with authenticated user' do
      session[:user] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
    it 'render :new with unauthenticated user' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST new' do
    context 'with valid credentials' do
      before do
        user = Fabricate(:user)
        post :create, {email: user.email, password: 'password'}
      end
      it 'sets session[:user]' do
        expect(session[:user]).not_to be_nil
      end
      it 'redirects to home path' do
        expect(response).to redirect_to home_path
      end
    end
    context 'with invalid credentials' do
      before do
        user = Fabricate(:user)
        post :create, {email: user.email, password: 'not_the_password'}
      end
      it 'does not set session[:user]' do
        expect(session[:user]).to be_nil
      end
      it 'redirects to sign in path with invalid credentials' do
        expect(response).to redirect_to sign_in_path
      end
      it 'sets error flash with invalid credentials' do
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe 'GET destroy' do
    before do
      session[:user] = Fabricate(:user)
      get :destroy
    end
    it 'sets session[:user] to nil' do
      expect(session[:user]).to be_nil
    end
    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end
    it 'sets notice' do
      expect(flash[:notice]).not_to be_blank
    end
  end
end
