# This script resets the automatic AutoVOT boundaries with the manually placed boundaries.
# Must run stackTextGrids.praat before
# Created 4-2-2015 Eleanor Chodroff
# Updated 4-6-2015 Eleanor Chodroff

dir$ = "/Volumes/MIXER6_cogsci/ServerFiles/rdtr/threeSessSubj"

Create Strings as file list... files 'dir$'/*_stacked.TextGrid
Sort
select Strings files
nFiles = Get number of strings
#pause

for i from 1 to nFiles
	select Strings files
	file$ = Get string... i
	Read from file... 'dir$'/'file$'
	file$ = file$ - "_stacked.TextGrid"
	Rename... file
	nInt_man = Get number of intervals... 4
	for j from 1 to nInt_man
		text$ = Get label of interval... 4 j
		if index_regex(text$, "^(man)$") or index_regex(text$, "^(man_v)$")
			left_bound = Get start point... 4 j
			right_bound = Get end point... 4 j
			Set interval text... 3 j
			Remove right boundary... 3 j
			Remove left boundary... 3 j
			Insert boundary... 3 left_bound
			Insert boundary... 3 right_bound
			Set interval text... 3 j 'text$'
		endif
	endfor
	nInt_ch = Get number of intervals... 5
	#pause 'nInt_ch' 'nInt_man'
	for k from 1 to nInt_ch
		text$ = Get label of interval... 5 k
		if index_regex(text$, "^(ch)$") or index_regex(text$, "^(ch_v)$")
			left_bound = Get start point... 5 k
			right_bound = Get end point... 5 k
			Set interval text... 3 k
			#pause 'k'
			Remove right boundary... 3 k
			Remove left boundary... 3 k
			Insert boundary... 3 left_bound
			Insert boundary... 3 right_bound
			Set interval text... 3 k 'text$'
		endif
	endfor
	Remove tier... 5
	Remove tier... 4
	#pause
	select TextGrid file
	Save as text file... 'dir$'/'file$'_stacked2.TextGrid
	Remove
endfor
