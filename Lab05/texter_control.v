// Single Button Texter -- texter control module
// -- texter_control.v file
// (c) 2/5/2026 B. Earl Wells, University of Alabama in Huntsville
// all rights reserved -- for academic use only.
//
// This is the main texter_control module for the single button texter.
// This module should implement the design that was described by the
// ASM Chart that was presented in the CPE 322 class.
// The design is to be reset to state S0 whenever the reset signal is
// at a logic high. Whenever the reset signal is at a logic low it
// should fully implement the state machine specified by the SM chart.
// The clock signal is assumed to be a 50% duty cycle clock that is the
// same clock that drives the other functional units that
// are being controlled by this module (50 Mhz on the DE2-115). The other
// input and output signals are all assumed to be active high. The
// input signal, sw, is controlled by the user and the other inputs
// are status inputs that come directly from the functional units in the
// data path that are being controlled. These inputs will change their states
// in direct response to your controlling outputs that you provide. The
// outputs are all assumed to be active for a one clock duration as
// indicated by the ASM chart.

module texter_control(input clk, reset, sw, space, dash_dit, dc_error,
   output reg nxt_bit, nxt_char, out_char, out_space, tm_reset,
   sp_load, back_sp);

  reg [2:0] state;
  reg [2:0] next_state;
  
  localparam S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4, S5 = 3'd5;

  // all 6 states case statement (S0 - S5)
  always @(state, reset, sw, space, dash_dit, dc_error) begin
	 nxt_bit = 0;
	 nxt_char = 0;
	 out_char = 0; 
	 out_space = 0;
	 tm_reset = 0;
	 sp_load = 0;
	 back_sp = 0;
	 
	 next_state = state;
	 
      case (state)
        0: begin
          if (sw) begin
            tm_reset  = 1;
            nxt_char  = 1;
            next_state = 1;
          end
        end

        1: begin
          if (sw) begin
            next_state = 1;
          end else begin
            if (space) begin
              back_sp   = 1;
              next_state = 0;
            end else begin
				  nxt_bit = 1;
				  if (dash_dit) begin
						sp_load = 1;
				  end
              next_state = 2;
            end
          end
        end

        2: begin
          tm_reset = 1;
          next_state = 3;
        end

        3: begin
          if (sw) begin
            sp_load   = 1;
            next_state = 4;
          end else begin
            if (!dash_dit) begin
              next_state = 3;
            end else begin
              if (dc_error) begin
                next_state = 0;
              end else begin
                out_char = 1;
                next_state = 5;
              end
            end
          end
        end

        4: begin
          tm_reset   = 1;
          next_state = 1;
        end

        5: begin
          if (sw) begin
            nxt_char  = 1;
            tm_reset  = 1;
            next_state = 1;
          end else if (space) begin
            out_space = 1;
            next_state = 0;
          end else begin
            next_state = 5;
          end
        end
      endcase
    end


  always @(posedge clk) begin
    if (reset) begin
		state <= 0;
	 end
	 else begin
		state <= next_state;
	 end
  end

endmodule
