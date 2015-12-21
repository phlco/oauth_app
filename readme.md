# Sample OauthApp with Github API

Run with `rackup -p 3000`

You'll need to register your app with Github then requires setting `env_vars` for

- CLIENT_ID Github's OAuth ID
- CLIENT_SECRET Github's OAuth Secret

Depends on configuring a redirect URI set to `/auth/github/callback`

After logging in a user the access_token is stored in session and required in
the headers for future requests.

# Resources
- https://github.com/settings/applications/new
- https://developer.github.com/guides/basics-of-authentication/
- https://developer.github.com/v3/oauth/
- https://blog.heroku.com/archives/2012/5/3/announcing_better_ssl_for_your_app
- https://developers.google.com/accounts/docs/OAuth2
- https://developers.google.com/accounts/docs/OAuth2Login
