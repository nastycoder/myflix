require 'spec_helper'

describe Video do
  it {should belong_to(:category)}
  it {should have_many(:reviews).order('created_at DESC')}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}

  describe '#search_by_title' do
    before(:each) do
      @family_guy = Video.create(title: 'Family Guy', description: 'Cartoon about a family man', created_at: 1.day.ago)
      @family_man = Video.create(title: 'Family Man', description: 'Video about a real life family man')

    end
    it 'returns an empty array when no matches are found' do
      expect(Video.search_by_title('south')).to eq([])
    end
    it 'returns an array of one when an expect match' do
      expect(Video.search_by_title('Family Guy')).to eq([@family_guy])
    end
    it 'returns an array of one for a partial match' do
      expect(Video.search_by_title('guy')).to eq([@family_guy])
    end
    it 'returns an array of all matches ordered by created_at' do
      expect(Video.search_by_title('family')).to eq([@family_man, @family_guy])
    end

    it 'returns an empty array when given an empty string' do
      expect(Video.search_by_title('')).to eq([])
    end
  end

  describe '#average_rating' do
    it 'returns 0 with no reviews' do
      video = Fabricate(:video)
      expect(video.average_rating).to eq(0)
    end
  end
end
