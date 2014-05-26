require 'spec_helper'

describe VideosController do
  describe 'GET  show' do
    context 'with authentucated user' do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      before do
        session[:user] = user.id
        get :show, id: video.id
      end
      it 'assigns @video' do
        expect(assigns(:video)).to eq(video)
      end

      it 'assigns @review' do
        expect(assigns(:review)).not_to be_nil
        expect(assigns(:review)).to be_new_record
      end
    end

    context 'with unauthenticated user' do
      it 'redirects to sign in path' do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to redirect_to sign_in_path
      end
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
