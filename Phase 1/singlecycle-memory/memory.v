//////////////////////////////////////
//
// Memory -- single cycle version
//
// written for CS/ECE 552, Spring '07
// Pratap Ramamurthy, 19 Mar 2006
//
// Modified for CS/ECE 552, Spring '18
// Gokul Ravi, 08 Mar 2018
//
// This is a byte-addressable,
// 16-bit wide memory
// Note: The last bit of the address has to be 0.
//
// All reads happen combinationally with zero delay.
// All writes occur on rising clock edge.
// Concurrent read and write not allowed.
//
// On reset, memory loads from file "loadfile_all.img".
// (You may change the name of the file in
// the $readmemh statement below.)
// File format:
//     @0
//     <hex data 0>
//     <hex data 1>
//     ...etc
//
//
//////////////////////////////////////

module memory1c (data_out, data_in, addr, enable, wr, clk, rst);

   parameter ADDR_WIDTH = 16;
   output  [15:0] data_out;
   input [15:0]   data_in;
   input [ADDR_WIDTH-1 :0]   addr;
   input          enable;
   input          wr;
   input          clk;
   input          rst;
   wire [15:0]    data_out;
   
   reg [15:0]      mem [0:2**ADDR_WIDTH-1];
   reg            loaded;
   
   assign         data_out = (enable & (~wr))? {mem[addr[ADDR_WIDTH-1 :1]]}: 0; //Read
   initial begin
      loaded = 0;
   end

   always @(posedge clk) begin
      if (rst) begin
         //load loadfile_all.img
         if (!loaded) begin
            $readmemh("loadfile_all.img", mem);
            loaded = 1;
         end
          
      end
      else begin
         if (enable & wr) begin
	        mem[addr[ADDR_WIDTH-1 :1]] = data_in[15:0];       // The actual write
         end
      end
   end


endmodule 
