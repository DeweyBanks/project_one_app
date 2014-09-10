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
  # DB Configuration
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

  get("/") do
    state = SecureRandom.urlsafe_base64
    @url = " https://foursquare.com/oauth2/authenticate?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{CALLBACK_URL}"
    render(:erb, :index)
  end


  get("/oauth_callback") do
    code = params[:code]
    response = HTTParty.get("https://foursquare.com/oauth2/access_token?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&grant_type=authorization_code&redirect_uri=#{CALLBACK_URL}&code=#{code}")
    session[:access_token] = response["access_token"]
    redirect("/entries")
    end

  get("/entries") do
    @timestamp = Time.new
    entry_keys = $redis.keys("*entry:*")   # get all the keys
    entries = entry_keys.map { |key| $redis.get(key) } # get all the values
    @post = entries.map { |entry| JSON.parse(entry) } # convert json into array of hashes
    render(:erb, :show)
  end

  post("/entries") do
    index = $redis.incr("entries:counter")
    entry = params
    $redis.set("entry:#{index}", entry.to_json)
    redirect("/entries")
  end

  get("/new_topic") do

    render(:erb, :new_topic)
  end

  post("/new_topic") do
    index = $redis.incr("entries:counter")
    entry = params
    $redis.set("entry:#{index}", entry.to_json)
    render(:erb, :new_topic)
  end

  get("/leave_comment") do
    entry = params
    $redis.set(:messages => params["body"])
    render(:erb, :topic)
  end

  get("/topic/:id") do
    id = params[:id]
    @entry = JSON.parse($redis.get("entry:#{id}"))
    render(:erb, :inspect)
  end

end


