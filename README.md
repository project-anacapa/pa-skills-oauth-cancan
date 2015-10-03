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




