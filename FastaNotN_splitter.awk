{
	if (index($0,">")==1) {
		if (seq_started) {
			# Introduce a newline before the new sequence
			printf("\n");
		}
		header = $0; # Store the original header
		seq_number = 1; # Initialize the sequence counter
		# Add _0N0 to the first sequence's header
		print header "_0N0"; # Print the modified header
		seq_started = 1; # Flag to avoid newline in the first sequence
	} else {
		if (length($0)==0) {
			printf("\n");
		} else {
			split($0, s, ""); # Split the line into an array of characters
			notN = 0;
			N_count = 0; # Counter for consecutive 'N's
			start_pos = 0; # Start position of the group of 'N's
			for (i=1; i <= length(s); i++) { 
				if ((s[i]=="N")||(s[i]=="n")) {
					if (N_count == 0) {
						start_pos = i; # Mark the start position of the group of 'N's
					}
					N_count++; # Increment the count of consecutive 'N's
					continue;
				}
				if (N_count > 0) {
					# If consecutive 'N's were found, print the header for the new sequence
					printf("\n%s_%dN%d\n", header, start_pos, N_count); 
					seq_number++;
					N_count = 0; # Reset the 'N' counter
				}
				printf("%s", s[i]); # Print the non-'N' character
			}

			if (N_count > 0) {
				# If the line ends with 'N's, print the last header
				printf("\n%s_%dN%d\n", header, start_pos, N_count); 
			}
		}
	}
}
