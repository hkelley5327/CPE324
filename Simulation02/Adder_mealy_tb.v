//======================================================
// File: Adder_mealy_tb.v
// Description: Testbench for Mealy Sequential Adder
// Name: Hannah Kelley
// Due Date: 2/19/2026
//======================================================

`timescale 1ns / 1ps

module Adder_mealy_tb;

	reg Clock, A, B, Reset, Enable;
	
	wire S; // output
	
	Adder_mealy UUT (
		.Clock(Clock),
		.A(A),
		.B(B),
		.Enable(Enable),
		.Reset(Reset),
		.S(S)
	);
	

	always begin
		#50 Clock = ~Clock; 
	end
	
	initial begin
		// initialize inputs
		Clock = 0;
		A = 0;
		B = 0;
		Reset = 1;
		Enable = 1;
		
		@(negedge Clock); // first clock cycle is a reset
		Reset = 0;
		
		// input sequence
		A = 1; B= 0; #100;
		A = 0; B= 1; #100;
		A = 0; B= 0; #100;
		A = 1; B= 1; #100;
		A = 1; B= 1; #100;
		A = 1; B= 0; #100;
		A = 0; B= 1; #100;
		A = 0; B= 0; #100;
		
	end
	
endmodule
	
	
		