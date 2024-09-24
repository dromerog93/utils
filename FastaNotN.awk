{
if (index($0,">")==1) {
	print $0;
} else {
	if (length($0)==0) {
		printf("\n");
	} else {
		split($0, s, "");
		notN = 0;
		for (i=1; i <= length(s); i++) { 
			if ((s[i]=="N")||(s[i]=="n")) {
				continue;
			}
			notN = 1;
			printf("%s", s[i])
		}
		if (notN==1) {
			printf("\n");
		}
	}
}
}
