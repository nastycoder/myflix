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
end
