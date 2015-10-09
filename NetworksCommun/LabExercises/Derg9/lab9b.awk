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
/^r/&&(/cbr/||/exp/||/tcp/)&&/AGT/{
	ltime[$39]=$3;
	if(($7 == 3) && ($37 > 40))
	{
		pnode3[$39]++;
		dnode3[$39]+=$37;
	}
	if(($7 == 4) && ($37 > 40))
	{
		pnode4[$39]++;
		dnode4[$39]+=$37;
	}
	}

/^s/&&(/cbr/||/exp/||/tcp/)&&/AGT/{
	
	if($37 >40)
	{
		if($5 == 0 || $5 ==1){
		packets[$39]++;
		data[$39]+= $37;
		startpnode[$39]++;
		startdnode[$39]+=$37;}
	}
}
END{
	printf("flow 1\n");
	printf("Total packets : %d\n",packets[1]);
	printf("Total data : %d\n",data[1]);
	printf("Total time : %f\n",(ltime[1] -0.15));
	printf("Total packets lost : %d\n",startpnode[1]-pnode3[1]);
	printf("Total data lost : %d\n",startdnode[1]-dnode[3]);
	printf("Total packets sent from node0: %d\n" ,startpnode[1]);
	printf("Total data sent from node0: %d\n" ,startdnode[1]);
	printf("Total packets received to node3: %d\n" ,pnode3[1]);
	printf("Total data received from node3: %d\n" ,dnode3[1]);
	printf("flow 2\n");
	printf("Total packets : %d\n",packets[2]);
	printf("Total data : %d\n",data[2]);
	printf("Total time : %f\n",(ltime[2] -0.3));
	printf("Total packets lost : %d\n",startpnode[2]-pnode4[2]);
	printf("Total data lost : %d\n",startdnode[2]-dnode4[2]);
	printf("Total packets sent from node0: %d\n" ,startpnode[2]);
	printf("Total data sent from node0: %d\n" ,startdnode[2]);
	printf("Total packets received to node4: %d\n" ,pnode4[2]);
	printf("Total data received from node4: %d\n" ,dnode4[2]);
	printf("flow 3\n");
	printf("Total packets : %d\n",packets[3]);
	printf("Total data : %d\n",data[3]);
	printf("Total time : %f\n",(ltime[3] -0.45));
	printf("Total packets lost : %d\n",startpnode[3]-pnode3[3]);
	printf("Total data lost : %d\n",startdnode[3]-dnode[3]);
	printf("Total packets sent from node0: %d\n" ,startpnode[3]);
	printf("Total data sent from node1: %d\n" ,startdnode[3]);
	printf("Total packets received to node3: %d\n" ,pnode3[3]);
	printf("Total data received from node3: %d\n" ,dnode3[3]);
	printf("flow 4\n");
	printf("Total packets : %d\n",packets[4]);
	printf("Total data : %d\n",data[4]);
	printf("Total time : %f\n",(ltime[4] -0.6));
	printf("Total packets lost : %d\n",startpnode[4]-pnode4[4]);
	printf("Total data lost : %d\n",startdnode[4]-dnode4[4]);
	printf("Total packets sent from node0: %d\n" ,startpnode[4]);
	printf("Total data sent from node0: %d\n" ,startdnode[4]);
	printf("Total packets received to node4: %d\n" ,pnode4[4]);
	printf("Total data received from node4: %d\n" ,dnode4[4]);
	}
