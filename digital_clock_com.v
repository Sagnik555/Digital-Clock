module digital_clock(
    input clk,
    input reset,   // Synchronous reset to 12 00 00 am
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 

    wire s0_reset = reset | s1_enable;  // when ss = x9
    wire s1_reset = reset | m0_enable;  // when ss = 59
    wire m0_reset = reset | m1_enable;  // when mm ss = x9 59
    wire m1_reset = reset | h0_enable;  // when mm ss = 59 59
    wire h0_reset = reset ;  
    wire h1_reset = reset ;
    wire pm_reset = reset ;
    
    wire s0_enable = ena;
	wire s1_enable = s0_enable & ss[3] & ss[0];  // when ss = x9
    wire m0_enable = s1_enable & ss[4] & ss[6];  // when ss = 59
    wire m1_enable = m0_enable & mm[0] & mm[3];  // when mm ss = x9 59
    wire h0_enable = m1_enable & mm[4] & mm[6];  // when mm ss = 59 59
    wire h1_enable = h0_enable & ( (hh[0] & hh[3]) | (hh[1] & hh[4]) ); // when hh mm ss = 09 59 59 or 12 59 59
    wire pm_enable = h0_enable & hh[0] & hh[4]; // when hh mm ss = 11 59 59

    wire rollover_12 = h0_enable & hh[1] & hh[4];
    
    counter16 s0 (.clk(clk),  .reset(s0_reset),  .enable(s0_enable),  .count(ss[3:0]));  // seconds ones digit counter
    counter16 s1 (.clk(clk),  .reset(s1_reset),  .enable(s1_enable),  .count(ss[7:4]));  // seconds tens digit counter
    counter16 m0 (.clk(clk),  .reset(m0_reset),  .enable(m0_enable),  .count(mm[3:0]));  // minutes ones digit counter
    counter16 m1 (.clk(clk),  .reset(m1_reset),  .enable(m1_enable),  .count(mm[7:4]));  // minutes tens digit counter
    
    hour_ones_counter h0 (.clk(clk),  .reset(h0_reset),  .enable(h0_enable),   .load(rollover_12),   .count(hh[3:0]));  // hours ones digit counter
    counter2  #(.RESET_VAL(1'd1)) h1 (.clk(clk),  .reset(h1_reset),  .enable(h1_enable),  .count(hh[4]));  // hours tens digit counter
    assign hh[7:5] = 3'b0;   // hours tens digit counter, its always 0 as the digit can only be 0 or 1
    
    counter2  #(.RESET_VAL(1'd0)) pm0 (.clk(clk),  .reset(pm_reset),  .enable(pm_enable),  .count(pm));  // am-pm counter

endmodule

module counter16 (    // Mod 16 counter 
    input clk,   
    input reset,  // synchronous reset
    input enable, 
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (reset)
            count <= 4'd0;
        else if (enable) 
            count <= count + 4'd1;
    end
endmodule

module counter2 #(parameter RESET_VAL = 1'b0) (  // Mod 2 counter with custom default value during a reset 
    input clk, 
    input reset,  // synchronous reset
    input enable, 
    output reg count
);
    always @(posedge clk) begin
        if (reset)
            count <= RESET_VAL;
        else if (enable) 
            count <= count + 1'b1;
    end
endmodule

module hour_ones_counter (  // Mod 10 counter with reset to 2 and parallel load fixed to 1
    input clk,
    input reset,    // synchronous reset
    input enable,
    input load,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd2; // Clock starts at 12
        end
        else if (enable) begin
            if (load)
                count <= 4'd1; // 12 -> 01
            else if (count == 4'd9)
                count <= 4'd0; // 09 -> 10
            else
                count <= count + 4'd1;
        end
    end
endmodule