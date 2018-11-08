module CLA4 (
    input [3:0]a,
    input [3:0]b,
    input cin,
    output [3:0]sum,
    output cout,
    output ovfl,
    output tg,
    output tp
    );

    wire [4:0]c;
    wire [3:0]g;
    wire [3:0]p;

    // p & g gen
    assign g[0] = a[0] & b[0];
    assign g[1] = a[1] & b[1];
    assign g[2] = a[2] & b[2];
    assign g[3] = a[3] & b[3];

    assign p[0] = a[0] | b[0];
    assign p[1] = a[1] | b[1];
    assign p[2] = a[2] | b[2];
    assign p[3] = a[3] | b[3];

    assign tp = p[3] & p[2] & p[1] & p[0];
    assign tg = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    // carry gen
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    assign cout = c[4];

    full_adder_1bit U_fullAdder_1bit_0(
        .a(a[0]),
        .b(b[0]),
        .cin(c[0]),
        .sum(sum[0]),
        .cout()
        );

    full_adder_1bit U_fullAdder_1bit_1(
        .a(a[1]),
        .b(b[1]),
        .cin(c[1]),
        .sum(sum[1]),
        .cout()
        );

    full_adder_1bit U_fullAdder_1bit_2(
        .a(a[2]),
        .b(b[2]),
        .cin(c[2]),
        .sum(sum[2]),
        .cout()
        );

    full_adder_1bit U_fullAdder_1bit_3(
        .a(a[3]),
        .b(b[3]),
        .cin(c[3]),
        .sum(sum[3]),
        .cout()
        );

    assign ovfl = (b[3] ~^ a[3]) & (sum[3] != a[3]);

endmodule