require 'spec_helper'

describe StripeWrapper::Charge do
  context 'with valid card' do
    it 'charges the card successfully', :vcr do
      charge = StripeWrapper::Charge.create(amount: 50, card: token_for_card(good_card))
      expect(charge).to be_successful
    end
  end
  context 'with invalid card' do
    let(:charge) { StripeWrapper::Charge.create(amount: 50, card: token_for_card(bad_card)) }
    it 'does not charge the card successully', :vcr do
      expect(charge).not_to be_successful
    end
    it 'contains an error message', :vcr do
      expect(charge.error_message).not_to be_nil
    end
  end
end

describe StripeWrapper::Customer do
  describe '.create', :vcr do
    let(:user) { Fabricate(:user) }
    context 'with valid card' do
      let(:response) { StripeWrapper::Customer.create({email: user.email, card: token_for_card(good_card)}) }
      it 'creates a customer successfully' do
        expect(response).to be_successful
      end
      it 'returns the customer token' do
        expect(response.token).not_to be_nil
      end
    end
    context 'with invalid card' do
      let(:response) { StripeWrapper::Customer.create({email: user.email, card: token_for_card(bad_card)}) }
      it 'does not create customer successfully' do
        expect(response).not_to be_successful
      end
      it 'set an error message' do
        expect(response.error_message).not_to be_nil
      end
    end
  end
end
