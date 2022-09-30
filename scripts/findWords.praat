# This script creates a text file of start and end times for words of interest (wordfile) in a session.
# It also records the preceding and following words. 
# The output file can then be used to locate these words in a textgrid

# You will need to modify the paths and a few parts of this script (mainly at the top) manually.

# Created 11-8-14 Eleanor Chodroff
# Updated 3-27-18

# file suffix of wav and label files
dir$ = "/Users/Eleanor/Dropbox/Corpora/allsstar/English/hint1"
wordfile$ = "/Users/Eleanor/Dropbox/Corpora/allsstar/English/hint1/wordList.txt"
outfile$ = "/Users/Eleanor/Desktop/CVWordLocations.txt"

fileappend 'outfile$' filename'tab$'start'tab$'end'tab$'stim'tab$'before'tab$'after'newline$'

Read Strings from raw text file... 'wordfile$'
Rename... words
To WordList

# the TextGrids are embedded in multiple directories
# if all TextGrids are in a single directory, 
# then comment out nDir = Get number of strings
# and create a new line that says nDir = 1

Create Strings as directory list... folders 'dir$'/talker*
nDir = Get number of strings

# loop through subdirectories
for d from 1 to nDir
	select Strings folders
	subdir$ = Get string... 'd'

	# loop through TextGrid files within a subdirectory
	Create Strings as file list... textgrids 'dir$'/'subdir$'/*.TextGrid
	nFiles = Get number of strings
	for i from 1 to nFiles

		# loop through words within a TextGrids
		call loopTextGrid 'i' 'subdir$'

	endfor
	select Strings textgrids
	Remove
endfor

procedure loopTextGrid i subdir$
	select Strings textgrids
	filename$ = Get string... 'i'
	basename$ = filename$ - ".TextGrid"
	Read from file... 'dir$'/'subdir$'/'basename$'.TextGrid
	select TextGrid 'basename$'

	# extract word tier (tier 2)
	Extract one tier... 2
	Rename... word
	select TextGrid word

	# convert to table object
	Down to Table... yes 6 0 'include_empty_intervals'
	Rename... file
	nLines = Get number of rows
	for j from 1 to nLines
		call findWords 'j'
	endfor
	select TextGrid 'basename$'
	plus TextGrid word
	plus Table file
	Remove
endproc

procedure findWords j
	select Table file
	wordInTranscript$ = Get value... j text

	# check to see if the word is in the stop-initial word list
	select WordList words
	match = Has word... 'wordInTranscript$'
	#pause 'wordInTranscript$''tab$''match''newline$'

	# match can equal 0 or 1
	# if the word in the transcript is in the word list (match = 1)
	# then get it's start and end times as well as the text before and after its appearance
	if match = 1
		select Table file
		start = Get value... j tmin
		end = Get value... j tmax
		if j = nLines
			after = j
		else
			after = j+1
		endif
		if j = 1
			before = j
		else
			before = j-1
		endif
		before$ = Get value... before text
		after$ = Get value... after text
		fileappend 'outfile$' 'basename$''tab$''start''tab$''end''tab$''wordInTranscript$''tab$''before$''tab$''after$''newline$'
	endif
endproc