BEGIN {
	packets[1]=0;
	packets[2]=0;
	packets[3]=0;
	packets[4]=0;
	data[1]=0;
	data[2]=0;
	data[3]=0;
	data[4]=0;
	lpackets[1]=0;
	lpackets[2]=0;
	lpackets[3]=0;
	lpackets[4]=0;
	ldata[1]=0;
	ldata[2]=0;
	ldata[3]=0;
	ldata[4]=0;
	startpnode[1]=0;
	startpnode[2]=0;
	startpnode[3]=0;
	startpnode[4]=0;
	startdnode[1]=0;
	startdnode[2]=0;
	startdnode[3]=0;
	startdnode[4]=0;

}
/^r/&&(/cbr/||/exp/||/tcp/){
	ltime[$8]=$2;
	if(($4 == 3) && ($6 > 40))
	{
		pnode3[$8]++;
		dnode3[$8]+=$6;
	}
	if(($4 == 4) && ($6 > 40))
	{
		pnode4[$8]++;
		dnode4[$8]+=$6;
	}
	}
/^d/&&(/cbr/||/exp/||/tcp/){
	lpackets[$8]++;
	ldata[$8]+= $6;
	}

/^\+/&&(/cbr/||/exp/||/tcp/){
	if($6 >40)
	{
		if($3 == 0 || $3 ==1){
		packets[$8]++;
		data[$8]+= $6;
		startpnode[$8]++;
		startdnode[$8]+=$6;}
	}
}
END{
	printf("flow 1\n");
	printf("Total packets : %d\n",packets[1]);
	printf("Total data : %d\n",data[1]);
	printf("Total time : %f\n",(ltime[1] -0.15));
	printf("Total packets lost : %d\n",lpackets[1]);
	printf("Total data lost : %d\n",ldata[1]);
	printf("Total packets sent from node0: %d\n" ,startpnode[1]);
	printf("Total data sent from node0: %d\n" ,startdnode[1]);
	printf("Total packets received to node3: %d\n" ,pnode3[1]);
	printf("Total data received from node3: %d\n" ,dnode3[1]);
	printf("flow 2\n");
	printf("Total packets : %d\n",packets[2]);
	printf("Total data : %d\n",data[2]);
	printf("Total time : %f\n",(ltime[2] -0.3));
	printf("Total packets lost : %d\n",lpackets[2]);
	printf("Total data lost : %d\n",ldata[2]);
	printf("Total packets sent from node0: %d\n" ,startpnode[2]);
	printf("Total data sent from node0: %d\n" ,startdnode[2]);
	printf("Total packets received to node4: %d\n" ,pnode4[2]);
	printf("Total data received from node4: %d\n" ,dnode4[2]);
	printf("flow 3\n");
	printf("Total packets : %d\n",packets[3]);
	printf("Total data : %d\n",data[3]);
	printf("Total time : %f\n",(ltime[3] -0.45));
	printf("Total packets lost : %d\n",lpackets[3]);
	printf("Total data lost : %d\n",ldata[3]);
	printf("Total packets sent from node0: %d\n" ,startpnode[3]);
	printf("Total data sent from node1: %d\n" ,startdnode[3]);
	printf("Total packets received to node3: %d\n" ,pnode3[3]);
	printf("Total data received from node3: %d\n" ,dnode3[3]);
	printf("flow 4\n");
	printf("Total packets : %d\n",packets[4]);
	printf("Total data : %d\n",data[4]);
	printf("Total time : %f\n",(ltime[4] -0.6));
	printf("Total packets lost : %d\n",lpackets[4]);
	printf("Total data lost : %d\n",ldata[4]);
	printf("Total packets sent from node0: %d\n" ,startpnode[4]);
	printf("Total data sent from node0: %d\n" ,startdnode[4]);
	printf("Total packets received to node4: %d\n" ,pnode4[4]);
	printf("Total data received from node4: %d\n" ,dnode4[4]);
	}