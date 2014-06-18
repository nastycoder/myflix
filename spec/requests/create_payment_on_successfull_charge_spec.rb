require 'spec_helper'

describe 'create payment on successful charge' do
  let(:event_data) do
    {
      "id" => "evt_104FJD4LJXnmLwgIYO9UYDhG",
      "created" => 1403119213,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_104FJD4LJXnmLwgIAKt0HJSd",
          "object" => "charge",
          "created" => 1403119213,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_104FJD4LJXnmLwgISXlp1Wf1",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 8,
            "exp_year" => 2018,
            "fingerprint" => "fsF7KPrgVWIR8HV7",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "customer" => "cus_4FJDeumb9u4Xpw",
            "type" => "Visa"
          },
          "captured" => true,
          "refunds" => [],
          "balance_transaction" => "txn_104FJD4LJXnmLwgI3ilKT118",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_4FJDeumb9u4Xpw",
          "invoice" => "in_104FJD4LJXnmLwgIqhJ6Rm6f",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => "Myflix",
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_4FJDmAqNj0U2u4"
    }
  end
  it 'creates a payment with the web hook from stripe', :vcr do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end
  it 'associates the payment with user', :vcr do
    user = Fabricate(:user, customer_token: 'cus_4FJDeumb9u4Xpw')
    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(user)
  end
  it 'creates a payment with the amount', :vcr do
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(999)
  end
  it 'creates a payment with reference id', :vcr do
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq('ch_104FJD4LJXnmLwgIAKt0HJSd')
  end
end
