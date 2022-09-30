# This script relabels the AutoVOT tier and changes the label "pred" to the last stop consonant analyzed.
# Must run after each AutoVOT run, assuming separate runs for each stop consonant.
# Created 4-1-2015 Eleanor Chodroff

dir$ = "/Volumes/MIXER6_cogsci/ServerFiles/rdtr/threeSessSubj"

Create Strings as file list... files 'dir$'/*_vot.TextGrid
Sort
nFiles = Get number of strings

phone$ = "G"
tiername$ = "predG"

for i from 1 to nFiles
	select Strings files
	file$ = Get string... i
	Read from file... 'dir$'/'file$'
	file$ = file$ - "_vot.TextGrid"
	Rename... file
	Set tier name... 9 'tiername$'
	nInt = Get number of intervals... 9
	for j from 1 to nInt
		text$ = Get label of interval... 9 j
		if index_regex(text$, "^(pred)$")
			Set interval text... 9 j 'phone$'
		endif
	endfor
	select TextGrid file
	Save as text file... 'dir$'/'file$'_vot.TextGrid
	Remove
endfor
