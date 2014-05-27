require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    context 'with authenticated user' do
      let(:user) { Fabricate(:user) }

      before do
        session[:user] = user.id
      end
      it 'sets @queue_items to the queue_item of the logged in user' do
        item1 = Fabricate(:queue_item, user: user)
        item2 = Fabricate(:queue_item, user: user)

        get :index
        expect(assigns(:queue_items)).to eq([item1, item2])
      end
    end
    context 'with unauthenticated user' do
      it 'redirect to sign in page' do
        get :index
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end

  describe 'POST create' do
    let(:video) { Fabricate(:video) }

    before do
      post :create, video_id: video.id
    end

    context 'with authenticate user' do
      let(:user) { Fabricate(:user) }

      before do
        session[:user] = user.id
        post :create, video_id: video.id
      end

      it 'creates a queue item' do
        expect(QueueItem.count).to eq(1)
      end
      it 'creates a queue item associated with the video' do
        expect(QueueItem.first.video).to eq(video)
      end
      it 'creates a queue item associated with the user' do
        expect(QueueItem.first.user).to eq(user)
      end
      it 'redirects to my queue page' do
        expect(response).to redirect_to(my_queue_path)
      end
    end

    context 'with unauthenticate user' do
      it 'redirects to sign in page' do
        post :create, video_id: video.id
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with authenticated user' do
      let(:user) { Fabricate(:user) }

      before do
        session[:user] = user.id
      end
      it 'redirect to my queue page' do
        delete :destroy, id: Fabricate(:queue_item, user: user)
        expect(response).to redirect_to(my_queue_path)
      end
      it 'destroys the queue item' do
        delete :destroy, id: Fabricate(:queue_item, user: user)
        expect(QueueItem.count).to eq(0)
      end
      it 'does not destroy queue items owned by another user' do
        delete :destroy, id: Fabricate(:queue_item)
        expect(QueueItem.count).to eq(1)
      end
    end
    context 'with unauthenticated user' do
      it' redirects to sign in page' do
        delete :destroy, id: Fabricate(:queue_item).id
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end
