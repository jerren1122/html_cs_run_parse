More to come I just wanted to include this as to how the inputs get into the application. 

The pa11y command to run to extract the pa11y info is: 
pa11y -r csv www.google.com > ./google_search_qa1.csv
pa11y -r csv www.google.com > ./{app_name}_{page_name}_{env}.csv

This information can also be extracted from HTML Code Sniffer the html_cs directory has a readme that explains this.

URL's are transported by a seperate .txt file: 
The naming convention of the text file is: 
./google_search_qa1.txt
./{app_name}_{page_name}_{env}.txt

Images are transported by a seperate .png file: 
The naming convention of the text file is: 
./google_search_qa1.png
./{app_name}_{page_name}_{env}.txt

