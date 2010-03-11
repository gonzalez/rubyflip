#!/usr/bin/ruby 
# parse the rss feed and create the screenshots
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

#test rss feed for RubyInside

feed="http://feeds.feedburner.com/RubyInside"
content=""
open(feed) do |f| content = f.read end

rss = RSS::Parser.parse(content, false)



#print "RSS title: ", rss.channel.title, "\n"
#print "RSS link: ", rss.channel.link, "\n"
#print "RSS description: ", rss.channel.description, "\n"
#print "RSS publication date: ", rss.channel.date, "\n"

rsscount = 0

while rsscount < rss.items.size

	print "title: ", rss.items[rsscount].title, "\n"
	print "link: ", rss.items[rsscount].link, "\n\n"
	
	rsscount += 1

end



