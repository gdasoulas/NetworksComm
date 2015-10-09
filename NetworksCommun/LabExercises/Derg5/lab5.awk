BEGIN {
data=0;
packets=0;
last_a=0.001;
}
/^r/&&/tcp/ {
data+=$6;
packets++;
}

/^r/&&/ack/ {
	last_a = $2;
	}


END{
printf("Total Data received\t: %d Bytes\n", data);
printf("Total Packets received\t: %d\n", packets);
}