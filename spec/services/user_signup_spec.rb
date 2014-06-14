require 'spec_helper'

describe UserSignup do
  describe '#signup' do
    context 'valid user information and valid card' do
      before do
        charge = double('charge')
        charge.stub(:successful?).and_return(true)
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end
      it 'created new record' do
        UserSignup.new(Fabricate.build(:user)).sign_up('123', nil)
        expect(User.count).to eq(1)
      end
      it 'accepts the invite' do
        UserSignup.new(Fabricate.build(:user)).sign_up('123', Fabricate(:invite).token)
        expect(Invite.first).to be_accepted
      end
    end
    context 'with invalid card params' do
      before do
        charge = double('charge')
        charge.stub(:successful?).and_return(false)
        charge.stub(:error_message).and_return('Your card was declined')
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end
      it 'does not create the user' do
        UserSignup.new(Fabricate.build(:user)).sign_up('123', nil)
        expect(User.count).to eq(0)
      end
      it 'sets error message' do
        result = UserSignup.new(Fabricate.build(:user)).sign_up('123', nil)
        expect(result.error_message).not_to be_nil
      end
    end
    context 'with invalid user params' do
      it 'does not charge the card' do
        user = User.new(full_name: 'John Doe', email: 'john_doe@example.com')
        expect(StripeWrapper::Charge).not_to receive(:create)
        UserSignup.new(user).sign_up('123', nil)
      end
    end
  end
end
