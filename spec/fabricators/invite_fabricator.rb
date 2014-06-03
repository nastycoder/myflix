Fabricator(:invite) do
  user
  email { Faker::Internet.email }
  name { Faker::Name.name }
  message { Faker::Lorem.paragraph }
end
