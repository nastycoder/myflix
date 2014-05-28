require 'spec_helper'

feature 'user sign in' do
  given(:user) { Fabricate(:user) }

  scenario 'with valid email and password' do
    visit sign_in_path

    fill_in 'Email Address', with:  user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    expect(page).to have_content "Welcome, #{user.full_name}"
  end
end
