require 'spec_helper'

feature 'social networking' do
  given(:jim) { Fabricate(:user, full_name: 'Jim Dandy') }
  given(:billy) { Fabricate(:user, full_name: 'Billy Bob') }

  scenario 'User is able to follow and unfollow another user' do
    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: 'Monk', category: comedies)
    Fabricate(:review, video: monk, user: billy)

    sign_in(jim)

    visit video_path(monk)
    expect_to_see_review(billy.reviews.first)
    click_on billy.full_name

    expect_to_see_show_page_of_user(billy)
    click_follow

    expect_to_see_people_page
    expect_to_be_following_user(billy)

    visit user_path(billy)
    expect_not_see_follow_button

    click_people_link
    unfollow_user(billy)

    expect_not_to_be_following_user(billy)
  end

  def expect_to_see_review(review)
    expect(page).to have_content(review.content)
  end

  def expect_to_see_show_page_of_user(user)
    expect(page).to have_content("#{user.full_name}'s video collections")
  end

  def click_follow
    click_on 'Follow'
  end

  def expect_to_see_people_page
    expect(page).to have_content('People I Follow')
  end

  def expect_to_be_following_user(user)
    expect(page).to have_content(user.full_name)
  end

  def expect_not_see_follow_button
    expect(page).not_to have_content('Follow')
  end

  def click_people_link
    click_link 'People'
  end

  def unfollow_user(user)
    find("a[href='/relationships/#{user.followers.first.id}']").click
  end

  def expect_not_to_be_following_user(user)
    expect(page).not_to have_content(user.full_name)
  end
end
