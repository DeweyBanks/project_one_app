require 'redis'
require 'json'
require 'pry'
require 'uri'

uri = URI.parse(ENV["REDISTOGO_URL"])
$redis = Redis.new({:host => uri.host,
                    :port => uri.port,
                    :password => uri.password})

$redis.flushdb


 forum_data = [
      {
        "topic" => "Should Tony Stewart Race?",
        "Post" => "I don't think he should. He should sit out for a season.",
        "comment" => "I agree with you. lol!",
        "views" => 0,
        "user" => "DeweyB"
      }
  ]




forum_data.each_with_index do | entry, index|
  $redis.set("entry:#{index + 1}", entry.to_json)
end
binding.pry
