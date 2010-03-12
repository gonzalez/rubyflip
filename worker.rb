#!/usr/bin/ruby 
# parse the rss feed and create the screenshots
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'


rssfeeds = [ "http://feeds.feedburner.com/RubyInside", "http://feeds.feedburner.com/ElcCodeFeed"]


#mkdir to store our screenshots
time = Time.now
dir = time.strftime("%Y%m%d%H%M%S")
FileUtils.mkdir_p "#{dir}/full"
FileUtils.mkdir_p "#{dir}/thumbs"

feed = 0
for i in rssfeeds
  
    #  feed="http://feeds.feedburner.com/RubyInside"
       content=""
       open(i) do |f| content = f.read end

       rss = RSS::Parser.parse(content, false)


    rsscount = 0

    while rsscount < rss.items.size
      
      #replace with webkit2png 
    	#print "creating a screenshot of . . . ", rss.items[rsscount].link, "\n\n"
    	put feed.rsscount
     	rsscount += 1

    end
  feed += 1
  
end




