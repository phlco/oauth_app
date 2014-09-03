require 'httparty'
require 'pry'

class App < Sinatra::Base

  ########################
  # Configuration
  ########################

  CLIENT_ID     = ENV["GOOGLE_CLIENT_ID"]
  CLIENT_SECRET = ENV["GOOGLE_CLIENT_SECRET"]

  REDIRECT_URI  = "http://127.0.0.1:3000/oauth_callback"
  BASE_URL      = "https://accounts.google.com/o/oauth2/auth"

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
    response_type = "code"
    scope = "openid email"
    query = URI.encode_www_form({
      :client_id     => CLIENT_ID,
      :response_type => response_type,
      :scope         => scope,
      :redirect_uri  => REDIRECT_URI
    })
    @url = BASE_URL + "?" + query
    render(:erb, :oauth_login)
  end

  # google oauth
  get('/oauth_callback') do
    code = params[:code]
    # send code back
    response = HTTParty.post(
      "https://accounts.google.com/o/oauth2/token",
      :body => {
        :code          => code,
        :client_id     => CLIENT_ID,
        :client_secret => CLIENT_SECRET,
        :redirect_uri  => REDIRECT_URI,
        :grant_type    => "authorization_code"
      }
    )
    session[:access_token] = response["access_token"]
    redirect to("/")
  end

  get('/logout') do
    session[:access_token] = nil
    redirect to("/")
  end

end
