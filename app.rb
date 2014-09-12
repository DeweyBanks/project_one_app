require './application_controller'

class App < ApplicationController
  get('/') do
    state = SecureRandom.urlsafe_base64
    @url = " https://foursquare.com/oauth2/authenticate" \
    "?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{CALLBACK_URL}"
    render(:erb, :login)
  end

  get('/oauth_callback') do
    code = params[:code]
    response = HTTParty.get('https://foursquare.com/oauth2/access_token',
      :query => {
        :client_id      => CLIENT_ID,
        :client_secret  => CLIENT_SECRET,
        :grant_type     => 'authorization_code',
        :redirect_uri   => CALLBACK_URL,
        :code           => 'code'
      })
    session[:access_token] = response['access_token']
    redirect to('/entries')
  end

  get('/entries') do
    @timestamp = Time.new
    entry_keys = $redis.keys('*entry:*')   # get all the keys
    entries = entry_keys.map { |key| $redis.get(key) } # get all the values
    # convert json into array of hashes
    @post = entries.map { |entry| JSON.parse(entry) }
    render(:erb, :"topics/show")
  end

  post('/entries') do
    index = $redis.incr('entries:counter')
    entry = {}
    entry['messages'] = []
    entry['topic'] = params['topic']
    entry['user'] = params['user']
    entry['id'] = index
    $redis.set("entry:#{index}", entry.to_json)
    redirect to('/entries')
  end

  get('/new_topic') do
    @timestamp = Time.new
    entry_keys = $redis.keys('*entry:*')   # get all the keys
    entries = entry_keys.map { |key| $redis.get(key) } # get all the values
    @post = entries.map { |entry| JSON.parse(entry) }
    # convert json into array of hashes
    render(:erb, :"topics/new")
  end

  post('/new_topic') do
    @timestamp = Time.new
    index = $redis.incr('entries:counter')
    entry = params
    $redis.set("entry:#{index}", entry.to_json)
    render(:erb, :"topics/new")
  end

  post('/leave_comment') do
    @timestamp = Time.new
    topic = $redis.get("entry:#{params['topic_id']}")
    parsed_topic = JSON.parse(topic)
    message = { 'user' => params['user'], 'body' => params['body'] }
    parsed_topic['messages'] << message
    $redis.set("entry:#{params['topic_id']}", parsed_topic.to_json)
    redirect to('/entries')
  end

  get('/leave_comment') do
  end

  post('/topic/') do
    $redis.set('entries:counter', 0)
    entries_data.each do |entry|
    index = $redis.incr('entries:counter')
    entry['id'] = index
    $redis.set("entry:#{index}", entry.to_json)
    end
    redirect('/leave_comment')
  end

  get('/topic/') do
    render(:erb, :'topics/show')
  end

  get('/topic/:id') do
    id = params[:id]
    @entry = JSON.parse($redis.get("entry:#{id}"))
    render(:erb, :'topics/show')
  end

end


