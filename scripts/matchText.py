#  matchText.py
#  
#
#  Created by Eleanor Chodroff on 3/27/18
#
import csv,fnmatch,re
words=[]
results=[]
myfile = open("transcript.txt", 'r')
for word in myfile:
	word = word.rstrip('\n')
	words.append(word,)
print words
	
f = open("/Users/Eleanor/Dropbox/MatchWords/dict.txt", 'r')
for line in f:
    columns=line.split("  ")
    if columns[0] in words:
    	match = re.search('[A-Z]+  [PTKBDG] [AIEOUY]+ *', line)
    	if match:
    		results.append(columns[0],)
uniqueResults = set(results)
uniqueResults = list(uniqueResults)
uniqueResults.sort()

try:
    with open("wordList.txt",'w') as fwrite:
        writer = csv.writer(fwrite, delimiter="\n")
        writer.writerows([uniqueResults])
        fwrite.close()
except Exception, e:
    print "Failed to write file",e
    sys.exit(2)
