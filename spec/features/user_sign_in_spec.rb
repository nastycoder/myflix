require 'spec_helper'

feature 'user sign in' do
  given(:user) { Fabricate(:user) }

  scenario 'with valid email and password' do
    sign_in(user)
    expect(page).to have_content "Welcome, #{user.full_name}"
  end
end
