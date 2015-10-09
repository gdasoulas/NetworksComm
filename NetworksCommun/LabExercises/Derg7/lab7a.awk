BEGIN {
		revpacks1=0;
		revpacks2=0;
		time1=0.0;
		time2=0.0;
		if (sprintf(sqrt(2)) ~ /,/) dmfix = 1;
}

{
if (dmfix) sub(/\./, ",", $0);
}

/^r/&&/tcp/ {
		if ($6 == 540){
			if ($4 == 5 && $8 == 0){
				revpacks1++;
				if (revpacks1 == 120) time1=$2;
			}
			if ($4 == 7 && $8 == 1){
				revpacks2++;
				if (revpacks2 == 120) time2=$2;
			}
		}
}


END{
	printf("received packets from flow 1: %d\n",revpacks1);
	printf("received packets from flow 2: %d\n",revpacks2);
	printf("finishing time for packet transfer from flow 1: %f sec\n",time1);
	printf("finishing time for packet transfer from flow 2: %f sec\n",time2);
}
