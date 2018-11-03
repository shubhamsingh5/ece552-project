module RED (
    input [15:0]a,
    input [15:0]b,
    output [15:0]sum
    );
    

    wire [8:0]suma;
    wire ca;
    wire ca1;

    wire [8:0]sumb;
    wire cb;
    wire cb1;

    wire cab30;
    wire cab74;

    wire [3:0]temp;

    // sum a
    CLA4 U_CLA4_00(
        .a(a[3:0]),
        .b(a[11:8]),
        .cin(1'b0),
        .sum(suma[3:0]),
        .cout(ca),
        .ovfl(),
        .tg(),
        .tp()
        );

    CLA4 U_CLA4_01(
        .a(a[7:4]),
        .b(a[15:12]),
        .cin(ca),
        .sum(suma[7:4]),
        .cout(ca1),
        .ovfl(),
        .tg(),
        .tp()
        );
    
    assign suma[8] = a[7] ^ a[15] ^ ca1;

    // sum b
    CLA4 U_CLA4_02(
        .a(b[3:0]),
        .b(b[11:8]),
        .cin(1'b0),
        .sum(sumb[3:0]),
        .cout(cb),
        .ovfl(),
        .tg(),
        .tp()
        );

    CLA4 U_CLA4_03(
        .a(b[7:4]),
        .b(b[15:12]),
        .cin(cb),
        .sum(sumb[7:4]),
        .cout(cb1),
        .ovfl(),
        .tg(),
        .tp()
        );

    assign sumb[8] = b[7] ^ b[15] ^ cb1;

    // suma + sumb
    CLA4 U_CLA4_10(
        .a(suma[3:0]),
        .b(sumb[3:0]),
        .cin(1'b0),
        .sum(sum[3:0]),
        .cout(cab30),
        .ovfl(),
        .tg(),
        .tp()
        );

    CLA4 U_CLA4_11(
        .a(suma[7:4]),
        .b(sumb[7:4]),
        .cin(cab30),
        .sum(sum[7:4]),
        .cout(cab74),
        .ovfl(),
        .tg(),
        .tp()
        );

    CLA4 U_CLA4_12(
        .a({4{suma[8]}}),
        .b({4{sumb[8]}}),
        .cin(cab74),
        .sum(temp),
        .cout(),
        .ovfl(),
        .tg(),
        .tp()
        );

    assign sum[8] = temp[0];
    assign sum[15:9] = {7{temp[1]}};

endmodule
