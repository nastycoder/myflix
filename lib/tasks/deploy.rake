require 'paratrooper'

 namespace :deploy do
   desc 'Deploy app in staging environment'
   task :staging do
     deployment = Paratrooper::Deploy.new("staging-myflix-uriah", tag: 'staging')

     deployment.deploy
   end

   desc 'Deploy app in production environment'
   task :production do
     deployment = Paratrooper::Deploy.new("myflix-uriah") do |deploy|
       deploy.tag              = 'production'
       deploy.match_tag        = 'staging'
     end

     deployment.deploy
   end
 end
