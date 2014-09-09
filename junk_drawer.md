<!--
<% @posts.each do |post| %>
  <% post["messages"].each do |msg| %>
    <%= msg["user"] %> says <%= msg["body"] %>
  <% end %>
<% end %> -->


 def user(entry)
    @posts.each do |post|
    post["messages"].each do |msg|
    words = msg["user"]
    puts words
    end
  end
  end

  @hope = user(@posts).call


  def cleanup(string)
    string = string.delete("?").delete("'").delete(",")
    string.gsub!(" ","-")
    string
  end

  $regis.set(:messages => params["body"])

<div id="topic_heading">
  <h3><%= @posts[0]["topic"] %></h3><br>
  <%= "posted by #{@posts[0]["user"]}  #{@timestamp}"  %>
  <form action="/leave_comment">
    <input type="submit" value="Leave a comment">
  </form>

  <div id="messages">
    <%= "#{@posts[0]["messages"][1]["user"]} -- #{@timestamp}" %><br>
    <%= @posts[0]["messages"][1]["body"] %>
  </div>

  <div id="messages">
    <%= "#{@posts[0]["messages"][0]["user"]} -- #{@timestamp}" %><br>
    <%= @posts[0]["messages"][0]["body"] %>
  </div>
</div>


entry = $redis.keys("*entry*")
old = []

entry.map do |x|
  new = $redis.get(x)
  old << JSON.parse(new)
  end
