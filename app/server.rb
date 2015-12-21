require 'sinatra/base'
require 'httparty'

module App
  class Server < Sinatra::Base

    ########################
    # Configuration
    ########################

    CLIENT_ID     = ENV["GITHUB_OAUTH_ID"]
    CLIENT_SECRET = ENV["GITHUB_OAUTH_SECRET"]
    REDIRECT_URI  = "http://127.0.0.1:3000/auth/github/callback"
    BASE_URL      = "https://github.com/login/oauth/authorize"

    configure do
      enable :logging
      enable :sessions
    end

    before do
      logger.info "Request Headers: #{headers}"
      logger.info "Params: #{params}"
    end

    after do
      logger.info "Response Headers: #{response.headers}"
    end

    ########################
    # Routes
    ########################

    get('/') do
      scope = "user,gists"
      query_params = URI.encode_www_form({
        :client_id     => CLIENT_ID,
        :scope         => scope
      })
      # Redirect link for users to request GitHub access
      @github_auth_link = BASE_URL + "?" + query_params
      erb(:oauth_login)
    end

    # oauth
    # If the user accepts, GitHub redirects back to site with a temporary code
    get('/auth/:provider/callback') do
      code = params[:code]
      # Exchange for an access token:
      response = HTTParty.post(
        "https://github.com/login/oauth/access_token",
        :body => {
          :code          => code,
          :client_id     => CLIENT_ID,
          :client_secret => CLIENT_SECRET,
        },
        :headers => {
          "Accept"     => "application/json",
          "User-Agent" => "OAuth Test App"
        }
      )
      session[:access_token] = response["access_token"]
      # The access token can now be used to make requests
      response = HTTParty.get(
        "https://api.github.com/user",
        :headers => {
          "Authorization" => "Bearer #{session[:access_token]}",
          "User-Agent"    => "OAuth Test App"
        }
      )
      session[:email]      = response["email"]
      session[:name]       = response["name"]
      session[:user_image] = response["avatar_url"]
      session[:provider]   = "GitHub"
      redirect to("/signed_in")
    end

    get('/signed_in') do
      erb(:signed_in)
    end

    get('/logout') do
      session[:access_token] = nil
      redirect to("/")
    end

  end # Server
end # App
