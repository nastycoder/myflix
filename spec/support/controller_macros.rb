def sign_in
  session[:user] = Fabricate(:user)
end

def current_user
  User.find(session[:user])
end

def clear_user
  session[:user] = nil
end
