require 'spec_helper'

describe User do
  it { should have_many(:reviews).order('created_at DESC') }
  it { should have_many(:queue_items).order('position') }
  it { should have_many(:videos).through(:queue_items) }
  it { should have_many(:followers) }
  it { should have_many(:following) }
  it { should have_many(:invites) }

  let(:user) { Fabricate(:user) }

  it 'sends welcome email when new user is created' do
    User.create( Fabricate.attributes_for(:user) )
    expect(ActionMailer::Base.deliveries).not_to be_empty
  end

  it_behaves_like 'token generator' do
    let(:model) { Fabricate(:user) }
  end

  describe '#forgot_password' do
    it 'sends email' do
      user.forgot_password
      expect(ActionMailer::Base.deliveries).not_to be_empty
    end
  end

  describe '#deactivate' do
    before { user.deactivate }
    it 'sends deactivation notice' do
      expect(ActionMailer::Base.deliveries).not_to be_empty
    end
    it 'sets active to false' do
      expect(user.reload).not_to be_active
    end
  end

  describe '#reset_password' do
    it 'resets user token' do
      old_token = user.token
      user.reset_password('something_new')
      expect(user.reload.token).not_to eq(old_token)
    end
    it 'changes user password' do
      user.reset_password('something_new')
      expect(user.authenticate('something_new')).to be_true
    end
  end

  describe '#queued_video?' do
    let(:video) { Fabricate(:video) }
    it 'returns true if user have video in queue' do
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be_true
    end
    it 'returns false if user does not have video in queue' do
      expect(user.queued_video?(video)).to be_false
    end
  end

  describe '#update_queue_items' do
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

  describe '#follow' do
    let(:user) { Fabricate(:user) }
    it 'creates following user if can follow' do
      user.follow(Fabricate(:user))
      expect(Relationship.count).to eq(1)
    end
    it 'does not create following if not can following' do
      user.follow(user)
      expect(Relationship.count).to eq(0)
    end
  end

  describe '#follows?' do
    it 'returns true if the user is following another user' do
      another_user = Fabricate(:user)
      Fabricate(:relationship, follower: user, followed: another_user)
      expect(user.follows?(another_user)).to be_true
    end
    it 'returns false if the user is not following another user' do
      another_user = Fabricate(:user)
      expect(user.follows?(another_user)).to be_false
    end
  end

  describe '#can_follow?' do
    it 'returns false if user passed in is itself' do
      expect(user.can_follow?(user)).to be_false
    end
    it 'returns false if user passed in is already being followed' do
      another_user = Fabricate(:user)
      Fabricate(:relationship, follower: user, followed: another_user)
      expect(user.can_follow?(another_user)).to be_false
    end
    it 'returns when user passed in is not itself and not already being followed' do
      another_user = Fabricate(:user)
      expect(user.can_follow?(another_user)).to be_true
    end
  end
end
