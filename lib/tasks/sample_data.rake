namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Sarzema",
                         :email => "khplanner@gmx.de",
                         :password => "foobar",
                         :password_confirmation => "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
    5.times do |n|
      server = n+1
      User.all(:limit => 20).each do |user|
        user.doctors.create!(:name   => "Prof.Dr.Brainiac",
                             :av     => "Grey's Anatomie",
                             :server => server)
      end
    end
  end
end
