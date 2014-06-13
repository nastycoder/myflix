require 'spec_helper'

feature 'invite a friend' do
  given(:tom) { Fabricate(:user, full_name: 'Tom N. Jerry') }
  given(:friend) { {name: 'Jimmy John', email: 'wish_i_had_a_sub@sandwich.com'} }

  scenario 'user invites a friend to myflix', :vcr, js: true do
    sign_in(tom)
    visit new_invite_path
    fill_in_invite_form_with(friend)
    expect_email_to_be_sent_to(friend[:email])
    visit sign_out_path

    open_email(friend[:email])
    accept_the_invite
    fill_in_register_form_for(friend)
    sign_in(User.last)
    visit people_path
    expect_to_be_following(tom)
  end
end

def fill_in_invite_form_with(friend)
  fill_in "Friend's Name", with: friend[:name]
  fill_in "Friend's Email Address", with: friend[:email]
  click_on 'Send Invitation'
end

def expect_email_to_be_sent_to(email)
  expect(ActionMailer::Base.deliveries.last.to).to eq([email])
end

def accept_the_invite
  expect(current_email).to have_content('Click here to join')
  visit(register_from_invite_path(invite_token: Invite.first.token))
end

def fill_in_register_form_for(friend)
  fill_in 'Password', with: 'password'
  fill_in 'Full Name', with: friend[:name]
  find('.card-number').set(good_card)
  find('.card-cvc').set('123')
  select '7 - July', from: 'date_month'
  select 1.year.from_now.year, from: 'date_year'
  click_on 'Sign Up'
end

def expect_to_be_following(user)
  expect(page).to have_content(user.full_name)
end
