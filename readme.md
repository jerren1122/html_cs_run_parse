# **HTML CS RUN PARSE**

this repo serves the purpose of updating the html_cs_run_parse gem out on RubyGems

this gem houses both the ability to run HTML Code Sniffer and Watir and includes a parsing tool to turn that into a report. 

# **How to update HTMLCS.JS that is being utilized in the Ruby Gem** 

1. Pull HTMLCS Down from github(URL: https://github.com/squizlabs/HTML_CodeSniffer), place repo in html_cs directory, Build HTMLCS Utilizing grunt see instructions in the URL Above.
2. Alter the line of code in the built HTMLCS.js(in the build directory of HTML CS)
from -  console.log("[HTMLCS] "+t+"|"+e.code+"|"+n+"|"+i+"|"+e.msg+"|"+o)}};
to -  console.error("[HTMLCS] "+t+"|"+e.code+"|"+n+"|"+i+"|"+e.msg+"|"+o)}}; 
3. Run the js file in the build directory as instructed in the instructions from the url above (this occurs in html_cs.rb)
  --Note on the Wati side I have to scrape the driver after running html_cs as this is where the output occurs. without the changes in step 2 I would not be able to retrieve this information. 
4. Place the new built HTMLCS.JS file in the lib directory along with the license.txt
5. Update the gem with the steps below

# **How to update the Gem**  
1. If there are any new files in the repo that need pushed to the gem be sure to add them to the gemspec file list
2. Build the Gem with the new file "gem build html_cs_run_parse" -be sure to increment the gemfile in the gemspec. 
3. Push the gem up to RubyGems "gem push html_cs_run_parse-0.0.1.gem" -note the file version will change

# **run_html_cs** 
Execution: HTMLCS.run_html_cs(browser, file_name) 

The browser should be a watir browser and the file_name should be where you want the generated CSV Stored. 

this method will save a screenshot of the scanned page, the url in a text file and the csv as well. 

The parsed HTML Code Sniffer Scans are transported via a CSV File
The naming conventions of the CSV is: 
google_search_qa1.csv
{app_name}_{page_name}_{env}.csv

URL's are transported by a seperate .txt file: 
The naming convention of the text file is: 
google_search_qa1.txt
{app_name}_{page_name}_{env}.txt

Images are transported by a seperate .png file: 
The naming convention of the text file is: 
google_search_qa1.png
{app_name}_{page_name}_{env}.png


# **compile_html_cs**
Execution: HTMLCS.compile_html_cs(data_location)
the data_location should be the relative location from the caller of the data location both where the HTMLCS input is as well as where the output will go from this framework.
Currently this framework expects the following data structure within this directory
an input and output directory and within the output directory a files directory. 
 
Input should house the information that was generated via run_html_cs the output and files(within output) directory should both be empty. 

the data_location should also house in its root the graph_scores.yaml, scores.yaml and the suppressed_rules.yaml. Examples of these exist in this repo.  



# **Limitations:** 

1. Need to ensure that HTMLCS is updated as needed
2. Each time a new version of HTMLCS is pulled down we have to modify the source code. 


