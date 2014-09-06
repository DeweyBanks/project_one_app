require 'sinatra/base'
require 'securerandom'
require 'httparty'
require 'redis'
require 'json'
require 'pry'

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
  # Configuration
  ########################
  $redis = Redis.new(:url => ENV["REDISTOGO_URL"])

   #######################
  # API KEYS
  #######################
  CLIENT_ID     = "ADUC4NQUYDPKE0LQVSXNVYODLYWZVBVX0ATI1QG2IRMGUQ05"
  CLIENT_SECRET = "WCSCAE3L5S2NBIT4I0UQFFUBLFLZ3CBE3DANTRTPZEBGGX0H"
  CALLBACK_URL  = "http://127.0.0.1:9292/oauth_callback"

  ACCESS_TOKEN = "https://foursquare.com/oauth2/access_token"
  AUTORIZE_URL = "https://foursquare.com/oauth2/authorize"

  ########################
  # Routes
  ########################

  get('/') do
    state = SecureRandom.urlsafe_base64
    @url = " https://foursquare.com/oauth2/authenticate?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{CALLBACK_URL}"
    render(:erb, :index)
  end

  get('/oauth_callback') do
    code = params[:code]
    response = HTTParty.get("https://foursquare.com/oauth2/access_token?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&grant_type=authorization_code&redirect_uri=#{CALLBACK_URL}&code=#{code}")
    # binding.pry
    session[:access_token] = response["access_token"]
    render(:erb, :forum)
    end

  get '/logout' do
    "I'm Done!"
  end

  get '/forum' do
    @redis["#{@post}"] = "#{@topic}"
    render(:erb, :forum)
  end

  post '/post' do
    post = params[:post]
    thread = params[:thread]
    entry = { post: post, thread: thread }
    @redis.set["#{@post}"] = "#{@topic}"
    redirect to("/post")
  end

  post('/cat_store') do
    @number_of_cats = params[:quantity].to_i * 10
    redirect to('/')
  end
end


