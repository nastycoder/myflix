require 'spec_helper'

feature 'user interacts with queue' do
  scenario 'user adds and reorders videos in the queue' do
    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: 'Monk', category: comedies)
    south_park = Fabricate(:video, title: 'South Park', category: comedies)
    futurama = Fabricate(:video, title: 'Futurama', category: comedies)

    sign_in

    add_video_to_queue(monk)
    expect_video_to_be_in_queue(monk)

    visit video_path(monk)
    expect_link_not_to_be_seen('+ My Queue')

    add_video_to_queue(south_park)
    add_video_to_queue(futurama)

    set_video_position(monk, 3)
    set_video_position(south_park, 1)
    set_video_position(futurama, 2)

    update_queue

    expect_video_postion(south_park, 1)
    expect_video_postion(futurama, 2)
    expect_video_postion(monk, 3)
  end

  def update_queue
    click_on 'Update Instant Queue'
  end

  def expect_link_not_to_be_seen(link_text)
    expect(page).not_to have_content link_text
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content video.title
  end

  def expect_video_postion(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq(position.to_s)
  end

  def set_video_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_on '+ My Queue'
  end
end
