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

# in the controller, add the show method

# def show
#     @tag = Tag.find(params[:id])
#     @destinations = @tag.destinations
# end

# Add this to the tags index to go to the route with the parameter. What goes into the tag_path is the name of the "argument" in the loop.
# <%= link_to "Learn more", tag_path(tag) %>

# A bigger breakdown:

# When a user visits /tags/1, the route "get '/tags/:id' => 'tags#show'" sends this request to the Tags controller's show actions with {id: 1} in the params.

# The '@destinations = @tag.destinations' retrieves all the destinations that belong to the tag, and stores them in the variable @destinations. The 'has_many/belongs_to' association lets us query for destinations like this.

# The tag and its destinations are sent to the view to be displayed.

# FORMS

# <%= form_for(@destination) do |f| %>
#       <%= f.text_field :name %>
#       <%= f.text_field :description %>
#       <%= f.submit "Update", :class => "btn" %>
# <% end %>

# Here's some syntax for forms, looks like .erb handles a lot, but definitely look at the docs for more info.

# More Info on Editing.

# The browser makes an HTTP GET request for the URL '/destinations/1/edit'

# The Rails router maps the URL to the Destinations controller's edit method. The edit method finds the destination with id 1, stores it in @destination with id 1, and passes it on the to the view.

# In the view, 'form_for' creates a form with the fields of the @destination object.

# Then when you fill out the form and submit it, it triggers the second turn of the request/response cycle.

# The browser sends the data to the Rails app via an HTTP POST request to the URL '/destinations/update'

# This time, the Rails router maps the URL to the update method.

# The update method uses the 'destination_params' method to safely collect data from the form. It finds the destination in the db, updates its stuff, and redirects to the destination's show page.

# MANT TO MANY

# I'm using the use case of Actors, Movies, and Parts. Here's how you connect the relationship with the Movie Class. In english this means a movie has many parts, a movie has many actors, and parts belongs to actors.

# class Movie < ActiveRecord::Base
#   has_many :parts
#   has_many :actors, through: :parts
# end

# In the Actor class, here's hwo you define the relationship with parts and movies. An actor has many parts, an actor has many movies which is connected to a part.

# class Actor < ActiveRecord::Base
#   	has_many :parts
#   	has_many :movies, through: :parts
# end

# In the Parts class, here's how you connect the relationship with movies and actors. A part belongs to a movie. and a part belongs to an actor.

# class Part < ActiveRecord::Base
#   belongs_to :movie
#   belongs_to :actor
# end

# Check out this ERD for the 3 tables
# https://s3.amazonaws.com/codecademy-content/courses/learn-rails/img/has-many-through.svg

# The 'has_many :through' association sets up a many-to-many relationship between movies and actors.

# In your migrations for the parts table, add these columns to set up the relationship in the db. Checkout what the index:true part means later on.

# t.belongs_to :movie, index: true
# t.belongs_to :actor, index: true

# t.belongs_to methods in the parts table adds the foreign keys.

# remember in your controller define an index method that will grab everything you want.
#
# class MoviesController < ApplicationController
#   def index
#     @movies = Movie.all
#   end
# end

 # remember this is how you loop through the array you just created with your db call in your controller.

 # <% @movies.each do |movie|  %>
 #    	<div class="movie">
 #        <img src=<%=movie.image %> />
 #        <h3><%=movie.title %> </h3>
 #        <p><%=movie.release_year  %>  </p>
 #      </div>
 # <% end %>

# Remember, this is how you set up the route with a "variable" and setting it as kind of a variable in your controller.

# get '/movies/:id' => 'movies#show', as: :movie

# In your show method, this is how you grab the movie by its ':id' then retrieve all the actors that belong to the movie, and store them in the '@actors' variable.

# def show
#     @movie = Movie.find(params[:id])
#     @actors = Movie.find(@movie)
# end

# btw, check this out for image tags
# <%= image_tag @movie.image %>


# codecademy done! check out the docs to answer the questions later

# USER AUTH/REG

# https://s3.amazonaws.com/codecademy-content/projects/3/two-turns-post.svg

# When a user visits the signup page, the browser makes an HTTP GET request for the URL /signup

# The Rails router maps the URL /signup to the Users controller's "new" action. The "new" action handles the request and passes it on to the view.

# The view displays the signup form.


# When the user fills in and submits the form, the browser sends the data via an HTTP POST request to the app.

# The router maps the request to the Users controller's "create" action.

# The "create" action saves the data to the database and redirects to the albums page. The action also creates a new SESSION.

# generate a User model

# add this method to the User model
# has_secure_password

# the above method adds functionality to save passwords securely.

# In order the save passwords securely, "has_secure_password" uses an algorithm called bcrypt. The use it, we added the bcrypt gem to the Gemfile.

# We created a Users controller, then added the following route in the routes file.

# get 'signup'  => 'users#new'
# resources :users

# Note that this really is 2 lines.

# Add the new method in the Users controller.

# def new
#   @user = User.new
# end

# Then in the view, add the form.

# <%= form_for(@user) do |f| %>
#       <%= f.text_field :first_name, :placeholder => "First name" %>
#       <%= f.text_field :last_name, :placeholder => "Last name" %>
#       <%= f.email_field :email, :placeholder => "Email" %>
#       <%= f.password_field :password, :placeholder => "Password" %>
#       <%= f.submit "Create an account", class: "btn-submit" %>
#     <% end %>

# Now we have to take in the data that is submitted through the signup form and save it to the database. In the Users controller, add a private method "user_params"

# private
  # def user_params
  #   params.require(:user).permit(:first_name, :last_name, :email, :password)
  # end

# Then, create the "create" method

