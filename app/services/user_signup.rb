class UserSignup
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invite_token)
    if @user.valid?
      customer = handle_charge(stripe_token)

      if customer.successful?
        @user.customer_token = customer.token
        @user.save
        handle_invite(invite_token)
        @status = :success
        self
      else
        @status = :failed
        @error_message = customer.error_message
        self
      end
    else
      @status = :failed
      @error_message = 'There was a problem with one or more fields'
      self
    end
  end

  def successful?
    @status == :success
  end

  def error_message
    @error_message
  end

  private
    def handle_invite(invite_token)
      invite = Invite.where(token: invite_token).first
      if invite
        invite.accepted_by(@user)
      end
    end

    def handle_charge(stripe_token)
      StripeWrapper::Customer.create(
        email:        user.email,
        card:         stripe_token,
      )
    end
end
