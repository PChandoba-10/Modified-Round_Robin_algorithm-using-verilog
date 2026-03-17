`timescale 1ns / 1ps

module modified_RR_tb;

reg clk;
reg reset;
reg [3:0] request;

wire [3:0] token;
wire [3:0] grant;

reg [3:0] i;  
  
// DUT (Device Under Test)
modified_RR uut (
    .clk(clk),
    .reset(reset),
    .request(request),
    .token(token),
    .grant(grant)
);
  
// CLOCK (10ns period)
initial 
    clk = 0;

always 
    #5 clk = ~clk;
  
// RESET
initial
begin
    reset = 1;
    request = 4'b0000;

    repeat(2) @(posedge clk);
    reset = 0;
end

// TEST ALL REQUEST VALUES
initial
begin
    @(negedge reset);

    for(i = 0; i < 16; i = i + 1)
    begin
        @(posedge clk);
        request <= i;
    end

    #20;
    $finish;
end

// MONITOR OUTPUT
always @(posedge clk)
begin
    $display("T=%0t | token=%b | request=%b | grant=%b",
             $time, token, request, grant);
end
endmodule
