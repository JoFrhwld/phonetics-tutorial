# This script stacks two TextGrids to create one
# Created 2 April 2015 E. Chodroff
# Updated 8 Feb 2016 E. Chodroff

dir$ = "/Volumes/MIXER6_cogsci/CzechNijmegen/alignment/tri1_ali_utf8"

Create Strings as file list... czech 'dir$'/*.TextGrid
Sort
n = Get number of strings

for i from 1 to n
	select Strings czech
	file$ = Get string... i
	base$ = file$ - ".TextGrid"
	
	Read from file... 'dir$'/'base$'.TextGrid
	Rename... file1

	Read from file... 'dir$'/'base$'_word.TextGrid
	Rename... file2
	select TextGrid file1
	plus TextGrid file2
	Merge
	Write to text file... 'dir$'/'base$'_final.TextGrid
	select TextGrid file1
	plus TextGrid file2
	plus TextGrid merged
	Remove
	i = i+1
endfor