`timescale 1 ns / 1 ps
module tb_VerificacionBasicaNivel0();

parameter tamano=10;

reg CLOCK;
reg [tamano-1:0] A,B;
logic END_MULT;
logic START;
reg RESET;
wire [(2*tamano)-1:0] S;

class Estimulos_aleatorios;
	rand bit signed [tamano-1:0] variable_A;
	rand bit signed[tamano-1:0] variable_B;

	//constraint rangoA {A inside {[-(2**(tamano-1)):(2**(tamano-1)-1)]};}; 
	//constraint rangoA {A inside {[0:2**(tamano-1)-1)]};}; 
	//constraint rangoA {A inside {-[0: (tamano-1)+tamano/2]};};

	constraint rangoA {variable_A[tamano-2:0] inside {[0:tamano-2]};}; 
	constraint signoA {variable_A[tamano-1] inside{[0:1]};};
	constraint rangoB {variable_B[tamano-2:0] inside {[0:tamano-2]};}; 
	constraint signoB {variable_B[tamano-1] inside{[0:1]};};
endclass

Estimulos_aleatorios pkt;

initial begin
	RESET=0;
	START=0;
	#1 RESET=1;

   pkt = new; 
	repeat (10) generacion_valores; 
 $stop;
end

task generacion_valores; 
	begin
		@(negedge CLOCK); 
		START = 1; 
		@(negedge CLOCK);
		pkt.randomize();
		
		$display("Variable A = %0d - Variable B = %0d",pkt.variable_A,pkt.variable_B);
		A = pkt.variable_A; 
		B = pkt.variable_B; 
		
		@(negedge CLOCK); 
		START = 0;
		repeat (16) @(posedge CLOCK); 
		@(negedge CLOCK); 
		START = 1;
		@(negedge CLOCK); 
		START = 0; 
		@(negedge CLOCK);
		#(16*100);
		
	end
endtask
   
//multipli_parallel DUV
//(.CLOCK(CLOCK),
// .RESET(RESET),
// .A(A),
// .B(B),
// .END_MULT(fin_mult),
// .S(S),
// .START(START)
//);

multipli_parallel #(.tamano(tamano)) DUv (.*);
//defparam DUV.tamano = tamano; 

//defparam multipli_parallel_inst.tamano = 8;


initial 
	begin 
		CLOCK=1'b0;
		forever #50 CLOCK=!CLOCK;
	end

endmodule
