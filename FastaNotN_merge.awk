BEGIN {
	FS = "\n";   # Set field separator as newline
	RS = ">";    # Set record separator as '>'
	OFS = "";    # Output field separator as empty
}
{
	if (NR > 1) {
		# Extract the header and sequence
		header = $1;
		seq = $2;
		# Extract the original sequence name before the first underscore
		if (match(header, /^[^_]+/, arr)) {
			original_name = arr[0];
		} else {
			next; # Skip to the next record if no match is found
		}
		# Extract the position and count of N's using the pattern _<pos>N<count>
		if (match(header, /_([0-9]+)N([0-9]+)/, n_arr)) {
			pos = n_arr[1] + 0; # Convert pos to a number
			nN = n_arr[2];  # Number of 'N's to append
			# Prepend the 'N's to the sequence and store it
			sequence_data[original_name, pos] = ((nN > 0) ? str_repeat("N", nN) : "") seq;
			# Track unique sequence names
			if (!(original_name in seq_names)) {
				seq_names[original_name] = 1;
			}
		}
	}
}
END {
	# Process each unique sequence name
	for (seq_name in seq_names) {
		# Initialize a variable to store the reconstructed sequence
		reconstructed_sequence = "";
		# Collect all fragments related to seq_name
		for (key in sequence_data) {
			split(key, k, SUBSEP);
			if (k[1] == seq_name) {
				seq_fragments[k[2] + 0] = sequence_data[key]; # Ensure positions are stored as numbers
			}
		}
		# Sort positions numerically using asorti with a custom numeric comparison
		num_positions = asorti(seq_fragments, sorted_positions, "@ind_num_asc");
		# Concatenate fragments in sorted order
		for (i = 1; i <= num_positions; i++) {
			reconstructed_sequence = reconstructed_sequence seq_fragments[sorted_positions[i]];
		}
		# Print the final concatenated sequence with its original header
		printf(">%s\n%s\n", seq_name, reconstructed_sequence);
		# Clear seq_fragments and n_counts for the next sequence
		delete seq_fragments;
	}
}


# Custom function to repeat a string 'str' for 'count' times
function str_repeat(str, count, result, i) {
	result = "";
	for (i = 1; i <= count; i++) {
		result = result str;
	}
	return result;
}
