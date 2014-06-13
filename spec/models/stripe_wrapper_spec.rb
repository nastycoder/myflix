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
