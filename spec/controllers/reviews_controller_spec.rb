require 'spec_helper'

describe ReviewsController do
  let(:user) { current_user }

  before { set_current_user }

  describe 'POST create' do
    let(:video) { Fabricate(:video) }

    context 'with valid input' do
      before do
        post :create, review: { rating: 3, content: 'Some Review' }, video_id: video.id
      end

      it 'creates the review' do
        expect(Review.count).to eq(1)
      end

      it 'associates the review and video' do
        expect(Review.first.video).to eq(video)
      end

      it 'associates the review and user' do
        expect(Review.first.user).to eq(user)
      end

      it 'redirects to video show page' do
        expect(response).to redirect_to(video)
      end
    end

    context 'with invalid input' do
      before do
        post :create, review: { rating: 2, content: '' }, video_id: video.id
      end
      it 'renders video show template' do
        expect(response).to render_template('videos/show')
      end
      it 'assigns @video' do
        expect(assigns(:video)).to eq(video)
      end
    end

    it_behaves_like('require sign in') do
      let(:action) { post :create, review: { rating: 3, content: 'Good movie' }, video_id: Fabricate(:video).id }
    end
  end
end
