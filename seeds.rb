require 'redis'
require 'json'
require 'pry'
require 'uri'

uri = URI.parse(ENV["REDISTOGO_URL"])
$redis = Redis.new({:host => uri.host,
                    :port => uri.port,
                    :password => uri.password})

$redis.flushdb

$redis.set("entry:","")

    entry_data = [
      {
        "topic"   => "Should Tony Stewart Race?",
        "post"    => "I don't think he should. He should sit out for a season.",
      },
      {
        "topic"   => "Does Jr stand a chance?",
        "post"    => "I don't think he does. His team has been in la la land.",
      }
  ]

#trying to different ways, seeing which one works
entry_data.each do |entry|
  index = $redis.incr("entry:")
  entry[:id] = index
  $redis.set("entry:#{index}", entry.to_json)
end



# entry.each_with_index do | entry, index|
#   $redis.set("entry:#{index + 1}", entry.to_json)
# end
binding.pry
