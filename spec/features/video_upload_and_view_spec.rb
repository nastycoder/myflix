require 'spec_helper'

feature 'video upload and view' do
  given(:admin) { Fabricate(:user, admin: true) }
  given(:user) { Fabricate(:user) }

  background { Fabricate(:category) }

  scenario 'Admin Adds video and user can view the video' do
    sign_in(admin)
    visit(new_admin_video_path)
    fill_in 'Title', with: 'Monk'
    select Category.first.name, from: 'Category'
    fill_in 'Description', with: 'Show about a detective'
    attach_file 'Large Cover', 'public/tmp/monk_large.jpg'
    attach_file 'Small Cover', 'public/tmp/monk.jpg'
    fill_in 'Video URL', with: 'http://nowhere.com/monk.mp4'
    click_on 'Add Video'
    visit(sign_out_path)

    expect(Video.count).to eq(1)
    video = Video.first

    sign_in(user)
    visit(video_path(video))

    expect(page).to have_selector("img[src='/uploads/video/large_cover/#{video.id}/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://nowhere.com/monk.mp4']")
  end
end
