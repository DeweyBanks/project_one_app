require 'redis'
require 'json'
require 'pry'
require 'uri'

uri = URI.parse(ENV["REDISTOGO_URL"])
$redis = Redis.new({:host => uri.host,
                    :port => uri.port,
                    :password => uri.password})

$redis.flushdb


    entries_data = [
      {
        "topic"   => "Should Tony Stewart Race?",
        "message"    => "I don't think he should. He should sit out for a season.",
      },
      {
        "topic"   => "Does Jr stand a chance?",
        "message"    => "I don't think he does. His team has been in la la land.",
      }
  ]


entries_data.each_with_index do | entry, index|
  $redis.set("entry:#{index + 1}", entry.to_json)
end
binding.pry
