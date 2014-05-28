require 'spec_helper'

describe User do
  it { should have_many(:reviews) }
  it { should have_many(:queue_items).order('position') }

  describe '#update_queue_items' do
    let(:user) { Fabricate(:user) }
    let(:queue_item1) { Fabricate(:queue_item, user: user) }
    let(:queue_item2) { Fabricate(:queue_item, user: user) }

    it 'saves all changes' do
      user.update_queue_items({queue_item1.id => { position: 2 }, queue_item2.id => { position: 1 }})
      expect(queue_item1.reload.position).to eq(2)
      expect(queue_item2.reload.position).to eq(1)
    end
    it 'normalizes the position order' do
      user.update_queue_items({queue_item1.id => { position: 4 }, queue_item2.id => { position: 2 }})
      expect(user.queue_items.map(&:position)).to eq([1, 2])
    end
  end
end
