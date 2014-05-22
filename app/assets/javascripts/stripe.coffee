class StripeForm
  STRIPE_ERROR_MAP:
    "number": "#subscription_credit_card_number"
    "exp_month": "#subscription_expiration_date"
    "exp_year": "#subscription_expiration_date"
    "cvc": "#subscription_cvc"

  constructor: (selector)->
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    @$form = $(selector)
    @creditCardNumber().payment('formatCardNumber')
    @expirationDate().payment('formatCardExpiry')
    @bind()

  bind: ->
    @$form.submit(@onSubmit)

  stripeToken: ->
    $('#subscription_stripe_token')

  creditCardNumber: ->
    $('#subscription_card_number')

  expirationDate: ->
    $('#subscription_expiration_date')

  cvc: ->
    $('#subscription_card_code')

  submitButton: ->
    @$form.find("input[type='submit']")

  disableButton: ->
    @submitButton().prop('disabled', true)

  enableButton: ->
    @submitButton().prop('disabled', false)

  requestStripeToken: =>
    Stripe.card.createToken
      number: @creditCardNumber().val()
      cvc: @cvc().val()
      exp_month: @expirationDate().payment('cardExpiryVal')['month'] || 0
      exp_year: @expirationDate().payment('cardExpiryVal')['year'] || 0
      ,
      @stripeCallback

  stripeCallback: (status, response) =>
    if response.error
      @displayError(response.error)
      @enableButton()
    else
      @clearCCFields()
      @setStripeToken(response.id)
      @submit()

  clearCCFields: ->
    @creditCardNumber().val('')
    @expirationDate().val('')
    @cvc().val('')

  setStripeToken: (value) ->
    @stripeToken().val(value)

  submit: ->
    @$form.get(0).submit()

  displayError: (error) ->
    @$form.find('.error').remove()
    $(@STRIPE_ERROR_MAP[error.param])
      .after("<span class=error>#{error.message}")

  onSubmit: (e) =>
    e.preventDefault()
    @disableButton()
    @requestStripeToken()

$ ->
  new StripeForm('.subscription')
