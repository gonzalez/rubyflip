#!/usr/bin/ruby 
# parse the rss feed and create the screenshots
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'fileutils'


#rssfeeds = [ "http://feeds.feedburner.com/RubyInside", "http://feeds.feedburner.com/ElcCodeFeed"]
rssfeeds = [ "http://feeds.feedburner.com/ElcCodeFeed"]


#mkdir to store our screenshots
time = Time.now
dir = time.strftime("%Y%m%d%H%M%S")
FileUtils.mkdir_p "#{dir}/full"
FileUtils.mkdir_p "#{dir}/thumbs"
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


for i in rssfeeds
  
      
       content=""
       open(i) do |f| content = f.read end

       rss = RSS::Parser.parse(content, false)


    rsscount = 0

    while rsscount < rss.items.size
      
      url = rss.items[rsscount].link
 
      
      #generate screenshot
      system("./webkit2png.py -o #{rsscount} -H 600 -W 900 -D #{dir}/full -F #{url}")
      
      #generate js 
     index.puts("\'#{rsscount}" + ".png\':" + " \{ caption: \'" + rss.items[rsscount].title + "\'\, href: \'" + rss.items[rsscount].link + "\'\},") 
     
     	rsscount += 1

    end

    rsscount += 1

end

#finalize index

index.puts("  \}\;
    var myShow = new Slideshow(\'show\', data, {preload: true,captions: true, fast: 2, height: 600, width: 950,hu: \'images/" + "#{dir}" +"\/full\'});
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
			<h2 class=\"alt\">Flip through ruby news items using your keyboard arrows.</h2>
			<hr>
		</div>
		
	
			<div class=\"span-24 slideshow box\" id=\"show\">
				
				  <img src=\"images/" +  "#{dir}" + "/full/1.png\"  height=\"600\" width=\"975\" border=\"0\"/>
				
				 
				</div>


		
<div class=\"span-24 footer prepend-top\">
	<div class=\"spam-24\">
		
		<a href=\"/about.html\">About</a> | <a href=\"http://twitter.com/rubyflip\">Twitter</a> | <a  href=\"/why.html\">Why</a> 
	</div>
</div>


</div>

</body>
</html>

")









index.close
FileUtils.mv("#{dir}", "public/images/#{dir}")
FileUtils.mv("index.#{dir}", "public/index.html")






