#!/bin/bash
inputfile="$1"
file_separator="$2"
tr -d '\r' < "$inputfile"| awk -F"$file_separator" '
#get the header row and initialize the missing count as 0 for each column
NR == 1 {
	num_cols = split($0, col_names)
	for (i = 1; i <= num_cols; i++){
		empty_count[i] = 0
	}
	next
}

#count the number of empty cells in each column
{
	for (i = 1; i <= num_cols; i++) {
		if ($i == ""){
			empty_count[i]++
		}
	}
}
END {
	#print the total number of empty cells in column
	for (i = 1; i <= num_cols; i++) {
		print col_names[i] ": " empty_count[i]
	}
}
'
