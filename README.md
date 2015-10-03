# pa-skills-oauth-cancan
Results of a spike for "proof of concept" and "example" of oauth via facebook, google + cancan for permission levels.

# Tutorials we used


For basic Rails stuff:

* http://guides.rubyonrails.org/getting_started.html

For OAuth:

* http://willschenk.com/setting-up-devise-with-twitter-and-facebook-and-other-omniauth-schemes-without-email-addresses/
* http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/

For Cancan

* TBD

# Steps we followed (at a high level)

(1) Generate initial scaffolding.   Use postgres so that we can run on Heroku.

```
rails new oauth-cancan-demo --database=postgresql
```

(2) Start postgres on your local machine, and generate the local database.

```
bin/rake db:create db:migrate
```

(3) Run locally to test:

```
rails s
```

(4) Create Facebook and Google Applications in the Facebook and Google Developer Consoles.

* For Facebook, see: [README_FACEBOOK.md](/README_FACEBOOK.md)
* For Google, see: [README_GOOGLE.md](/README_GOOGLE.md)

Similar steps could be taken for other OAuth providers such as Github, Twitter ,etc.

(5) Create default home page, and add nav bar to it. See http://guides.rubyonrails.org/getting_started.html steps 4.2 and 4.3. Also look at nav bar in views/layouts/application.html.erb

```
rails generate controller welcome index
```

(6) Generate scaffolding for index page student. Then add controller actions and views for menu option 1 and menu option 2 + navigation.

```
rails generate controller student index
```

(7) Add gems needed for devise, omniauth, and specific OAuth providers:

```
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
```

(8) Generate scaffolding for devise
```
rails generate devise:install
rails generate devise user
rails g migration add_name_to_users name:string
rails g model identity user:references provider:string uid:string
```

This produced the following output which suggests some things we may need to do:

```

Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

     In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  4. If you are deploying on Heroku with Rails 3.2 only, you may want to set:

       config.assets.initialize_on_precompile = false

     On config/application.rb forcing your application to not access the DB
     or load models when precompiling your assets.

  5. You can copy Devise views (for customization) to your app by running:

       rails g devise:views

===============================================================================
```

(8) Do some of things that were suggested:

* We added the line suggested in (1) about mailer.  We also added a line for pa-skills-oauth-cancacan.herokuapp.com to the production environment file, even though we're not sure if that was the right thing to do yet.
* We added the flash messages (item 3) to our app/views/layouts/application.html.erb
* Item 2 was already done.  Item (4) doesn't apply.
* We are gonna try item 5 to see what happens.

```
rails g devise:views
```

We got a bunch of views under views/devise that we'll come back to later.  We'll probably keep some, and throw some away.  Not sure yet.

(9) Generate scaffolding for user model
```
rails generate devise user
rails g migration add_name_to_users name:string
rails g model identity user:references provider:string uid:string
```

This of course requires a rake db:migrate, which we did.  

(10) Add a `before_action` of `:authenticate_user!` into  `welcome_controller.rb` to throw folks into the login screen:

```
class WelcomeController < ApplicationController

  before_action :authenticate_user!

  def index
  end
end

```

This has the effect of bringing up a login screen where they enter username/password.
That's not what we want.  We want them to login with Facebook or Google.  So, we'll need to so something about that.



(11) Added these lines to config/initializers/devise.rb

```
config.omniauth :google_oauth2, ENV['GOOGLE_OAUTH2_APP_ID'], ENV['GOOGLE_OAUTH2_APP_SECRET'], scope: "email,profile,offline", prompt: "consent"
config.omniauth :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], scope: "email"
```

(12) Added dotenv to our Gemfile
```
gem 'dotenv-rails', :groups => [:development, :test]
```
See https://github.com/bkeepers/dotenv

(13) Add .env to .gitignore and create .env with values of app ids and secrets for facebook and google
```
export GOOGLE_OAUTH2_APP_ID=dsfadfdsagdsh
export GOOGLE_OAUTH2_APP_SECRET=jyhgfsfd
export FACEBOOK_APP_ID=asdkjfbdskjbg
export FACEBOOK_APP_SECRET=zajnfdjnf

```
The actual values for the environment variables come from the developer console for facebook and google (see step 4)


(14) Open up app/models/user.rb and add :omniauthable to your devise line and remove :validatable:
```
devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
```

Try it now. You should be able to see Login with facebook / google. If you click them,
it should successfully authenticate with either facebook or google, but you will get this error:
```
The action 'facebook' could not be found for Devise::OmniauthCallbacksController
```

(15) We added this code to `app/models/identity.rb`

```
class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end
end
```

(16) In order to be able to send emails, we need an email provider.

Sendgrid is an Heroku supported email sending service.

```
heroku addons:create sendgrid:starter
```

This will give you, under your CONFIG VARS on your heroku dashboard, a `SENDGRID_USERNAME` and a `SENDGRID_PASSWORD`.

The tutorial suggested Gmail, but we'll use sendgrid instead, and add this code to config/environment.rb so that
it is there for all three environments (development, test, production).


```
ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
}
```

(17) We replaced this line in routes.rb


```
devise_for :users
```

with this line

```
devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
```