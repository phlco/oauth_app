# Sample OauthApp

Run with `rackup -p 3000`

Requires setting `env_vars` for 

- CLIENT_ID
- CLIENT_SECRET

Depends on Google Application's redirect URI set to `/oauth_callback`

After logging in a user the access_token is stored in session and required in 
the headers for future requests to google.

# Resources

- https://blog.heroku.com/archives/2012/5/3/announcing_better_ssl_for_your_app
- https://developers.google.com/accounts/docs/OAuth2
- https://developers.google.com/accounts/docs/OAuth2Login
