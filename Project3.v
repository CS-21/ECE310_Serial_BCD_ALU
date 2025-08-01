`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: North Carolina State University (ECE 310)
// Engineer: Chinmay Shende
// 
// Create Date: 04/15/2025 12:24:06 AM
// Design Name: 
// Module Name: Project3
// Project Name: Project 3
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Project3(
    input  clock,
    input  reset,
    input  din,
    output result
);
    reg  [40:0] sipo;
    wire        header = (sipo[40:33] == 8'hA5);
    always @(posedge clock) begin
        if (reset)          sipo <= 41'd0;
        else if (header)    sipo <= 41'd0;
        else                sipo <= {sipo[39:0], din};
    end

    reg         stage1_valid;
    reg         op_reg;
    reg  [15:0] A_reg, B_reg;
    always @(posedge clock) begin
        if (reset) begin
            stage1_valid <= 1'b0;
            op_reg       <= 1'b0;
            A_reg        <= 16'd0;
            B_reg        <= 16'd0;
        end else if (header) begin
            stage1_valid <= 1'b1;
            op_reg       <= sipo[32];
            A_reg        <= sipo[31:16];
            B_reg        <= sipo[15:0];
        end else begin
            stage1_valid <= 1'b0;
        end
    end

    reg stage2_valid;
    always @(posedge clock) begin
        if (reset)      stage2_valid <= 1'b0;
        else            stage2_valid <= stage1_valid;
    end

    wire [15:0] B9 = {
        4'd9 - B_reg[15:12],
        4'd9 - B_reg[11:8],
        4'd9 - B_reg[7:4],
        4'd9 - B_reg[3:0]
    };

    wire [15:0] add_S, sub_S;
    wire        add_Cout, sub_Cout;

    BCD4 add_inst(
        .A  (A_reg),
        .B  (B_reg),
        .Cin(1'b0),
        .S  (add_S),
        .Cout(add_Cout)
    );

    BCD4 sub_inst(
        .A  (A_reg),
        .B  (B9),
        .Cin(1'b1),
        .S  (sub_S),
        .Cout(sub_Cout)
    );

    wire [19:0] result_data = op_reg
        ? {4'b0000,      sub_S}
        : {3'b000, add_Cout, add_S};

    reg [27:0] piso;
    always @(posedge clock) begin
        if (reset)            piso <= 28'd0;
        else if (stage2_valid) piso <= {8'h96, result_data};
        else                  piso <= {piso[26:0], 1'b0};
    end

    assign result = piso[27];
endmodule

module BCD1(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       Cout
);
    wire [4:0] sum1   = A + B + Cin;
    wire       adjust = (sum1 > 5'd9);
    wire [4:0] sum2   = adjust ? (sum1 + 5'd6) : sum1;
    assign S    = sum2[3:0];
    assign Cout = sum2[4];
endmodule

module BCD4(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire c0, c1, c2;
    BCD1 digit0(.A(A[3:0]  ), .B(B[3:0]  ), .Cin(Cin ), .S(S[3:0]  ), .Cout(c0));
    BCD1 digit1(.A(A[7:4]  ), .B(B[7:4]  ), .Cin(c0  ), .S(S[7:4]  ), .Cout(c1));
    BCD1 digit2(.A(A[11:8] ), .B(B[11:8] ), .Cin(c1  ), .S(S[11:8] ), .Cout(c2));
    BCD1 digit3(.A(A[15:12]), .B(B[15:12]), .Cin(c2  ), .S(S[15:12]), .Cout(Cout));
endmodule