# def create
#     @user = User.new(user_params)
#     if @user.save
#       session[:user_id] = @user.id
#       redirect_to '/'
#     else
#       redirect_to '/signup'
#     end
#   end

# The session is created with...

# session[:user_id] = @user.id

# it takes the value ""@user.id" and assigning it to the key ":user_id".

# check the data we just saved using "rails console". It's a useful tool to interact with Rails apps. Use it to query the database.

# Now theres login.

# start by adding a login page. We need 5 pars to add to the login machinery. The model, controller, routes, views, and logic for sessions. The user model is already created when building the signup page, but lets start by generating a controller.

# add controller called Sessions.

# create a route for 'login' (sessions#new)

# define a method for new in the sessions controller.

# Then add the form in the view.

# <%= form_for(:session, url: login_path) do |f| %>
#   <%= f.email_field :email, :placeholder => "Email" %>
#   <%= f.password_field :password, :placeholder => "Password" %>
#   <%= f.submit "Log in", class: "btn-submit" %>
# <% end %>

# In the login form, we use "form_for(:session, url: login_path) do". This refers to the name of the resource and corresponding URL.
# In the signup form, we used "form_for(@user) do |f|" since we had a User model. For the login form, we don't have a Session model, so we refer to the parameters above.

# Next, in the routes file, create a route that maps the URL '/login' to the Session controller's "create" action.

# post 'login' => 'sessions#create'

# Next in the sessions controller, define the create method like so....


# def create
# @user=User.find_by_email(params[:session][:email])
#   if @user && @user.authenticate(params[:session][:password])
#     session[:user_id] = @user.id
#     redirect_to '/'
#   else
#     redirect_to 'login'
#   end
# end


# Now that a user can log in, add the ability to logout.

# In the routes file, create route that maps the URL '/logout' to the Sessions controller's 'destroy' action.

# delete 'logout' => 'sessions#destroy'

# Then in the sessions controller, add the destroy action by setting the session hash to nil and redirect to the root path.

# def destroy
#   session[:user_id] = nil
#   redirect_to '/'
# end

# The problem now, is after you logout, you can still access portions of the page that should be closed off to non-users.

# You need to check whether a user is logged in before sender a request on the controller's index actions.

# In the application controller had a "helper_method" called "current_user".

# helper_method :current_user
#
# def current_user
#   @current_user ||= User.find(session[:user_id]) if session[:user_id]
# end

# Also add another method called "require_user". For some reason, this doesn't use "helper_method".

# def require_user
#   redirect_to '/login' unless current_user
# end

# The "current_user" method determines whether a user is logged in or logged out. It does this by checking whether there's a user in the database with a given session id.
# If there is, this means the user is logged in and "@current_user" will store that user; otherwise the user is logged out and "@current_user" will be nil.

# The line "helper_method :current_user" makes "current_user" method available in the views. By default, all methods defined in Application Controller are already available in the controllers.

# The "require_user" method uses the "current_user" method to redirect logged out users to the login page.


# MORE INFO ON THE ||= syntax.

# a ||= b is the same as...
# a || a = b

# > a ||= 1;
# => 1
# > a ||= 2;
# => 1
#
# > foo = false;
# => false
# > foo ||= true;
# => true
# > foo ||= false;
# => true

# MORE INFO ON "unless"

# The unless keyword is just "if" in reverse. It's a conditional statement that executes only if the condition is false instead of true.

# Back to the action, use the "require_user" in the Album's controller in order to prevent logged out users from accessing certain pages. In the controller, add this action.

# before_action :require_user, only: [:index, :show]

# The "before_action" command calls the "require_user" method before running the index or show actions.

# Now, use "current_user" in the application layout to update the nav items depending on whether a user is logged in or out.

# <% if current_user %>
#   <ul>
#     <li><%= current_user.email %></li>
#     <li><%= link_to "Log out", logout_path, method: "delete" %></li>
#   </ul>
# <% else %>
#   <ul>
#     <li><%= link_to "Login", 'login' %></a></li>
#     <li><%= link_to "Signup", 'signup' %></a></li>
#   </ul>
# <% end %>

# Now it's time to build an authorization system. Basically admin privelges.

# The browser makes a request for a URL

# The request hits the Rails router

# Before the router sends the request on to the controller action, the app determines whether the user has access permission by looking at the user's role.

# A user's role is specified in the database.

# Add the role column in the Users table.

# t.string :role

# Now add a method in the User model that will help us use the role column in our application. Within the class User, beneath the ":has_secure_password".

# def editor?
#   self.role == 'editor'
# end

# You should now be able to use the editor? method to check whether a user has an editor role. First, start the Rails console.

# rails console

# Then check whether Mateo is an editor.

# > mateo = User.find_by(email: 'mateo@email.com')
# > mateo.editor?

# It should return true.

# The method "editor?" checks whether a user's role is "editor" and returns true or false. The method "self" to refer to the current instance of the User object.

# Now add a few methods to the Application Controller.

# def require_editor
#   redirect_to '/' unless current_user.editor?
# end

# Next in the whatever controller, add this action that uses "require_editor" to permit only users with an editor role to access the "show" and "edit actions"

# before_action :require_editor, only: [:show, :edit]

# Then in the view, use the "editor?" method to display an edit link only if a user is an editor

# <% if current_user && current_user.editor? %>
#   <p class="recipe-edit">
#     <%= link_to "Edit Recipe", edit_recipe_path(@recipe.id) %>
#   </p>
# <% end %>

# In the User model, add a method named "admin?" that determines whether a user has an admin role on the site.

# def admin?
#     self.role == 'admin'
# end

# in the application controller, create a method named "require_admin"

 # before_action :require_admin, only: [:destroy]

 
