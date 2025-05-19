#!/bin/bash
file="$1"
cleanfile=$(mktemp)

cat "$file" | tr ';' '\t'| tr -d '\r'| sed -E 's/\b([0-9]+),([0-9]{1,})\b/\1.\2/g'| perl -pe 's/[^\x00-\x7F]//g' > "$cleanfile"

max_id=$(awk -F'\t' 'NR>1 && $1 ~ /^[0-9]+$/ { if ($1 > max) max=$1 } END { print max }' "$cleanfile")

awk -v nextid="$((max_id + 1))" '
BEGIN {FS=OFS="\t"}
NR==1 { print; next }
{
	if ($1 == "") {
		$1 = nextid;
		nextid++;
	}
	print
}' "$cleanfile"