# This script measures both the manually measured and AutoVOT VOTs.
# It searches the edited TextGrids for intervals labeled "man" or "man_v" and corresponding interval from AutoVOT
# This script requires input from the stacked _check, _autovot, _stops files (stackTextGrids.praat)
# 4-2-2015
# Created by Eleanor Chodroff

dir1$ = "/Users/eleanor/Desktop"
dir2$ = "/Volumes/MIXER6_cogsci/ServerFiles/rdtr/threeSessSubj"

outfile$ = "/Users/eleanor/Desktop/manualVOTs.txt"

Create Strings as file list... files 'dir2$'/*_stacked.TextGrid
Rename... file_list
Sort
nRow = Get number of strings
fileappend 'outfile$' file'tab$'int'tab$'word'tab$'text_man'tab$'start'tab$'end'tab$'vot_man'tab$'text_auto'tab$'start_auto'tab$'end_auto'tab$'vot_auto'newline$'

for i from 1 to nRow
	select Strings file_list
	file$ = Get string... i
	file$ = file$ - ".TextGrid"
	Read from file... 'dir2$'/'file$'.TextGrid
	Rename... file
	nInt = Get number of intervals... 4
	for j from 1 to nInt
		text_man$ = Get label of interval... 4 j
		if index_regex(text_man$, "^(man)") or index_regex(text_man$, "^(man_v)")
			start = Get start point... 4 j
			end = Get end point... 4 j
			vot_man = end-start
			stop$ = Get label of interval... 3 j
			start_auto = Get start point... 3 j
			end_auto = Get end point... 3 j
			vot_auto = end_auto-start_auto
			wordInt = Get interval at time... 2 end_auto
			word$ = Get label of interval... 2 wordInt
			fileappend 'outfile$' 'file$''tab$''j''tab$''word$''tab$''text_man$''tab$''start''tab$''end''tab$''vot_man''tab$''stop$''tab$''start_auto''tab$''end_auto''tab$''vot_auto''newline$'
		endif
	endfor
	#pause
	select TextGrid file
	Remove
endfor
