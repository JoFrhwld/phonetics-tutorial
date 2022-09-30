# Created 8 Feb 2016 E. Chodroff 

dir$ = "/Volumes/MIXER6_cogsci/CzechNijmegen/alignment/tri1_ali_utf8"
dir2$ = "/Volumes/MIXER6_cogsci/CzechNijmegen/wavfiles"

word_ali$ = "word_alignment"
Read Table from tab-separated file... 'dir$'/'word_ali$'.txt
nRows = Get number of rows
col_file$ = Get column label... 1
col_start$ = Get column label... 3
col_end$ = Get column label... 4
col_word$ = Get column label... 2

file1$ = Get value... 1 'col_file$'
Open long sound file... 'dir2$'/'file1$'.wav
To TextGrid... "word"

for i from 1 to nRows
	select Table 'word_ali$'
	# open new sound file if necessary
	## compare filename from current row to previous row
	if i = 1
		file2$ = Get value... i 'col_file$'
	else
		file1$ = Get value... i-1 'col_file$'
		file2$ = Get value... i 'col_file$'
	endif
	## if filenames are not the same, open new sound file
	if file2$ != file1$
		select TextGrid 'file1$'
		Save as text file... 'dir$'/'file1$'_word.TextGrid
		#pause just saved textgrid
		select LongSound 'file1$'
		plus TextGrid 'file1$'
		Remove
		Open long sound file... 'dir2$'/'file2$'.wav
		To TextGrid... "word"
	endif

	# start marking textgrid
	select Table 'word_ali$'
	start = Get value... i 'col_start$'
	end = Get value... i 'col_end$'
	word$ = Get value... i 'col_word$'

	## get start time of next word in case you need to mark the end time of current
	if i < nRows
		startnextword = Get value... i+1 'col_start$'
	endif

	select TextGrid 'file2$'
	int = Get interval at time... 1 start+0.005

	## if you're at the end of a file, mark the end of the last word
	if start > 0 & startnextword = 0
		Insert boundary... 1 start
		Set interval text... 1 int+1 'word$'
		Insert boundary... 1 end
	## if the start time of the next word does not equal end of current, mark end of current
	elsif start > 0 & end != startnextword
		Insert boundary... 1 start
		Set interval text... 1 int+1 'word$'
		Insert boundary... 1 end
	## if end time of current word equals the start time of next, do not mark end of current
	elsif start > 0 & end = startnextword
		Insert boundary... 1 start
		Set interval text... 1 int+1 'word$'
	## if start = 0, do not add a boundary otherwise praat will throw an error
	elsif start = 0 & end != startnextword
		Set interval text... 1 int 'phone$'
		Insert boundary... 1 end
	elsif start = 0 & end = startnextword
		Set interval text... 1 int 'word$'
	endif	
	#pause
endfor
Save as text file... 'dir$'/'file2$'_word.TextGrid
select LongSound 'file2$'
plus TextGrid 'file2$'
Remove

