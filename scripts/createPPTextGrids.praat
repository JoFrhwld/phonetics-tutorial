# Create TextGrid for ProsodyPro that has one tier with an interval for
# the preamble (starting at end of 0.02 s added silence) and an interval for
# the nucleus (proper name). The TextGrids from which these are derived were force-aligned
# with FAVE and then manually adjusted, with particular attention given to the onset and
# offset of the nucleus and the onset of the preamble.

dir$ = "/Users/Eleanor/Dropbox/NuclearTunes/IntonationProduction/data/extracts/male_50_300"
Create Strings as file list... files 'dir$'/*.TextGrid
Sort
nFiles = Get number of strings
wordsTier = 3

for i from 1 to nFiles
	select Strings files
	filename$ = Get string... i
	basename$ = filename$ - ".TextGrid"
	Read from file... 'dir$'/'basename$'.TextGrid
	Extract one tier... wordsTier
	nInt = Get number of intervals... 1
	select TextGrid words
	for j from 1 to nInt
		label$ = Get label of interval... 1 j
		if index_regex(label$, "(MEL|NEL|HAR|HERM|MAD)+")
			start = Get starting point... 1 j
			#end = Get end point... 1 j
			name$ = label$
		endif
	endfor
	Insert interval tier... 1 interval
	Insert boundary... 1 start
	#Insert boundary... 1 end
	Set interval text... 1 2 'name$'
	Remove tier... 2
	Set interval text... 1 1 preamble
	Save as text file... 'dir$'/'basename$'.TextGrid
	select all
	minus Strings files
	Remove
endfor
			
		
	
