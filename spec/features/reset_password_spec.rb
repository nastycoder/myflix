require 'spec_helper'

feature 'reset password' do
  scenario 'user forgot password workflow' do
    user = Fabricate(:user, password: 'ill_never_remember_this')
    begin_to_sign_in
    click_forgot_password
    expect_to_see_forgot_password_page
    fill_in_forgot_password_form_with(user.email)
    check_email_of(user)
    click_email_reset_password_link
    expect_to_see_reset_password_page
    fill_in_reset_password_form_with('password')
    expect_to_see_sign_in_page
    sign_in(user)
    expect_sign_in_to_be_successful_for(user)
  end

  def begin_to_sign_in
    visit root_path
    click_link 'Sign In'
  end

  def click_forgot_password
    click_link 'Forgot Password?'
  end

  def expect_to_see_forgot_password_page
    expect(page).to have_content('Forgot Password?')
  end

  def fill_in_forgot_password_form_with(email)
    fill_in :email, with: email
    click_button 'Send Email'
  end

  def check_email_of(user)
    open_email(user.email)
  end

  def click_email_reset_password_link
    current_email.click_link 'Reset my Password'
  end

  def expect_to_see_reset_password_page
    expect(page).to have_content('Reset Your Password')
  end

  def fill_in_reset_password_form_with(password)
    fill_in :password, with: password
    click_button 'Reset Password'
  end

  def expect_to_see_sign_in_page
    expect(page).to have_content('Sign in')
  end

  def expect_sign_in_to_be_successful_for(user)
    expect(page).to have_content(user.full_name)
  end
end
