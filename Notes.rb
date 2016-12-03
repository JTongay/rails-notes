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
