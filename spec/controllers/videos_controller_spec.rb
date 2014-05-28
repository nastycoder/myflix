require 'spec_helper'

describe VideosController do
  let(:user) { current_user }
  before { sign_in }

  describe 'GET index' do
    it 'assigns @categories' do
      get :index
      expect(assigns(:categories)).not_to be_nil
    end
    it_behaves_like('require sign in') do
      let(:action) { get :index }
    end
  end
  
  describe 'GET  show' do
    let(:video) { Fabricate(:video) }

    it 'assigns @video' do
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
    it 'assigns @review' do
      get :show, id: video.id
      expect(assigns(:review)).not_to be_nil
      expect(assigns(:review)).to be_new_record
    end
    it_behaves_like('require sign in') do
      let(:action) { get :show, id: video.id }
    end
  end

  describe 'GET search' do
    let(:video) { Fabricate(:video) }
    it 'assigns @videos' do
      get :search, search_term: video.title
      expect(assigns(:videos)).to eq([video])
    end
    it_behaves_like('require sign in') do
      let(:action) { get :search, search_term: video.title }
    end
  end
end
