require 'spec_helper'

feature 'user sign in' do

  scenario 'with valid email and password' do
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content "Welcome, #{user.full_name}"
  end

  scenario 'with deactivated user' do
    user = Fabricate(:user, active: false)
    sign_in(user)
    expect(page).to have_content 'Your account has been deactivated'
  end
end
