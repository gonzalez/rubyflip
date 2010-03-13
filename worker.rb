#!/usr/bin/ruby 
# parse the rss feed and create the screenshots
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'fileutils'


rssfeeds = [ "http://feeds.feedburner.com/RubyInside", "http://feeds.feedburner.com/ElcCodeFeed"]


#mkdir to store our screenshots
time = Time.now
dir = time.strftime("%Y%m%d%H%M%S")
FileUtils.mkdir_p "#{dir}/full"
FileUtils.mkdir_p "#{dir}/thumbs"


for i in rssfeeds
  
      
       content=""
       open(i) do |f| content = f.read end

       rss = RSS::Parser.parse(content, false)


    rsscount = 0

    while rsscount < rss.items.size
      
      #replace with webkit2png 
    	print "creating a screenshot of . . . ", rss.items[rsscount].link, "\n\n"
    
     	rsscount += 1

    end

  
end




