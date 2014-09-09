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
    "topic"    => "Should Tony Stewart Race?",
    "user"     => "DeweyB",
    "messages" => [
        { "user" => "DeweybB",
          "body" => "I don't think he should. He should sit out for a season."
        },
        {
          "user" => "slydog84",
          "body" => "I think he deserves a chance"
        }
    ]
  },
  {
    "topic"    => "Does Jr stand a chance?",
    "user"     => "Slydog84",
    "messages" => [
        {
          "user" => "phildog81",
          "body" => "I don't think he does. His team has been in la la land."
        },
        {
          "user" => "dogbeachguy",
          "body" => "He is killing it!"
        }
    ]
  }
]


$redis.set("entries:counter", 0)

entries_data.each do |entry|
  index = $redis.incr("entries:counter")
  entry["id"] = index
  $redis.set("entry:#{index}", entry.to_json)
end

