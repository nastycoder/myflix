require 'spec_helper'

describe Category do
  it {should have_many(:videos)}

  describe '#recent_videos' do
    before(:each) do
      @history = Category.create(name: 'History')
      @vikings = Video.create(title: 'Vikings', description: 'The tale of Ragnar Lothbrok', category: @history)
      @american_pickers = Video.create(title: 'American Pickers', description: 'Two guys go through junk', category: @history, created_at: 1.day.ago)
      @swamp_people = Video.create(title: 'Swamp People', description: 'Reality show about Gator hunters', category: @history, created_at: 2.day.ago)
      @pawn_stars = Video.create(title: 'Pawn Stars', description: 'Las Vegas pawn family', category: @history, created_at: 3.days.ago)
      @axe_men = Video.create(title: 'Axe Men', description: 'Alaskan Loggers', category: @history, created_at: 4.days.ago)
      @top_gear = Video.create(title: 'Top Gear', description: 'Automotive Performance', description: 'Puts vehicles to the test', category: @history, created_at: 5.days.ago)
      @american_restoration = Video.create(title: 'American Restoration', description: 'Restore classic cars back to former glory', category: @history, created_at: 6.days.ago)
    end
    it 'returns all videos if there are less than 6' do
      @vikings.destroy
      @american_pickers.destroy
      expect(@history.recent_videos.count).to eq(5)
    end
    it 'returns at most 6 videos' do
      expect(@history.recent_videos.count).to be(6)
    end
    it 'returns videos in order with most recent first' do
      expect(@history.recent_videos).not_to include(@american_restoration)
    end
    it 'returns an empty array if there are not any videos in the category' do
      comedy = Category.create(name: 'Comedy')
      expect(comedy.recent_videos).to eq([])
    end
  end
end
