`timescale 1ns / 1ps

// TOP MODULE

module modified_RR(
    input clk,
    input reset,
    input [3:0] request,
    output [3:0] token,
    output [3:0] grant
    );

// Ring counter
token_generator rc (
    .clk(clk),
    .reset(reset),
    .token(token)
);

// priority blocks
wire [3:0] g0,g1,g2,g3;

priority_logic p0 (token[0], 2'd0, request, g0);
priority_logic p1 (token[1], 2'd1, request, g1);
priority_logic p2 (token[2], 2'd2, request, g2);
priority_logic p3 (token[3], 2'd3, request, g3);

// OR gates (final grant)
assign grant = g0 | g1 | g2 | g3;

endmodule

// RING COUNTER (TOKEN GENERATOR)
module token_generator(
    input clk,
    input reset,
    output reg [3:0] token
);

always @(posedge clk or posedge reset)
begin
    if(reset)
        token <= 4'b0001;        // start from requester 0
    else
        token <= {token[2:0], token[3]}; // rotate left
end

endmodule


// FIXED PRIORITY ENCODER
// Priority: 0 > 1 > 2 > 3

module fixed_priority(
    input [3:0] req,
    output reg [3:0] grant
);

always @(*)
begin
    grant = 4'b0000;

    if(req[0])      grant = 4'b0001;
    else if(req[1]) grant = 4'b0010;
    else if(req[2]) grant = 4'b0100;
    else if(req[3]) grant = 4'b1000;
end

endmodule



// ROTATING PRIORITY LOGIC

module priority_logic (
    input en,
    input [1:0] shift,
    input [3:0] req,
    output reg [3:0] grant
);

reg [3:0] rotated_req;
wire [3:0] rotated_grant;

// rotate requests depending on token
always @(*) 
begin
    if (shift == 2'd0)
        rotated_req = req;

    else if (shift == 2'd1)
        rotated_req = {req[0], req[3:1]};

    else if (shift == 2'd2)
        rotated_req = {req[1:0], req[3:2]};

    else
        rotated_req = {req[2:0], req[3]};
end

// fixed priority arbiter
fixed_priority fp (
    .req(rotated_req),
    .grant(rotated_grant)
);

// rotate grant back
always @(*) 
begin
    if (!en)
        grant = 4'b0000;

    else if (shift == 2'd0)
        grant = rotated_grant;

    else if (shift == 2'd1)
        grant = {rotated_grant[2:0], rotated_grant[3]};

    else if (shift == 2'd2)
        grant = {rotated_grant[1:0], rotated_grant[3:2]};

    else
        grant = {rotated_grant[0], rotated_grant[3:1]};
end

endmodule
