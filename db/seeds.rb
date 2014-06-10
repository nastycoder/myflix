# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedy = Category.create(
    name: 'TV Commedies'
)

drama = Category.create(
    name: 'TV Dramas'
)

reality = Category.create(
    name: 'Reality TV'
)

Video.create(
    title: 'Futurama',
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.',
    category: comedy
)

Video.create(
    title: 'Monk',
    description: 'Show about an investigator',
    category: drama
)

Video.create(
    title: 'South Park',
    description: 'Crazy little cartoon kids',
    category: comedy
)

Video.create(
    title: 'Family Guy',
    description: 'Hilarious cartoon family',
    category: reality
)

User.create(full_name: 'Some One', email: 'some@one.com', password: 'password', admin: true)

Video.all.each do |video|
  5.times { video.reviews.create(user: User.first, rating: (0..5).to_a.sample, content: Faker::Lorem.paragraph) }
end
