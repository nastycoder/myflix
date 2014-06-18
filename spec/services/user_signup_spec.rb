require 'spec_helper'

describe UserSignup do
  describe '#signup' do
    context 'valid user information and valid card' do
      before do
        customer = double('customer', successful?: true, token: '12345')
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end
      it 'created new record' do
        UserSignup.new(Fabricate.build(:user)).sign_up('123', nil)
        expect(User.count).to eq(1)
      end
      it 'stores the customer token from stripe' do
        UserSignup.new(Fabricate.build(:user)).sign_up('123', nil)
        expect(User.first.customer_token).to eq('12345')
      end
      it 'accepts the invite' do
        UserSignup.new(Fabricate.build(:user)).sign_up('123', Fabricate(:invite).token)
        expect(Invite.first).to be_accepted
      end
    end
    context 'with invalid card params' do
      before do
        customer = double('customer', successful?: false, error_message: 'Your card was declined')
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
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
        expect(StripeWrapper::Customer).not_to receive(:create)
        UserSignup.new(user).sign_up('123', nil)
      end
    end
  end
end
