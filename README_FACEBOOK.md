## Facebook

https://developers.facebook.com/apps/

Create a new app.

You'll get back an App Id.   FACEBOOK_APP_ID  is the env var that needs to point to that.

Also go to "Settings" / "Advanced" and scroll to "Client OAuth Settings".  Enter the URL for the Facebook Oauth Callback (i.e. https://project-awesome-us.herokuapp.com/auth/facebook/callback )

Under settings, add a contact email.

Under Status and Review, either set to public--or don't, depending on whether this is a production instance or a test/dev instance.

```
 FACEBOOK_APP_ID   set to what's on the https://developers.facebook.com/apps/ page
 FACEBOOK_APP_SECRET   set to what's on the https://developers.facebook.com/apps/ page
 FACEBOOK_CALLBACK_URL https://project-awesome-us.herokuapp.com/auth/facebook/callback
```

