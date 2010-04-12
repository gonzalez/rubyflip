#!/usr/bin/ruby 
# parse the rss feed and create the screenshots
require 'rubygems'
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'fileutils'
require 'net/ftp' 
require 'RMagick'
include Magick

rssfeeds = ['http://z.about.com/6/o/m/ruby_p2.xml']
#rssfeeds = ["http://feeds2.feedburner.com/Rubyflow"]
#rssfeeds = ["http://news.ycombinator.com/rss"]
#rssfeeds = [ "http://feeds.feedburner.com/RubyInside"]
#rssfeeds = [ "http://feeds.feedburner.com/ElcCodeFeed"]


#mkdir to store our screenshots
time = Time.now
dir = time.strftime("%Y%m%d%H%M%S")
FileUtils.mkdir_p "#{dir}"
#FileUtils.mkdir_p "#{dir}/thumbs"
index = File.open("index.#{dir}", "w")


#start index
index.puts("

<!DOCTYPE html PUBLIC \"-\/\/W3C\/\/DTD HTML 4.01\/\/EN\"
   \"http:\/\/www\.w3\.org\/TR\/html4\/strict.dtd\">

<html lang=\"en\">
<head>
	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
	<title>RubyFlip</title>


<link rel=\"stylesheet\" type=\"text/css\" href=\"javascript/slideshow/css/slideshow.css\" media=\"screen\" />
	<script type=\"text/javascript\" src=\"javascript/slideshow/js/mootools.js\"></script>
	<script type=\"text/javascript\" src=\"javascript/slideshow/js/slideshow.js\"></script>

	<script type=\"text/javascript\">		
	//<![CDATA[
	  window.addEvent(\'domready\', function(){
	    var data = {
")

#parse through list of feeds.
for i in rssfeeds
  
       content=""
       #read in the contents of that feed
       open(i) do |f| content = f.read end
      
       #parse the contents of that feed, 
       rss = RSS::Parser.parse(content, false)
       
       #feed item counter
       rsscount = 0
       
      #iterate through the urls
      while rsscount < rss.items.size
      
      url = rss.items[rsscount].link
 
      
      #generate screenshot using webkit2png ("http://www.paulhammond.org/webkit2png/")
      system("./webkit2png.py -o #{rsscount} -H 600 -W 950 -D #{dir} -F #{url}")
     
      #crop the screenshot , imagemagick
      image=Image.read("#{dir}/#{rsscount}.png").first
     
      #(x,y,height,width)
      face=image.crop!(0,0,960,600)
      face.write("#{dir}/#{rsscount}.png")
         
      #generate js 
      index.puts("\'#{rsscount}" + ".png\':" + " \{ caption: \'" + rss.items[rsscount].title + "\'\, href: \'" + rss.items[rsscount].link + "\'\},") 
     
      rsscount += 1

    end
    
    #need a feed+rss counter feed2.item1
    #rsscount += 1

end

#finalize index

index.puts("  \}\;
    var myShow = new Slideshow(\'show\', data, {loop: false,pause: 0,preload: true,captions: true, fast: 2, height: 600, width: 950,hu: \'images/" + "#{dir}" +"\/'});
  \}\)\;
\/\/\]\]>
<\/script>




  <!-- Framework CSS -->

	<link rel=\"stylesheet\" href=\"css/blueprint/screen.css\" type=\"text/css\" media=\"screen, projection\">
	<link rel=\"stylesheet\" href=\"css/blueprint/print.css\" type=\"text/css\" media=\"print\">
  <!--[if lt IE 8]><link rel=\"stylesheet\" href=\"../../blueprint/ie.css\" type=\"text/css\" media=\"screen, projection\"><![endif]-->

	
	<!-- Import fancy-type + Buttons plugin -->
	<link rel=\"stylesheet\" href=\"css/blueprint/plugins/fancy-type/screen.css\" type=\"text/css\" media=\"screen, projection\">
	<link rel=\"stylesheet\" href=\"css/blueprint/plugins/buttons/screen.css\" type=\"text/css\" media=\"screen, projection\">
</head>

<body>

<div class=\"container\">  

		<div class=\"span-24 header\">

			<h1 class=\"loud\">RubyFlip</h1>
			<hr>
			<h2 class=\"alt\">Flip through ruby news items using your arrows.</h2>
			<hr>
		</div>
		
	
			<div class=\"span-24 slideshow box\" id=\"show\">
				
				  <img src=\"images/" +  "#{dir}" + "/0.png\"  height=\"600\" width=\"960\" border=\"0\"/>
				
				 
				</div>


		
<div class=\"span-24 footer prepend-top\">
	<div class=\"spam-24\">
		
		<a href=\"/about.html\">About</a> | <a href=\"http://twitter.com/rubyflip\">Twitter</a>
	</div>
</div>


</div>

</body>
</html>

")








#index page closed
index.close


#FTP the goods index + images

#ftp = Net::FTP.new("yourhost.com","username", "password")
ftp.passive = true
ftp.chdir("www")
ftp.putbinaryfile("index.#{dir}","index.html")
ftp.chdir("images")
#make dir
ftp.mkdir("#{dir}")
ftp.chdir("#{dir}")
files = Dir.glob("#{dir}/*.png")

for i in files 
  ftp.putbinaryfile("#{i}")
  puts "uploading #{i}"
end

#chdir 
#upload each png
ftp.close

#for local testing
#FileUtils.mv("#{dir}", "public/images/#{dir}")
#FileUtils.mv("index.#{dir}", "public/index.html")