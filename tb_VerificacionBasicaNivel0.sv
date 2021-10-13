`timescale 1 ns / 1 ps
module tb_VerificacionBasicaNivel0();

parameter tamano=8;

reg clk;
reg [tamano-1:0] A,B;
login fin_mult;
logic start;
reg rst;
wire [(2*tamano)-1:0] S;

initial begin clk=1'b0;
forever #50 clk=!clk;
end


initial begin
rst=1;
start=0;
#1 rst=1;
#500 rst=1;
#100 A=8'b100; //100*2
B=8'd2;
start=1;
@ (posedge fin_mult);
@ (negedge clk);
#50 start=0;
#100 A=8'd10; //10*3
B=8'd3;
start=1;
@ (posedge fin_mult);



//Restos de caso


$stop;
end
multipli DUV
(.CLOCK(clk),
 .RESET(rst),
 .A(A),
 .B(B),
 .END_MULT(fin_mult),
 .S(S)
 
);

endmodule
