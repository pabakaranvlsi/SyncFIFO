// Synchronous fifo design
module syncFifo #(parameter DATA_WIDTH = 8, 
		  parameter FIFO_DEPTH = 16
		  )(
		    clk,
		    nrst,
		    wr,
		    rd,
		    data_in,
		    data_out,
		    fifo_full,
		    fifo_empty
		    );

   // Input signal declaration
   input clk;
   input nrst;
   input wr;
   input rd;
   input [DATA_WIDTH-1:0] data_in;

   // Output signal
   output [DATA_WIDTH-1:0] data_out;
   output 		   fifo_full;
   output 		   fifo_empty;


   // FIFO Memory declaration
   logic [DATA_WIDTH-1:0]  mem [FIFO_DEPTH-1:0];

   // Read and Write pointer declaration
   logic [$clog2(FIFO_DEPTH):0] rd_ptr;
   logic [$clog2(FIFO_DEPTH):0] wr_ptr;

   // Local signal declaration
   logic 			r_full;
   logic 			r_empty;
   logic 			r_wr_en;
   logic 			r_rd_en;
   logic [DATA_WIDTH-1:0] 	r_data_out;

   // Output assignment
   assign fifo_full	= r_full;
   assign fifo_empty	= r_empty;
   assign data_out	= r_data_out;
   
   // Assign local flags
   assign r_wr_en = (wr && !r_full) ? 1'b1:1'b0;
   assign r_rd_en = (rd && !r_empty) ? 1'b1:1'b0;
   
   
   // Assign FIFO full and empty conditions
   assign r_full	= (rd_ptr[$clog2(FIFO_DEPTH)] != wr_ptr[$clog2(FIFO_DEPTH)] && 
			   ((rd_ptr[$clog2(FIFO_DEPTH)-1:0]) == (wr_ptr[$clog2(FIFO_DEPTH)-1:0]))) ;

   assign r_empty	= (rd_ptr == wr_ptr);


   // FIFO logic - Write block
   always_ff@(posedge clk or negedge nrst)
     begin:WRITE_BLOCK
	if(!nrst)
	  begin
	     wr_ptr <= {$clog2(FIFO_DEPTH){1'b0}};
     end
	else if(r_wr_en)
	  begin
	     mem[wr_ptr[$clog2(FIFO_DEPTH)-1:0]] <= data_in;
	     wr_ptr <= wr_ptr + 1;
	  end
	else
	  begin
	     wr_ptr <= wr_ptr;
	  end
     end // block: WRITE_BLOCK

   // FIFO Read block
   always_ff@(posedge clk or negedge nrst)
     begin:READ_BLOCK
	if(!nrst)
	  begin
	     r_data_out <= {DATA_WIDTH{1'b0}};
	rd_ptr <= {$clog2(FIFO_DEPTH){1'b0}};
     end
	else if(r_rd_en)
	  begin
	     r_data_out <= mem[rd_ptr[$clog2(FIFO_DEPTH)-1:0]];
	     rd_ptr <= rd_ptr + 1;
	  end
	else
	  begin
	     r_data_out <= r_data_out;
	  end
     end // block: READ_BLOCK

   
endmodule // syncFifo
