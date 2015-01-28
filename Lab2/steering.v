module steering(left, right, walk, sensors);
   	output left, right, walk;
   	input [4:0]sensors;
   	wire w1,w2,w3,w4,w5,l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,r1,r2,r3,r4,r5,not_4,not_0,not_1,not_2,not_3;
	
	//for walk
	not n4(not_4, sensors[4]);
	not n0(not_0, sensors[0]);
	and a1(w1, not_4,sensors[3], sensors[2], sensors[1], not_0); //for walk
	and a2(w2, not_4,sensors[3], sensors[2], sensors[1], sensors[0]); //for walk
	and a3(w3, sensors[4],sensors[3], sensors[2], sensors[1], not_0); //for walk  
	and a4(w4, sensors[4],sensors[3], sensors[2], sensors[1], sensors[0]); //for walk
	or o1(w5,w1,w2,w3,w4); //add all the terms together and then reverse it
	not n5(walk,w5); //reverse to get the right output
	
	
	//for left
	not n1(not_1,sensors[1]);
	not n3(not_3,sensors[3]);
	and a5(l1,not_4,not_3,sensors[2],not_1,not_0);
	and a6(l2,not_4,not_3,sensors[2],not_1,sensors[0]);
	and a7(l3,not_4,not_3,sensors[2],sensors[1],not_0);
	and a8(l4,not_4,not_3,sensors[2],sensors[1],sensors[0]);
	and a9(l5,not_4,sensors[3],sensors[2],not_1,sensors[0]);
	and a10(l6,not_4,sensors[3],sensors[2],sensors[1],not_0);
	and a11(l7,not_4,sensors[3],sensors[2],sensors[1],sensors[0]);
	and a12(l8,sensors[4],not_3,sensors[2],not_1,sensors[0]);
	and a13(l9,sensors[4],not_3,sensors[2],sensors[1],not_0);
	and a14(l10,sensors[4],not_3,sensors[2],sensors[1],sensors[0]);
	and a15(l11,sensors[4],sensors[3],sensors[2],sensors[1],sensors[0]);
	or  o2(left,l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11);


	//for right
	and a16(r1,not_4,sensors[3],sensors[2],not_1,not_0);
	and a17(r2,sensors[4],not_3,sensors[2],not_1,not_0);
	and a18(r3,sensors[4],sensors[3],sensors[2],not_1,not_0);
	and a19(r4,sensors[4],sensors[3],sensors[2],not_1,sensors[0]);
	and a20(r5,sensors[4],sensors[3],sensors[2],sensors[1],not_0);
	or o3(right,r1,r2,r3,r4,r5);

endmodule // steering
