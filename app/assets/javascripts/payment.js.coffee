class Payment
  constructor: ->
    Stripe.setPublishableKey('pk_test_3sK5RX4xLPLj5wCDuvjd5Rgk');

    $('.payment-form').on 'submit', (event) => @create_stripe_token(event)

  create_stripe_token: (event) =>
    form = $(event.currentTarget)
    @disable_payment_submit(form)
    Stripe.card.createToken({
      number: $('.card-number').val(),
      cvc: $('.card-cvc').val(),
      exp_month: $('.card-expiry-month').val(),
      exp_year: $('.card-expiry-year').val()
    }, @stripe_response_handler)
    return false

  stripe_response_handler: (status, response) =>
    form = $('.payment-form')
    if response.error
      form.find('.payment-errors').text(response.error.message)
      @enable_payment_submit(form)
    else
      token = response.id
      form.append($("<input type='hidden' name='stripeToken' />").val(token))
      form.get(0).submit()

  disable_payment_submit: (form) =>
    form.find('.payment-submit').prop('disabled', true)
  enable_payment_submit: (form) =>
    form.find('.payment-submit').prop('disabled', false)

$ ->
  new Payment
