#!/bin/bash

filename="$1" 
# function to find most popular mechanic or domain
most_popular(){
col_name="$1"
awk -v col="$col_name" -F'\t' '
	BEGIN { OFS="\t" }
	NR==1 {
		for (i = 1; i <= NF; i++) {
			if ($i == col) colname = i;
		}
	}
	NR > 1 && $colname != "" {
		split($colname, colname_list, ", ");
		for (i in colname_list) {
			val = colname_list[i];
			val_counts[val]++;
		}
	}
	END {
		max_count = 0;
		for (v in val_counts) {
			if (val_counts[v] > max_count) {
				max_count = val_counts[v];
				top_val = v;
			}
		}
		print "The most popular game " col " is " top_val " found in " max_count " games"
	}' "$filename"
}
#popular Game Mechanic
most_popular "Mechanics"
most_popular "Domains"

# Pearson Correlation
correlation() {
	awk -F'\t' -v xcol="$1" -v ycol="$2" '
	BEGIN {OFS="\t"}
	NR==1{
		for (i = 1;i <= NF; i++){
			if ($i == xcol) x = i;
			if ($i == ycol) y = i;
		}
	}
	NR > 1 && $x != "" && $y != ""{
		sum_x += $x;
		sum_y += $y;
		ss_x += $x * $x;
		ss_y += $y * $y;
		sum_xy += $x * $y;
		n++;
	}
	END {
		num = n * sum_xy - sum_x * sum_y;
		denom = sqrt((n * ss_x - sum_x * sum_x) * (n * ss_y - sum_y * sum_y));
		printf "%.3f", num / denom;
	}' $filename
}

# year published vs rating average correlation
yr_rate=$(correlation "Year Published" "Rating Average")

# complexity average vs rating average correlation
comp_rate=$(correlation "Complexity Average" "Rating Average")

# Print the results
echo "The correlation between the year of publication and the average rating is $yr_rate"
echo "The correlation between the complexity of a game and its average rating is $comp_rate"
