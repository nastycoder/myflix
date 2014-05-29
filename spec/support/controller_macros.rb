def set_current_user
  session[:user] = Fabricate(:user)
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
  fill_in 'Password', with: user.password
  click_on 'Sign in'
end