# move textgrid boundaries as specified in table
dir$ = "/Users/Eleanor/myCorpus/finalProduct"
Create Strings as file list... list 'dir$'/*.csv
Sort
nFiles = Get number of strings
for ifile from 1 to nFiles
	select Strings list
	filename$ = Get string... 'ifile'
	basename$ = filename$ - ".csv"
	call markTextGrid 'basename$'
endfor

procedure markTextGrid basename$
	#pause 'basename$'
	Read from file... 'dir$'/'basename$'.wav
	Read Table from comma-separated file... 'dir$'/'basename$'.csv
	
	select Sound 'basename$'
	To TextGrid... "phone word"
	select Table 'basename$'
	nRows = Get number of rows
	#pause
	for i from 1 to nRows
		select Table 'basename$'
		tmin = Get value... i tmin
		tier$ = Get value... i tier
		text$ = Get value... i text
		select TextGrid 'basename$'
		if index_regex(tier$, "phone")
			Insert boundary... 1 tmin
			j = Get interval at time... 1 tmin+0.0001
			Set interval text... 1 j 'text$'
		else
			Insert boundary... 2 tmin
			j = Get interval at time... 2 tmin+0.0001
			Set interval text... 2 j 'text$'
		endif
	endfor
	select TextGrid 'basename$'
	Write to text file... 'dir$'/'basename$'.TextGrid
	select TextGrid 'basename$'
	plus Sound 'basename$'
	plus Table 'basename$'
	Remove
endproc