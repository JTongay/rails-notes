# The "rails new" command creates a new Rails app.
# "bundle install" is basically the same as "npm install"
# "rails server" starts the developmental server. It's called WEBrick

### Review of MVC

# https://www.codecademy.com/articles/request-response-cycle-static

# A user opens the browser, types in URL and presses enter

# When a user presses enter, the browser makes a request for that URL

# The request hits the Rails router (config/routes.rb). The Router maps the URL to the correct controller and action to handle the request.

# The action receives the request and passes it on to the view.

# The view renders the page as HTML.

# The controller sends the HTML back to the browser. The page loads and the user sees it.


# We need three parts to build a Rails app, a controller, a route, and a view. Start by creating a controller

# 'rails generate controller Pages'

# After it finishes, open the pages_controller.rb file and add a method home

# class PagesController < ApplicationController
#
#   def home
#   end
#
# end

# The second part is to create a route. Navigate to "config/routes.rb" filepath and put in this line.

# get 'welcome' => 'pages#home'

# the url will look like /welcome and will also tell rails to send this request to the Pages controller's home action.

# The third part is to create a view. Open app/views/pages/home.html.erb and add this HTML.

# <div class="main">
#   <div class="container">
#     <h1>Hello my name is __</h1>
#     <p>I make Rails apps.</p>
#   </div>
# </div>

# This whole process will create a static site so far, but that's not good enough. Next up is database stuff.

# PART TWO

# Make a new app 'rails new MessengerApp'

# generate a new model. 'rails generate model Message'

# open new migration (db/migrate) for the messages table. The name starts with a timestamp of when it was created. Inside 'change' add the method 't.text :content'

# class CreateMessages < ActiveRecord::Migration
#   def change
#     create_table :messages do |t|
# 			t.text :content
#       t.timestamps
#     end
#   end
# end

# The 'change' method tells Rails what changes to make to the db. It uses create_table method to create a new table for storing messages.

# REALLY COOL THAT IT AUTO ADDS TIMESTAMPS WHEN YOU MAKE NEW MIGRATION (You know you always forget too...)


# run your migration 'rake db:migrate' (I'll probably have to put 'bundle exec' in front of it for future projects, but research why or why not...)

# run seeds 'rake db:seed'

# check out this diagram from codecademy
# https://www.codecademy.com/articles/standard-controller-actions

# After examination, it looks like you have to create your methods around RESTful convention (or it's just a good idea, I'm gonna do it anyways).

# class MessagesController < ApplicationController
#   def index
#     @messages = Message.all
#   end
# end

# When someone goes to the route, the routes file maps the request to the Messages controller's index action.

# The index action retrieves all messages from the DB and stores them in variable @messages.

# The @messages variable is passed on the the view. The view should display each message.

# <% @messages.each do |message| %>
# <div class="message">
#   <p class="content"><%= message.content %></p>
#   <p class="time"><%= message.created_at %></p>
# </div>
# <% end %>

# THIS LOOKS SO FAMILIAR. There's just a few differences. Make sure you look at the top and bottom lines, those are the only "different" things.

# Post routes working with this link to explain
# https://www.codecademy.com/articles/request-response-cycle-forms

# the create action uses the 'message_params' method to safely collect data from the form and update the db.

# I used 'link_to' in the html.erb to create a link to a new URL. Insted of hardcoding in a-tag elements, you use the 'link_to' to generate links.

# The first parameter is the link text
# the second parameter is the URL

# UTLIZING A ONE TO MANY RELATIONSHIP

# sidenote, it looks like you never have to create files or folders manually with rails.
# You just add everything through command line. Remember remember 'rails generate (model, controller) (name)'. Is it the same with View? I assume so...

# anyway, create a new project.
# generate model named Tag
# generate model named Destination
# In 'app/models/tag.rb' add a has_many method.

# class Tag < ActiveRecord::Base
#   has_many :destinations
# end

# In 'app/models/destinations.rb' add a 'belongs_to' method

# class Destination < ActiveRecord::Base
#   belongs_to :tag
# end

# It looks like you don't set up this relationship in a migration, but in the model. Maybe it's different with postgres, but this is with sqlite3.

# What really happened, I created 2 models named Tag and Destinations.

# In the model files, I used the methods above to define an association between Tag and Destination.

# 'has_many :destinations' denotes that a single Tag can have multiple Destinations.
# 'belongs_to :tag' denotes that each Destination belongs to a single Tag.

# THESE ARE USED TO DEFINE A ONE TO MANY RELATIONSHIP..

# going back to migrations, heres syntax for basic thing.

# t.string :title

# adding a relationship between tag and destinations in migration, you do have to put in a reference. This goes in the Destination migration.

# t.references :tag

# The above line adds a foreign key for you.

# Adding a route with a variable in the parameters. (route params)

# get 'tags/:id' => 'tags#show',
# as: :tag
