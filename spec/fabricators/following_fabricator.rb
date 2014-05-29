Fabricator(:following) do
  follower { Fabricate(:user) }
  followed { Fabricate(:user) }
end
