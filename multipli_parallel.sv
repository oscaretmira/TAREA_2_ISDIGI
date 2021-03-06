// --------------------------------------------------------------------
// Universitat Politecnica de Valencia
// Escuela Tecnica Superior de Ingenieros de Telecomunicacion
// --------------------------------------------------------------------
// Integracion de Sistemas Digitales
// Curso 2018 - 2019
// --------------------------------------------------------------------
// Nombre del archivo: multipli_parallel.sv
//
// Descripcion: Este codigo SystemVerilog implementa un multiplicador
// de tamanyo parametrizable pero paralelo para que los alumnos puedan empezar a testear rápìdo
//
// --------------------------------------------------------------------
// Versión: V1.0 | Fecha Modificación: 01/10/2018
//
// Autores: Marcos Martínez Peiró
// --------------------------------------------------------------------
module multipli_parallel(CLOCK, RESET, END_MULT, A, B, S, START);

parameter tamano=8;

input CLOCK, RESET;
input logic START;
input logic signed[tamano-1:0] A, B;
output logic signed[2*tamano-1:0] S;
output logic END_MULT;


logic signed [2*tamano-1:0] S_aux;
logic [2*tamano-1:0]END_MULT_aux;
logic signed [tamano-1:0] regA, regB;

always_ff @(posedge CLOCK, negedge RESET)
if (!RESET)
	begin
	regA<=0;regB<=0;END_MULT_aux<=0; S_aux<=0; 
	end
else if (START)
	begin 
	regA<=A;
	regB<=B;
	END_MULT_aux<={START, END_MULT_aux[2*tamano-1:1]};
	end
else
	begin
	regA<=regA;
	regB<=regB;
	S_aux<=regA * regB;
	END_MULT_aux<={1'b0,END_MULT_aux[2*tamano-1:1]};
	end


//La salida END_MULT se obtiene tras 16 ciclos de reloj con un registro de desplazamiento
//aunque en realidad en un solo ciclo ya tenemos la multiplicacion
//tan solo para cumplir con los tiempos del multiplicador secuencial a diseñar

always_ff @(posedge CLOCK, negedge RESET)
begin
if (!RESET)
	END_MULT<=0;
else
	END_MULT<=END_MULT_aux[0];
end
	
assign S=S_aux;

endmodule
