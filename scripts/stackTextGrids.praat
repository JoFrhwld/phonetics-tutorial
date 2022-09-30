# This scripts takes the autovot and manually checked TextGrids and merges them on two different tiers
# This script will create the TextGrid to be used for measuring AutoVOT reliability
# Must run resetBoundaries_stacked.praat after to replace automatic boundaries with the manual ones
# Created 4-2-15 Eleanor Chodroff
# Updated 4-6-15 Eleanor Chodroff

dir$ = "/Users/myname/mytextgrids"

Create Strings as file list... list_auto 'dir$'/*_stops.TextGrid
Sort
n = Get number of strings
Create Strings as file list... list_ch 'dir$'/*_autovot.TextGrid
Sort
Create Strings as file list... list_man 'dir$'/*_check.TextGrid
Sort

for i from 1 to n
	select Strings list_man
	file_man$ = Get string... i
	Read from file... 'dir$'/'file_man$'
	Rename... file_man

	select Strings list_ch
	file_ch$ = Get string... i
	Read from file... 'dir$'/'file_ch$'
	Rename... file_ch

	select Strings list_auto
	file_auto$ = Get string... i
	Read from file... 'dir$'/'file_auto$'
	Rename... file_auto
	file$ = file_auto$ - "_stops.TextGrid"
	Extract one tier... 2
	Down to Table... no 6 no no

	select TextGrid file_man
	Extract one tier... 3
	select TextGrid file_ch
	Extract one tier... 4

	select TextGrid file_auto
	plus TextGrid vot
	plus TextGrid AutoVOT
	Merge
	#pause

	Write to text file... 'dir$'/'file$'_stacked.TextGrid
	select all
	minus Strings list_man
	minus Strings list_ch
	minus Strings list_auto
	Remove
endfor