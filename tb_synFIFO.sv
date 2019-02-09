// Testbench for Synchronous FIFO
`define DEBUG

module tb_syncFIFO;

   parameter DATA_WIDTH = 8;
   parameter FIFO_DEPTH = 8;
   parameter CLK_PERIOD	= 20;

   logic [DATA_WIDTH-1:0] TestData [$];
   

   // Input signal declaration
   logic clk;
   logic nrst;
   logic wr;
   logic rd;
   logic [DATA_WIDTH-1:0] data_in;

   // Output signal
   logic [DATA_WIDTH-1:0] data_out;
   logic 		   fifo_full;
   logic 		   fifo_empty;

  
  
   initial
     begin
	clk 	= 1'b0;
	nrst 	= 1'b0;
	wr 	= 1'b0;
	rd 	= 1'b0;

	#100 nrst = 1'b1;

	// Fifo write
	#100 ;
	wr = 1'b1;
	repeat(FIFO_DEPTH*2)
	  begin
	     @(posedge clk) data_in = $random;
	  end
	
	// FIFO Read
	#50
	  wr = 1'b0;
      	repeat(FIFO_DEPTH*2)
	  begin
	     @(posedge clk)  rd = 1'b1;
	  end
	// Fifo write
	#10 ;
	wr = 1'b1;
	repeat(5)
	  begin
	     @(posedge clk) data_in = $random;
	  end
	// FIFO Read
	#10
	  wr = 1'b0;
      	repeat(3)
	  begin
	     @(posedge clk)  rd = 1'b1;
	  end

	#10
	  wr = 1'b0;
      	repeat(5)
	  begin
	     @(posedge clk)  rd = 1'b1;
	  end
	
     end // initial begin
   
   always
     #(CLK_PERIOD/2) clk = !clk;


   syncFifo #(8,FIFO_DEPTH) U_DUT (
			     .clk(clk),
			     .nrst(nrst),
			     .wr(wr),
			     .rd(rd),
			     .data_in(data_in),
			     .data_out(data_out),
			     .fifo_full(fifo_full),
			     .fifo_empty(fifo_empty)
			     );

   initial
     begin
	#1500 $finish;
     end

  
endmodule // tb_syncFIFO
