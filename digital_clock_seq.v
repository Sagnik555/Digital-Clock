module digital_clock(
    input clk,
    input reset,  // synchronous active high
    input ena,
    output reg pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 

    reg [3:0] h1, h0, m1, m0, s1, s0;
    
    assign hh = {h1, h0};  // different reg for diff digits
    assign mm = {m1, m0};
    assign ss = {s1, s0};
    
    always @(posedge clk) begin
        if (reset) begin        // reset to 12:00:00 am
            pm <= 1'b0;
            h1 <= 4'd1;
            h0 <= 4'd2;
            m1 <= 4'd0;
            m0 <= 4'd0;
            s1 <= 4'd0;
            s0 <= 4'd0;
        end
        else if (ena) begin
            if ((h1 == 4'd1) & (h0 == 4'd1) & (m1 == 4'd5) & (m0 == 4'd9) & (s1 == 4'd5) & (s0 == 4'd9)) begin  // when hh mm ss = 11 59 59
                pm <= ~pm;
                h1 <= 4'd1;
                h0 <= 4'd2;
                m1 <= 4'd0;
                m0 <= 4'd0;
                s1 <= 4'd0;
                s0 <= 4'd0;
            end
            else if ((h1 == 4'd1) & (h0 == 4'd2) & (m1 == 4'd5) & (m0 == 4'd9) & (s1 == 4'd5) & (s0 == 4'd9)) begin  // when hh mm ss = 12 59 59
                h1 <= 4'd0;
                h0 <= 4'd1;
                m1 <= 4'd0;
                m0 <= 4'd0;
                s1 <= 4'd0;
                s0 <= 4'd0;
            end
            else if ((h0 == 4'd9) & (m1 == 4'd5) & (m0 == 4'd9) & (s1 == 4'd5) & (s0 == 4'd9)) begin  // when hh mm ss = x9 59 59
                h1 <= h1 + 4'd1;
                h0 <= 4'd0;
                m1 <= 4'd0;
                m0 <= 4'd0;
                s1 <= 4'd0;
                s0 <= 4'd0;
            end
            else if ((m1 == 4'd5) & (m0 == 4'd9) & (s1 == 4'd5) & (s0 == 4'd9)) begin  // when hh mm ss = xx 59 59
                h0 <= h0 + 4'd1;
                m1 <= 4'd0;
                m0 <= 4'd0;
                s1 <= 4'd0;
                s0 <= 4'd0;
            end
            else if ((m0 == 4'd9) & (s1 == 4'd5) & (s0 == 4'd9)) begin   // when hh mm ss = xx x9 59
                m1 <= m1 + 4'd1;
                m0 <= 4'd0;
                s1 <= 4'd0;
                s0 <= 4'd0;
            end
            else if ((s1 == 4'd5) & (s0 == 4'd9)) begin   // when hh mm ss = xx xx 59
                m0 <= m0 + 4'd1;
                s1 <= 4'd0;
                s0 <= 4'd0;
            end
            else if (s0 == 4'd9) begin   // when hh mm ss = xx xx x9
                s1 <= s1 + 4'd1;
                s0 <= 4'd0;
            end
            else begin
                s0 <= s0 + 4'd1;
            end
        end
    end
    
endmodule