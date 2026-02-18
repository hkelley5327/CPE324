//======================================================
// File: Adder_mealy.v
// Description: Structural Verilog model of a Mealy
//              sequential adder using logic primitives
//              and a D flip-flop
// Name: Hannah Kelley
// Due Date: 2/19/2026
//======================================================

// Mealy Sequential Adder (Structural Model)
module Adder_mealy ( input Clock, A, B, Enable, Reset, output S);
	 // carry states
	 wire carry_q; // for output of D_FF
	 wire carry_d; // for input to D_FF 
	 wire c1, c2, c3; // wires for output of AND gates in carry logic
	 wire s1, s2, s3, s4; // wires for output of AND gates in sum logic
	 wire nA, nB, nC; // wires for output for NOT gates
	 
	 // NOT
	 not n1 (nA, A);
	 not n2 (nB, B);
	 not n3 (nC, carry_q);
	 
	 // AND
	 and a1 (c1, A, B);			// and gates for carry logic
	 and a2 (c2, A, carry_q);
	 and a3 (c3, B, carry_q);
	 and a4 (s1, nA, nB, carry_q); // and gates for sum logic
	 and a5 (s2, nA, B, nC);
	 and a6 (s3, A, nB, nC);
	 and a7 (s4, A, B, carry_q);
	 
	 // OR
	 or o1 (carry_d, c1, c2, c3); // carry
	 or o2 (S, s1, s2, s3, s4); 	// sum
	 
	 // D_FF
	 D_FF ff0(
			.Clock(Clock),
			.D(carry_d),
			.Reset(Reset),
			.Enable(Enable),
			.Q(carry_q),
			.Qn()
	 );

endmodule

// D Flip-Flop Module (code given in assignment)
module D_FF (input Clock, D, Reset, Enable, output reg Q, Qn);
    always @(posedge Clock) begin
        if (Reset == 1) begin
            Q <= 0;
				Qn <= 1;
		  end
        else if (Enable == 1) begin
				Q <= D;
            Qn <= ~D;
		  end
    end
endmodule
