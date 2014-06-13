def set_current_user
  session[:user] = Fabricate(:user).id
end

def set_current_admin
  session[:user] = Fabricate(:user, admin: true).id
end

def current_user
  User.find(session[:user])
end

def clear_current_user
  session[:user] = nil
end

def sign_in(user = Fabricate(:user))
  visit sign_in_path

  fill_in 'Email Address', with:  user.email
  fill_in 'Password', with: 'password'
  click_on 'Sign in'
end

def token_for_card(card_number)
  Stripe::Token.create(
    card: {
      number: card_number,
      exp_month: 1,
      exp_year: 1.year.from_now.year,
      cvc: 123
    }
  ).id
end

def good_card
  '4242424242424242'
end

def bad_card
  '4000000000000002'
end
