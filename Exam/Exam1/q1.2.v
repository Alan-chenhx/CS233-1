// You want a device that tells you which bus to take for your commute to
// campus based on which buses are running at the time.  The device has 3
// 1-bit inputs:
//   
//        daytime: 1 (day) or 0 (night)     
//        weekday: 1 (weekday) or 0 (weekend)       
//        holiday: 1 (holiday) or 0 (not a holiday)
// 	 
// It has a single 2-bit output, indicating which bus to take:
// 
//        color:    2'b00 (none, you have to walk)     
//                  2'b01 (gold)
//                  2'b10 (orange)
//                  2'b11 (yellow)
// 			       
// You use the following rules to decide which bus to take (or walk if no
// bus is available):
//   
//   - You prefer the gold bus's fast route.  The orange has the worst route,
//     but it's faster than walking.
//   - The orange bus only runs during the day. 
//   - The gold bus only runs on weekdays. 
//   - The yellow bus only runs on non-holidays. 
//

module bus(color, daytime, weekday, holiday);
   output [1:0] color;
   input  	daytime, weekday, holiday;


	assign color[0] = (~daytime & ~weekday & ~holiday) | (~daytime & weekday & ~holiday) | (~daytime & weekday & holiday) | (daytime & ~weekday & ~holiday) | (daytime & weekday & ~holiday) | (daytime & weekday & holiday);
	assign color[1] = (~daytime & ~ weekday & ~holiday) | (daytime & ~weekday & ~holiday) |(daytime & ~weekday & holiday);	
   
endmodule // bus

