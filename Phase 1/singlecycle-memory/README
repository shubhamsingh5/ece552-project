######    Single-Cycle Memory Specification   ###############################################################

For the first stage of your project, you are asked to design a processor which executes each instruction in a single cycle. For this, you will use the single-cycle byte-addressable memory module described here. 

Since your single-cycle design must fetch instructions as well as read or write data in the same cycle, you will want to use TWO instances of this memory -- one for data, and one for instructions. 


                      +-------------+ 
data_in[15:0] >-------|             |--------> data_out[15:0] 
   addr[15:0] >-------|   16 bit    | 
       enable >-------|   memory    |
           wr >-------|   with      |
          clk >-------|   variable  |
          rst >-------|   address   |
   createdump >-------|   width     |
                      |             |
                      +-------------+



During each cycle, the "enable" and "wr" inputs determine what function the memory will perform: 

enable wr  Function       data_out 
0      X   No operation   0 
1      0   Read M[addr]   M[addr]
1      1   Write data_in  0 

During a read cycle, the data output will immediately reflect the contents of the address input and will change in a flow-through fashion if the address changes. For writes, the "wr", "addr", and "data_in" signals must be stable at the rising edge of the clock ("clk"). 


#########   How to initialize your memory   ##################################################################

The memory is intialized from a file. The file name is "loadfile_all.img", but you may change that in the Verilog source to any file name you prefer. The file is loaded at the first rising edge of the clock during reset. The simulator will look for the file in the same location as your .v files. The file format is: 

@0 
1234 
1234 
1234 
1234 

where "@0" specifies a starting address of zero, and "1234" represents any 4-digit hex number. Any number of lines may be specified, up to the size of the memory. The assembler will produce files in this format.


