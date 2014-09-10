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

  $redis.set(:messages => params["body"])

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


@display_all_topics = @posts.each do |post|
                       post["topic"]
                      end



<div id="topic_heading">
  <h3><%= TOPICS[0] %></h3>
  <%= "posted by #{@posts[0]["user"]}  #{@timestamp}"  %>
  <form action="/entries">
    <input type="submit" value="Leave a comment">
  </form>

  <div id="messages">
    <%= MESSAGES[0][0]["user"] %><br>
    <%= MESSAGES[0][0]["body"] %>
  </div>

  <div id="messages">
     <%= MESSAGES[0][1]["user"] %><br>
     <%= MESSAGES[0][1]["body"] %>
  </div>
</div>

<div id="topic_heading">
  <h3><%= TOPICS[1] %></h3>
  <%= "posted by #{@posts[0]["user"]}  #{@timestamp}"  %>
  <form action="/entries">
    <input type="submit" value="Leave a comment">
  </form>

  <div id="messages">
    <%= MESSAGES[1][0]["user"] %><br>
    <%= MESSAGES[1][0]["body"] %>
  </div>

  <div id="messages">
     <%= MESSAGES[1][1]["user"] %><br>
     <%= MESSAGES[1][1]["body"] %>
  </div>
</div>


  <p>hardcodes</p>
  <div id="messages">
    <%= MESSAGES[0][0]["user"] %><br>
    <%= MESSAGES[0][0]["body"] %>
  </div>

  <div id="messages">
     <%= MESSAGES[0][1]["user"] %><br>
     <%= MESSAGES[0][1]["body"] %>
  </div>
</div>



#used on topic.erb

 <% post["messages"].each do |message| %>
    <%= render(:erb, :post, :locals => {:message => message})%>
  <% end %>

  <div id="topic_heading">
<% @posts.each do |post| %>
<%= render(:erb, :topic, :locals => {:post => post}) %>
<% end %>
</div>


<form action="/leave_comment">
    <input type="submit" value="Leave a comment">
  </form>
