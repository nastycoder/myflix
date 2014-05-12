require 'spec_helper'

describe Video do
  it 'should save' do
    video = Video.new(title: 'Great Video', description: 'some video on the web', small_cover_url: '/no/where.png')
    video.save

    expect(Video.first).to eq(video)
  end
end
