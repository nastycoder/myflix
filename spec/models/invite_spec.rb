require 'spec_helper'

describe Invite do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:message) }

  it 'generates token' do
    invite = Fabricate(:invite)
    expect(invite.token).not_to be_nil
  end

  it 'sends invitation email' do
    invite = Fabricate(:invite)
    expect(ActionMailer::Base.deliveries.last.to).to eq([invite.email])
  end

  describe '#accepted_by' do
    let(:user_1) { Fabricate(:user) }
    let(:user_2) { Fabricate(:user) }
    let(:invite) { Fabricate(:invite, user: user_1) }
    before do
      invite.accepted_by(user_2)
    end
    it 'creates a two way relationship for users' do
      expect(user_1.follows?(user_2)).to be_true
      expect(user_2.follows?(user_1)).to be_true
    end
    it 'expires the token' do
      expect(invite.token).to be_nil
    end
  end
end
