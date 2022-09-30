# Created 27 March 2015 E. Chodroff 

dir$ = "/Users/Eleanor/mycorpus"

Create Strings as file list... list_txt 'dir$'/*.txt
nFiles = Get number of strings

for i from 1 to nFiles
	select Strings list_txt
	filename$ = Get string... i
	basename$ = filename$ - ".txt"
	txtname$ = filename$ - ".txt"
	Read from file... 'dir$'/'basename$'.wav
	dur = Get total duration
	To TextGrid... "kaldiphone"

	#pause 'txtname$'

	select Strings list_txt
	Read Table from tab-separated file... 'dir$'/'txtname$'.txt
	Rename... times
	nRows = Get number of rows
	Sort rows... start
	for j from 1 to nRows
		select Table times
		startutt_col$ = Get column label... 5
		start_col$ = Get column label... 10
		dur_col$ = Get column label... 6
		phone_col$ = Get column label... 7
		if j < nRows
			startnextutt = Get value... j+1 'startutt_col$'
		else
			startnextutt = 0
		endif
		start = Get value... j 'start_col$'
		phone$ = Get value... j 'phone_col$'
		dur = Get value... j 'dur_col$'
		end = start + dur
		select TextGrid 'basename$'
		int = Get interval at time... 1 start+0.005
		if start > 0 & startnextutt = 0
			Insert boundary... 1 start
			Set interval text... 1 int+1 'phone$'
			Insert boundary... 1 end
		elsif start = 0
			Set interval text... 1 int 'phone$'
		elsif start > 0
			Insert boundary... 1 start
			Set interval text... 1 int+1 'phone$'
		endif
		#pause
	endfor
	#pause
	Write to text file... 'dir$'/'basename$'.TextGrid
	select Table times
	plus Sound 'basename$'
	plus TextGrid 'basename$'
	Remove
endfor