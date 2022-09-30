# This script does the following:
#	Measures the VOT of the automatically/manually aligned boundaries
#	Gets the label of the stop, word, and vowel
#	Gets the vowel duration
#	Gets the speaking rate (avg word dur per utterance)
#	Gets the pitch listing for the first 50ms of the vowel at 10ms intervals
# Input: merged (autovot w/correction) TextGrid and wav files
# April 2, 2015 Eleanor Chodroff
# Last run: April 6

dir$ = "/Volumes/MIXER6_cogsci/ServerFiles/rdtr/threeSessSubj"
outputfile$ = "/Volumes/MIXER6_cogsci/Workspace/analyze_cogsci/00autovot/cueAnalysis_new.txt"

Create Strings as file list... files 'dir$'/*.wav
Sort
nFiles = Get number of strings
#pause 'nFiles'
deleteFile(outputfile$)

for i from 1 to nFiles
	select Strings files
	filename$ = Get string... i
	#pause 'filename$'
	basename$ = filename$ - ".wav"
	Read from file... 'dir$'/'basename$'.wav
	To Pitch... 0.0 60 650
	Read from file... 'dir$'/'basename$'_stacked2.TextGrid
	select TextGrid 'basename$'_stacked2
	phonetier = Get number of intervals... 1
	wordtier = Get number of intervals... 2
	Extract one tier... 3
	Down to Table... no 6 yes no
	select Table autovot
	nRows = Get number of rows
	for j from 1 to nRows
		select Table autovot
		start = Get value... j tmin
		stop$ = Get value... j text
		end = Get value... j tmax
		vot = end - start
		fileappend 'outputfile$' 'basename$''tab$''stop$''tab$''start''tab$''end''tab$''j''tab$''vot'
		call getStop 'basename$' 'start' 'phonetier' 'stop$'
		call speakingRate 'basename$' 'start' 'wordtier'
		fileappend 'outputfile$' 'newline$'
	endfor
	#pause
	select Sound 'basename$'
	plus Pitch 'basename$'
	plus TextGrid 'basename$'_stacked2
	plus TextGrid autovot
	plus Table autovot
	Remove
endfor

procedure getStop basename$ start phonetier stop$
	select TextGrid 'basename$'_stacked2
	stopInt = Get interval at time... 1 start
	hyp_stop$ = Get label of interval... 1 stopInt
	if index_regex(stop$, "^(man)") or index_regex(stop$, "^(man_v)")
		stop$ = hyp_stop$
	endif
	if hyp_stop$ != stop$
		stopInt = stopInt-1
		hyp_stop$ = Get label of interval... 1 stopInt
		if hyp_stop$ != stop$
			stopInt = stopInt-2
			hyp_stop$ = Get label of interval... 1 stopInt
			if hyp_stop$ != stop$ and stopInt+3 <= phonetier
				stopInt = stopInt+3
				hyp_stop$ = Get label of interval... 1 stopInt
				if hyp_stop$ != stop$ and stopInt+1 <= phonetier
					stopInt = stopInt+1
					hyp_stop$ = Get label of interval... 1 stopInt
				endif
			endif
		endif
	endif
	v_start = Get start point... 1 stopInt+1
	v_end = Get end point... 1 stopInt+1
	v_dur = v_end - v_start
	int_v = Get interval at time... 1 v_start+0.001
	vowel$ = Get label of interval... 1 int_v
	int_w = Get interval at time... 2 v_start+0.001
	word$ = Get label of interval... 2 int_w
	fileappend 'outputfile$' 'tab$''word$''tab$''hyp_stop$''tab$''vowel$''tab$''v_dur'
	call getPitch 'basename$' 'v_start'
endproc

procedure speakingRate basename$ start wordtier
	select TextGrid 'basename$'_stacked2
	wordInt = Get interval at time... 2 start
	w_start = Get start point... 2 wordInt	
	w_end = Get end point... 2 wordInt
	w_dur = w_end - w_start
	word1$ = Get label of interval... 2 wordInt
	if wordInt = wordtier
		word2$ = "sp"
	else
		word2$ = Get label of interval... 2 wordInt + 1
	endif
	repeat
		if wordInt > 1
			wordInt = wordInt-1
			s_start = Get start point... 2 wordInt
			s_end = Get end point... 2 wordInt
			s_dur = s_end - s_start
			word1$ = Get label of interval... 2 wordInt
			word2$ = Get label of interval... 2 wordInt + 1
		else
			word1$ = "sp"
			word2$ = "sp"
		endif
	until index_regex(word1$, "sp") and index_regex(word2$, "sp") or index_regex(word1$,"sp") and s_dur > 1.0
	sent_begin = Get start point... 2 wordInt + 2
	count_words = 0
	wordInt = wordInt + 1
	repeat
		count_words = count_words + 1
		wordInt = wordInt + 1
		if wordInt = wordtier
			word1$ = "sp"
			word2$ = "sp"
		else
			word1$ = Get label of interval... 2 wordInt
			word2$ = Get label of interval... 2 wordInt + 1
		endif
	until index_regex(word1$, "sp") and index_regex(word2$, "sp")
	sent_end = Get end point... 2 wordInt - 1
	numWords = count_words - 1
	speaking_rate = (sent_end - sent_begin) / numWords
	fileappend 'outputfile$' 'tab$''w_start''tab$''w_end''tab$''w_dur''tab$''sent_begin''tab$''sent_end''tab$''numWords''tab$''speaking_rate'
endproc

procedure getPitch basename$ v_start
	select Pitch 'basename$'
	for p from 1 to 10
		pitch = Get value at time... v_start+p*0.005 Hertz Linear
		fileappend 'outputfile$' 'tab$''pitch'
	endfor
endproc
