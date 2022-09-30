dir$ = "/Users/Eleanor/myCorpus/myInput/"
dir2$ = "/Users/Eleanor/myCorpus/myOutput/"

Create Strings as file list... list 'dir$'/*.TextGrid
Sort
nFiles = Get number of strings

for file_i from 1 to nFiles
	select Strings list
	filename$ = Get string... 'file_i'
	basename$ = filename$ - ".TextGrid"
	Read from file... 'dir$'/'basename$'.TextGrid
	select TextGrid 'basename$'
	Down to Table... no 6 yes no
	select Table 'basename$'
	Save as comma-separated file... 'dir2$'/'basename$'.csv
	select TextGrid 'basename$'
	plus Table 'basename$'
	Remove
endfor