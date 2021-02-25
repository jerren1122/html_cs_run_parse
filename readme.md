**HTML CS RUN PARSE**

this repo serves the purpose of updating the html_cs_run_parse gem out on RubyGems

**Updating the RubyGem**

How to update HTMLCS.JS that is being utilized in the Ruby Gem
1. Pull HTMLCS Down from github(URL: https://github.com/squizlabs/HTML_CodeSniffer), place repo in html_cs directory, Build HTMLCS Utilizing grunt see instructions in the URL Above.
2. Alter the line of code in the built HTMLCS.js(in the build directory of HTML CS)
from -  console.log("[HTMLCS] "+t+"|"+e.code+"|"+n+"|"+i+"|"+e.msg+"|"+o)}};
to -  console.error("[HTMLCS] "+t+"|"+e.code+"|"+n+"|"+i+"|"+e.msg+"|"+o)}}; 
3. Run the js file in the build directory as instructed in the instructions from the url above (this occurs in html_cs.rb)
  --Note on the Wati side I have to scrape the driver after running html_cs as this is where the output occurs. without the changes in step 2 I would not be able to retrieve this information. 
4. Place the new built HTMLCS.JS file in the lib directory along with the license.txt
5. Build the Gem with the new file "gem build html_cs_run_parse"
6. Push the gem up to RubyGems "gem push html_cs_run_parse-0.0.1.gem" -note the file version will change


**Additional Info**

4. How to run both errors and warnings
-Errors and warning are ran by default. 
5. Parse from Console Output to CSV-This occurs in utility/parse_machine.rb

**Limitations:** 

1. Need to ensure that HTMLCS is updated as needed
2. Each time a new version of HTMLCS is pulled down we have to modify the source code. 
