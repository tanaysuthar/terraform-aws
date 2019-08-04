# Hello World Application in Ruby on Rails


## Install pacakge dependencies on CentOS machine
```
sudo yum install -y curl gpg gcc gcc-c++ make -y
Sudo yum install epel-release -y
Sudo yum install nodejs npm -y
```
## Install RVM
```
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm reload
```

## Install Ruby
```
rvm install 2.6
```
## Install rails
```
gem install rails
```

# Build and Start Hello World Application

## Create a new hello world application by following command
```
rails new hello_world
cd hello_world
```

## Start the application 
rails server --binding=0.0.0.0 -p 9999

Let’s create our first controller named pages. From the command line
```
rails generate controller pages

Running via Spring preloader in process 1727
      create  app/controllers/pages_controller.rb
      invoke  erb
      create    app/views/pages
      invoke  test_unit
      create    test/controllers/pages_controller_test.rb
      invoke  helper
      create    app/helpers/pages_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/pages.coffee
      invoke    scss
      create      app/assets/stylesheets/pages.scss
```
Edit the app/controllers/pages_controller.rb

```
vi app/controllers/pages_controller.rb

class PagesController < ApplicationController
     def home
          puts "Hello World!"
     end
end

```

Create a file in this folder with the name home.html.erb under app/views/pages/. The erb extension implies that this file will be processed by Rails in order to embed any dynamic content.

Edit the app/controllers/pages_controller.rb
```
vi app/views/pages/home.html.erb

<h1>Hello World!!</h1>
````

Edit the config/route.rb - root path / will be served by our controller’s home action
```
vi config/routes.rb

Rails.application.routes.draw do
   root to: 'pages#home'
end
```
Access the browser with Public IP of server followed by 9999 
```
http://<< Public IP of server >>:9999
```

We can also perform Hello world!! text being passed to the view from the controller’s action

Edit the app/controllers/pages_controller.rb
```
vi app/controllers/pages_controller.rb

class PagesController < ApplicationController
     def home
          @greeting =  "Hello World!"
     end
end
```
Change the home action by editing app/views/pages/home.html.erb
```
vi app/views/pages/home.html.erb

<h1><%= @greeting %></h1>
```

