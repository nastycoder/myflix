require 'spec_helper'

describe QueueItemsController do
  let(:user) { current_user }
  before { sign_in }

  describe 'GET index' do
    it 'sets @queue_items to the queue_item of the logged in user' do
      item1 = Fabricate(:queue_item, user: user)
      item2 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to eq([item1, item2])
    end
    it_behaves_like('require sign in') do
      let(:action) { get :index }
    end
  end
  
  describe 'POST create' do
    let(:video) { Fabricate(:video) }

    it 'creates a queue item' do
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
    it 'creates a queue item associated with the video' do
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end
    it 'creates a queue item associated with the user' do
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(user)
    end
    it 'redirects to my queue page' do
      post :create, video_id: video.id
      expect(response).to redirect_to(my_queue_path)
    end

    it_behaves_like('require sign in') do
       let(:action) { post :create, video_id: video.id }
    end
  end

  describe 'DELETE destroy' do
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
    it_behaves_like('require sign in') do
       let(:action) { delete :destroy, id: Fabricate(:queue_item).id }
    end
  end

  describe 'PUT batch_update' do
    let(:queue_item_1) { Fabricate(:queue_item, user: user) }
    let(:queue_item_2) { Fabricate(:queue_item, user: user) }

    context 'with valid input' do
      before do
        params_hash = { queue_item_1.id => {position: 2}, queue_item_2 => {position: 1} }
        put :batch_update, { queue_items: params_hash }
      end
      it 'redirects to my queue page' do
        expect(response).to redirect_to(my_queue_path)
      end
      it 'updates queue positions' do
        expect(queue_item_1.reload.position).to eq(2)
        expect(queue_item_2.reload.position).to eq(1)
      end
    end
    context 'with invalid input' do
      before do
        params_hash = { queue_item_1.id => {position: ''}, queue_item_2 => {position: 1} }
        put :batch_update, { queue_items: params_hash }
     end
      it 'redirects to my queue page with error flash' do
        expect(response).to redirect_to(my_queue_path)
        expect(flash[:error]).not_to be_blank
      end
      it 'does not update queue positions' do
        expect(queue_item_1.reload.position).to eq(1)
        expect(queue_item_2.reload.position).to eq(2)
      end
    end
    context 'with queue items not owned by user' do
      it 'does not change queue positions' do
        params_hash = { queue_item_1.id => {position: 2}, queue_item_2 => {position: 1} }
        session[:user] = Fabricate(:user).id
        put :batch_update, { queue_items: params_hash }
        expect(queue_item_1.reload.position).to eq(1)
        expect(queue_item_2.reload.position).to eq(2)
      end
    end
    it_behaves_like('require sign in') do
      let(:action) { put :batch_update, queue_items: { Fabricate(:queue_item).id => { position: 3 } } }
    end
  end
end
