# This scripts takes the autovot and manually checked TextGrids and merges them on two different tiers
# Must run resetBoundaries.praat after to replace automatic boundaries with the manual ones
# Created 2-19-15 Eleanor Chodroff

dir$ = "/Volumes/MIXER6_cogsci/ServerFiles/rdtr/threeSessSubj"

Create Strings as file list... list_auto 'dir$'/*_autovot.TextGrid
n = Get number of strings
Create Strings as file list... list_man 'dir$'/*_check.TextGrid

for i from 1 to n
	select Strings list_auto
	file_auto$ = Get string... i
	Read from file... 'dir$'/'file_auto$'
	Rename... file_auto
	file$ = file_auto$ - "_autovot.TextGrid"
	Read from file... 'dir$'/'file$'.wav
	Read from file... 'dir$'/00vot/'file$'_1.wav
	Rename... firsthalf
	firstdur = Get total duration
	firstdur = firstdur + 0.001
	#pause 'firstdur'
	select TextGrid file_auto
	midInt_pred = Get interval at time... 4 firstdur
	Remove left boundary... 4 midInt_pred
	midInt_phone = Get interval at time... 1 firstdur
	midInt_phone = midInt_phone-1
	phone$ = Get label of interval... 1 midInt_phone
	Remove right boundary... 1 midInt_phone
	Set interval text... 1 midInt_phone 'phone$'
	midInt_word = Get interval at time... 2 firstdur
	midInt_word = midInt_word-1
	#pause 'midInt_word'
	word$ = Get label of interval... 2 midInt_word
	Remove right boundary... 2 midInt_word
	Set interval text... 2 midInt_word 'word$'
	Remove tier... 3
	select Strings list_man
	file_man$ = Get string... i
	Read from file... 'dir$'/'file_man$'
	Rename... file_man
	Extract one tier... 3
	select TextGrid file_auto
	plus TextGrid vot
	Merge
	#pause
	Write to text file... 'dir$'/'file$'_merged.TextGrid
	select TextGrid file_auto
	plus TextGrid file_man
	plus TextGrid vot
	plus TextGrid merged
	plus Sound 'file$'
	plus Sound firsthalf
	Remove
endfor