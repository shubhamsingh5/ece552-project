//Sample testbench for addsub module 
//Works only for adder (i.e. subAdd = 0)
//Tests the overflow flag

module t_adder4b;
        reg[8:0] stim;                          // inputs to UUT are regs
        wire[3:0] S;                            // outputs of UUT are wires
        wire ovfl;
        wire ovfl_mine;
        assign ovfl_mine = (~(stim[3] ^ stim[7]) & (stim[3] ^ S[3])); //My overflow logic, to check against the design's overflow logic

        // instantiate UUT
        fourbitadder addmod(.A(stim[3:0]),.B(stim[7:4]),.subAdd(0),.overflow(ovfl),.result(S)); //subadd only runs for 0

// stimulus generation
        initial begin
        stim = 0;
        repeat(100) begin //Do this for 100 different inputs
        #20 stim = $random;
        if(ovfl_mine == ovfl) $display("Correct"); //Print correct if my logic matches design
        else $display("Incorrect"); //Else print incorrect
         end
        #10 $stop;                      // stops simulation
        end

endmodule

