Fabricator(:review) do
  user
  video
  rating { (0..5).to_a.sample }
  content { Faker::Lorem.paragraph }
end