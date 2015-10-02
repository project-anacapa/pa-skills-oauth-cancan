Navigate to https://console.developers.google.com/project?authuser=0

Create the app, then navigate to APIs.   Navigate to the Google+ API.  Click "Enable API".

Then go to Credentials.

Under OAuth, go to "create a new client id".

Create a new application/web application.

Under authorized JavaScript origins, use: https://project-awesome-us.herokuapp.com

Under Callback URL, use: https://project-awesome-us.herokuapp.com/auth/google/callback



```
 GOOGLE_APP_ID
 GOOGLE_APP_SECRET
 GOOGLE_CALLBACK_URL
```
