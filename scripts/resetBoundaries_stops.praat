# This script moves all AutoVOT boundaries to the same tier
# Created 4-2-2015 Eleanor Chodroff

dir$ = "/Volumes/MIXER6_cogsci/ServerFiles/rdtr/threeSessSubj"

Create Strings as file list... files 'dir$'/*_cleanpfa.TextGrid
Sort
nFiles = Get number of strings

for i from 1 to nFiles
	select Strings files
	file$ = Get string... i
	Read from file... 'dir$'/'file$'
	Rename... cleanpfa
	file$ = file$ - "_cleanpfa.TextGrid"
	Read from file... 'dir$'/'file$'_allauto.TextGrid
	Rename... file
	Remove tier... 3
	Insert interval tier... 3 autovot
	for tier from 4 to 9
		call relabel 'tier'
	endfor
	select TextGrid file
	for t from 4 to 9
		Remove tier... 't'
	endfor
	#pause
	Remove tier... 2
	Remove tier... 1
	select TextGrid cleanpfa
	plus TextGrid file
	Merge
	Save as text file... 'dir$'/'file$'_stops.TextGrid
	select TextGrid cleanpfa
	plus TextGrid file
	plus TextGrid merged
	Remove
endfor

procedure relabel tier
	nInt = Get number of intervals... 'tier'
	for j from 1 to nInt
		text$ = Get label of interval... 'tier' j
		if index_regex(text$, "^[A-Z]$")
			left_bound = Get start point... 'tier' j
			right_bound = Get end point... 'tier' j
			Insert boundary... 3 left_bound
			Insert boundary... 3 right_bound
			int = Get interval at time... 3 left_bound + 0.001
			Set interval text... 3 int 'text$'
		endif
	endfor
endproc