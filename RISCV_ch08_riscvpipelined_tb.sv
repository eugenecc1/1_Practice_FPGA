// riscvpipelined.sv

// RISC-V pipelined processor

//Test Program:
// If successful, it should write the value 0xABCDE02E to address 132 (0x84)
// 		RISC-V Assembly 		   Description 				   Address 		Machine
//Code
//main: addi x2, x0,  5 		   # x2 = 5 	 		 	   0 			00500113
//		addi x3, x0, 12 		   # x3 = 12                   4 			00C00193
//		addi x7, x3, -9 		   # x7 = (12 - 9) = 3         8 			FF718393
//		or x4, x7, x2 			   # x4 = (3 OR 5) = 7         C 			0023E233
//		xor x5, x3, x4 		       # x5 = (12 XOR 7) = 11      10 			0041C2B3
//		xadd x5, x5, x4 	       # x5 = (11 + 7) = 18        14 			004282B3
//		xbeq x5, x7, end  		   # shouldn't be taken        18 			02728863
//		xslt x4, x3, x4  		   # x4 = (12 < 7) = 0 	       1C 			0041A233
//		xbeq x4, x0, around        # should be taken 		   20 			00020463
//		xaddi x5, x0, 0  		   # shouldn't happen 	       24 			00000293
//		xaround: slt x4, x7, x2    # x4 = (3 < 5) = 1 	       28 			0023A233
//		xadd x7, x4, x5  		   # x7 = (1 + 18) = 19        2C 			005203B3
//		xsub x7, x7, x2  		   # x7 = (19 - 5) = 14        30 			402383B3
//		xsw x7, 84(x3)  		   # [96] = 14 			       34 			0471AA23
//		xlw x2, 96(x0)  		   # x2 = [96] = 14 		   38 			06002103
//		xadd x9, x2, x5  		   # x9 = (14 + 18) = 32 	   3C 			005104B3
//		xjal x3, end  		       # jump to end, x3 = 0x44    40 			008001EF
//		xaddi x2, x0, 1  		   # shouldn't happen 	       44 			00100113
//		xend: add x2, x2, x9       # x2 = (14 + 32) = 46 	   48 			00910133
//		xaddi x4, x0, 1  		   # x4 = 1 				   4C 			00100213
//		xlui x5, 0x80000  		   # x5 = 0x80000000 		   50 			800002b7
//		xslt x6, x5, x4  		   # x6 = 1 				   54 			0042a333
//		xwrong: beq x6, x0, wrong  # shouldn’t be taken        58 			00030063
//		xlui x9, 0xABCDE  		   # x3 = 0xABCDE000           5C 			ABCDE4B7
//		xadd x2, x2, x9  		   # x2 = 0xABCDE02E 		   60 			00910133
//		xsw x2, 0x40(x3)  		   # mem[132] = 0xABCDE02E     64 			0421a023
//		xdone: beq x2, x2, done    # infinite loop 		       68 			00210063

module testbench();
  logic clk;
  logic reset;
  
  logic [31:0] WriteData, DataAdr;
  logic MemWrite;
  
  // instantiate device to be tested
  top dut(clk, reset, WriteData, DataAdr, MemWrite);

  // initialize test
  initial
    begin
	  reset <= 1; # 22; reset <= 0;
	end
  
  // generate clock to sequence tests
  always
	begin
	  clk <= 1; # 5; clk <= 0; # 5;
	end

  // check results
  always @(negedge clk)
	begin
	  if(MemWrite) begin
		if(DataAdr === 132 & WriteData === 32'hABCDE02E) begin
		  $display("Simulation succeeded");
		  $stop;
		end
	  end
    end
endmodule