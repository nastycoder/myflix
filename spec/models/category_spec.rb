require 'spec_helper'

describe Category do
  it 'should save' do
    category = Category.new(name: 'comedy')
    category.save

    expect(Category.first).to eq(category)
  end

  it 'should have many videos' do
    category = Category.create(name: 'comedy')
    family_guy = Video.create(title: 'Family Guy', description: 'funny video about a family', category: category)
    south_park = Video.create(title: 'South Park', description: 'crazy little kids', category: category)

    expect(category.videos.count).to be 2
    expect(category.videos).to eq([family_guy, south_park])
  end
end
