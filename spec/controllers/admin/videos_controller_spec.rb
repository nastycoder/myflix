require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    before { set_current_admin }
    context 'with user not admin' do
      let(:action) { get :new }
      before { set_current_user }
      it_behaves_like('require sign in')
      it_behaves_like('ensure admin')
    end
    it 'assigns @video' do
      get :new
      expect(assigns(:video)).not_to be_nil
    end
  end

  describe 'POST create' do
    before { set_current_admin }
    context 'with user not admin' do
      let(:action) { post :create }
      before { set_current_user }
      it_behaves_like('require sign in')
      it_behaves_like('ensure admin')
    end
    context 'with valid input' do
      before { post :create, video: Fabricate.attributes_for(:video) }
      it 'creates new video' do
        expect(Video.count).to eq(1)
      end
      it 'redirects to admin new video page' do
        expect(response).to redirect_to(new_admin_video_path)
      end
      it 'sets success flash message' do
        expect(flash[:success]).not_to be_blank
      end
    end
    context 'with invalid input' do
      before { post :create, video: {title: 'South Park'} }
      it 'does not create new video' do
        expect(Video.count).to eq(0)
      end
      it 'render admin new video template' do
        expect(response).to render_template(:new)
      end
      it 'sets @video' do
        expect(assigns(:video)).not_to be_nil
      end
      it 'sets flash error massage' do
        expect(flash[:error]).not_to be_blank
      end
    end
  end
end
