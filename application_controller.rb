class App < Sinatra::Base

  ########################
  # Configuration
  ########################
  enable :method_override
  enable :sessions
  set :session_secret, 'super secret'

  configure do
    enable :logging
    enable :method_override
    enable :sessions
  end

  before do
    logger.info "Request Headers: #{headers}"
    logger.warn "Params: #{params}"
  end

  after do
    logger.info "Response Headers: #{response.headers}"
  end

  ########################
  # DB Configuration
  ########################
  uri = URI.parse(ENV['REDISTOGO_URL'])
  $redis = Redis.new({
    :host     => uri.host,
    :port     => uri.port,
    :password => uri.password
    })

   #######################
  # API KEYS
  #######################
  CALLBACK_URL  = 'http://rotected-brook-1862.herokuapp.com/oauth_callback'
  ACCESS_TOKEN  = 'https://foursquare.com/oauth2/access_token'
  AUTORIZE_URL  = 'https://foursquare.com/oauth2/authorize'
  CLIENT_ID     = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']
end
