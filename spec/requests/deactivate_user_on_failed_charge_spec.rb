require 'spec_helper'

describe 'deactivate user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_104FL14LJXnmLwgILDs083Q1",
      "created" => 1403125936,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_104FL14LJXnmLwgI7uWihm9E",
          "object" => "charge",
          "created" => 1403125936,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_104FKz4LJXnmLwgINrPfDiK7",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 6,
            "exp_year" => 2020,
            "fingerprint" => "eaFFYdDc16Wo2G47",
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
          "captured" => false,
          "refunds" => [

          ],
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_4FJDeumb9u4Xpw",
          "invoice" => nil,
          "description" => "",
          "dispute" => nil,
          "metadata" => {
          },
          "statement_description" => nil,
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_4FL1Rf6zAjL7Bp"
    }
  end
  it 'deactives a user with a charge failed', :vcr do
    user = Fabricate(:user, customer_token: 'cus_4FJDeumb9u4Xpw')
    post '/stripe_events', event_data
    expect(user.reload).not_to be_active
  end
end
