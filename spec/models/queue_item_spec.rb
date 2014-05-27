require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:video) }
  it { should validate_presence_of(:position) }

  describe 'custom validation' do
    it 'allows only one queued item per video' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      queue_item = QueueItem.new(user: user, video: video)
      expect(queue_item).not_to be_valid
    end
  end

  describe 'before_validation' do
    context 'new record' do
      it 'sets the position in queue' do
        user = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user: user)
        queue_item2 = Fabricate(:queue_item, user: user)
        expect(queue_item1.position).to eq(1)
        expect(queue_item2.position).to eq(2)
      end
    end
  end

  describe 'after_destroy' do
    it 'reorders position numbers' do
      user = Fabricate(:user)
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)
      queue_item3 = Fabricate(:queue_item, user: user)
      queue_item2.destroy
      expect(queue_item3.reload.position).to eq(2)
    end
  end

  describe '#video_title' do
    it 'returns the title of the associated video' do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq(video.title)
    end
  end

  describe '#rating' do
    it 'returns the rating of the review when review present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(review.rating)
    end
    it 'returns nil when no review if present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to be_nil
    end
  end

  describe '#category' do
    it 'returns the category of the video' do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end

  describe '#category_name' do
    it 'return the category name of the video' do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq(category.name)
    end
  end
end
