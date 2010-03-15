#!/usr/bin/ruby 
# parse the rss feed and create the screenshots
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'fileutils'


rssfeeds = [ "http://feeds.feedburner.com/RubyInside", "http://feeds.feedburner.com/ElcCodeFeed", "http://news.ycombinator.com/rss"]


#mkdir to store our screenshots
time = Time.now
dir = time.strftime("%Y%m%d%H%M%S")
FileUtils.mkdir_p "#{dir}/full"
#FileUtils.mkdir_p "#{dir}/thumbs"


for i in rssfeeds
  
      
       content=""
       open(i) do |f| content = f.read end

       rss = RSS::Parser.parse(content, false)


    rsscount = 0

    while rsscount < rss.items.size
      
      #replace with webkit2png 
      url = rss.items[rsscount].link
      print "#{url} \n\n"
      system("./webkit2png.py -W 700-H 700 -D #{dir}/full -F #{url}")
      
     
      #generate index + javascript
     	rsscount += 1

    end

  
end
FileUtils.mv("#{dir}", "public/images/#{dir}")



