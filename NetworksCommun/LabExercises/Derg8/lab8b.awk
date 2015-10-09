BEGIN {
	 hoppi = 0;
	  packets = 0;

	    # Do we need to fix the decimal mark?
	    if (sprintf(sqrt(2)) ~ /,/) dmfix = 1;
	}
	{
		 # Apply dm fix if needed
		 if (dmfix) sub(/\./, ",", $0);
	 }
	  /^r/&&/AGT/&&/cbr/ {
		    packets++;
		  }
	 /^f/&&/cbr/{
			hoppi++;
		 }
			END {
				  printf("Total hops\t: %d\n", hoppi/packets+1);
					}
