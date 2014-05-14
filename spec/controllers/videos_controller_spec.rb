require 'spec_helper'

describe VideosController do
  describe 'GET  show' do
    it 'assigns @video with authenticated user' do
      session[:user] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it 'redirects to sign in path with unauthenticated user' do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe 'GET search' do
    it 'assigns @videos with authenticated user' do
      session[:user] = Fabricate(:user).id
      video = Fabricate(:video)
      get :search, search_term: video.title
      expect(assigns(:videos)).to eq([video])
    end

    it 'redirects to sign in path with unauthenticated user' do
      video = Fabricate(:video)
      get :search, search_term: video.title
      expect(response).to redirect_to sign_in_path
    end
  end
end
