BEGIN {
	packet1=0
	packet2=0}

/^d/&&/cbr/ {
	if($8 == 0)
		packet1++;
	if($8 ==1)
		packet2++;}

END{
	printf("Packets lost flow1 %d\n",packet1);
	
	printf("Packets lost flow2 %d\n",packet2);}
