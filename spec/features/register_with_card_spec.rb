require 'spec_helper'

feature 'user registers with card', :vcr, js: true do
  given(:email) { 'the_one@example.com' }
  given(:full_name) { 'The One' }

  scenario 'with valid card' do
    visit(register_path)
    enter_email(email)
    enter_password('password')
    enter_full_name(full_name)
    enter_card_number('4242424242424242')
    enter_security_code('123')
    select_expiration('7 - July', 1.year.from_now.year)
    click_on 'Sign Up'
    expect_to_see_successful_flash
  end
  scenario 'with invalid card' do
    visit(register_path)
    enter_email(email)
    enter_password('password')
    enter_full_name(full_name)
    enter_card_number('4242424242424242')
    select_expiration('7 - July', 1.year.from_now.year)
    click_on 'Sign Up'
    expect_to_see_invalid_card_message
  end
  scenario 'with declined card' do
    visit(register_path)
    enter_email(email)
    enter_password('password')
    enter_full_name(full_name)
    enter_card_number('4000000000000002')
    enter_security_code('123')
    select_expiration('7 - July', 1.year.from_now.year)
    click_on 'Sign Up'
    expect_to_see_declined_card_message
  end
end

def enter_email(email)
  fill_in 'Email Address', with: email
end

def enter_password(password)
  fill_in 'Password', with: password
end

def enter_full_name(full_name)
  fill_in 'Full Name', with: full_name
end

def enter_card_number(card_number)
  find('input.card-number').set(card_number)
end

def enter_security_code(cvc)
  find('input.card-cvc').set(cvc)
end

def select_expiration(month, year)
  select month, from: 'date_month'
  select year, from: 'date_year'
end

def expect_to_see_successful_flash
  expect(page).to have_content('Thanks for joining please sign in')
end

def expect_to_see_invalid_card_message
  expect(page).to have_content("Your card's security code is invalid.")
end

def expect_to_see_declined_card_message
  expect(page).to have_content("Your card was declined.")
end
