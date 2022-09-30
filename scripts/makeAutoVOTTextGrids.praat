# This script creates a new tier 'vot' which contains expanded boundaries
# for all specified stop consonants. The boundaries are added in based on times
# provided in CVWordLocations.txt, which is the output file from findWords.praat.
# Boundaries for the voiceless stops /ptk/ are extended 31 ms away from the midpoint;
# boundaries for the voiced stops /bdg/ are extended 11 ms away from the midpoint.

# You will need to modify the paths and a few parts of this script (mainly at the top) manually.
 
# Created by Eleanor Chodroff on 3-31-15
# Updated 3-27-18

dir$ = "/Users/Eleanor/Dropbox/Corpora/allsstar/English/hint1"
wordfile$ = "CVWordLocations.txt"

Read Table from tab-separated file... 'dir$'/'wordfile$'
Rename... wordfile
nWords = Get number of rows
col1$ = Get column label... 1
col2$ = Get column label... 2
col3$ = Get column label... 3

# the TextGrids are embedded in multiple directories
# if all TextGrids are in a single directory, 
# then comment out nDir = Get number of strings
# and create a new line that says nDir = 1

Create Strings as directory list... folders 'dir$'/talker*
nDir = Get number of strings

for d from 1 to nDir
	select Strings folders
	subdir$ = Get string... d

	Create Strings as file list... list 'dir$'/'subdir$'/*.TextGrid
	nFiles = Get number of strings

	for i from 1 to nFiles
		call loopTextGrid 'i' 'subdir$'
	endfor
	select Strings list
	Remove
endfor

procedure loopTextGrid i subdir$
	select Strings list
	filename$ = Get string... i
	filename$ = filename$ - ".TextGrid"
	Read from file... 'dir$'/'subdir$'/'filename$'.TextGrid
	Rename... 'filename$'_vot
	select TextGrid 'filename$'_vot
	Insert interval tier... 3 vot
	call insertAutoVOT 'filename$'
endproc

procedure insertAutoVOT filename$
	for j from 1 to nWords
		select Table wordfile
		filename2$ = Get value... j 'col1$'
		if filename$ = filename2$
			tmin = Get value... j 'col2$'
			tmax = Get value... j 'col3$'
			select TextGrid 'filename$'_vot
			phoneInt = Get interval at time... 1 tmin+0.001
			phone$ = Get label of interval... 1 phoneInt

			intStart = Get start point... 1 phoneInt
			intEnd = Get end point... 1 phoneInt
			if index_regex(phone$, "[PTK]")
				Insert boundary... 3 intStart-0.031
				Insert boundary... 3 intEnd+0.031
			elsif index_regex(phone$, "[BDG]")
				Insert boundary... 3 intStart-0.011
				Insert boundary... 3 intEnd+0.011
			endif
			newInt = Get interval at time... 3 intStart
		endif
	endfor
	# this part is necessary to ensure that overlapping intervals are not a problem
	# the labels are added after all boundaries have  been specified
	# this is done in case there were instances of overlapping boundaries (hopefully not)
	for k from 1 to nWords
		select Table wordfile
		filename2$ = Get value... k 'col1$'
		if filename$ = filename2$
			tmin = Get value... k 'col2$'
			tmax = Get value... k 'col3$'
			select TextGrid 'filename$'_vot
			phoneInt = Get interval at time... 1 tmin+0.001
			phone$ = Get label of interval... 1 phoneInt
			intStart = Get start point... 1 phoneInt
			intEnd = Get end point... 1 phoneInt
			half = (intEnd - intStart)/2
			intMid = intStart + half
			newInt = Get interval at time... 3 intMid
			Set interval text... 3 newInt 'phone$'
		endif
	endfor
	select TextGrid 'filename$'_vot
	Save as text file... 'dir$'/'subdir$'/'filename$'_vot.TextGrid
	Remove
endproc