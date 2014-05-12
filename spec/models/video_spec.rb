require 'spec_helper'

describe Video do
  it 'should save' do
    video = Video.new(title: 'Great Video', description: 'some video on the web', small_cover_url: '/no/where.png')
    video.save

    expect(Video.first).to eq(video)
  end

  it 'should belong to category' do
    category = Category.create(name: 'funny')
    video = Video.create(title: 'Funny Movie', category: category)

    expect(video.category).to eq(category)
  end
end
