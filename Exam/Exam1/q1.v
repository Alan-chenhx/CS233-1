// Widgets Incorporated has hired you to build a widget sorter for its
// production line.  The widgets they produce are either red or blue,
// large or small, cube or spherical, and steel or plastic.

// Your widget sorter has 4 sensors:
// A scale that weighs the widget (L = 1, when the widget is large; otherwise L = 0)
// A camera that measures the color (R = 1, when the widget is red; otherwise R = 0) and
//   shape (C = 1, when the widget is cube-shaped; otherwise C = 0)
// A magnet that senses metallic objects (S = 1, when the widget is steel; otherwise S = 0)

// You need to sort the widgets into 4 bins based on their characteristics:
// Small blue spherical and small red spherical widgets should go in bin 1.
// Large cube-shaped steel and large blue spherical widgets should go in bin 0.
// Small cube-shaped steel and large red spherical widgets should go in bin 3.
// All other widgets should go in bin 2.

module widget(bin, L, R, C, S);
   output [1:0] bin;
   input  	L, R, C, S;
   wire w0,w1,w2,w3,w4,w5,w7,w9, not_l, not_r, not_c, not_s;
	not n1(not_l,L);
	not n2(not_r,R);
	not n3(not_c,C);
	not n4(not_s,S);
	
	and a0(w0,not_l,not_r,not_c,not_s);	
 	and a1(w1,not_l,not_r,not_c,S);
	and a2(w2,not_l,R,not_c,not_s);
	and a3(w3,not_l,R,not_c,S);
	or out(bin[1],w0,w1,w2,w3);

	and a4(w4,L,not_r,not_c,not_s);
	and a5(w5,L,not_r,not_c,S);
	and a7(w7,L,not_r,C,S);
	and a9(w9,L,R,C,S);
	or out2(bin[0],w4,w5,w7,w9);
	
endmodule // widget

