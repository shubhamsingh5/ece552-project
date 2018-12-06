//////////////////////////////////////
//
// Memory -- single cycle write, multi-cycle read
//
// written for CS/ECE 552, Spring '18
// Gokul Ravi, 9 Apr 2018
//
// This is a byte-addressable,
// 16-bit wide memory
// Note: The last bit of the address has to be 0.
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

module memory4c (data_out, data_in, addr, enable, wr, clk, rst, data_valid);

   parameter ADDR_WIDTH = 16;
   output  reg [15:0] data_out;
   output reg data_valid;
   input [15:0]   data_in;
   input [ADDR_WIDTH-1 :0]   addr;
   input          enable;
   input          wr;
   input          clk;
   input          rst;
   wire [15:0]    data_out_4;
   reg [15:0]    data_out_3, data_out_2, data_out_1;
   wire    data_valid_4;
   reg     data_valid_3, data_valid_2, data_valid_1;


   reg [15:0]      mem [0:2**ADDR_WIDTH-1];
   reg            loaded;

   assign         data_out_4 = (enable & (~wr))? {mem[addr[ADDR_WIDTH-1 :1]]}: 0; //Read
   assign	     data_valid_4 = (enable & (~wr));
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

  always @(posedge clk) begin
        if (rst) begin
                data_out_3 <= 0;
                data_out_2 <= 0;
                data_out_1 <= 0;
                data_out <= 0;

                data_valid_3 <= 0;
                data_valid_2 <= 0;
                data_valid_1 <= 0;
                data_valid <= 0;
        end
        else begin
                data_out_3 <= data_out_4;
                data_out_2 <= data_out_3;
                data_out_1 <= data_out_2;
                data_out <= data_out_1;

                data_valid_3 <= data_valid_4;
                data_valid_2 <= data_valid_3;
                data_valid_1 <= data_valid_2;
                data_valid <= data_valid_1;

        end
  end


endmodule
                         
