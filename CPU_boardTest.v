//----------------------------------------
//CPU Module
//----------------------------------------
`include "CPU.vh"

module CPU_boardTest(
    input   wire    [7:0]dIn,
    input   wire    sample,
    input   wire    [2:0]btns,
    input   wire    clock,
    input   wire    reset,
    input   wire    turbo,

    output  reg     [7:0]dOut   = 8'd0,
    output  reg     dValid,
    output  reg     [5:0]GPO    = 6'd0,
    output  reg     [3:0]debug,
    output  reg     [7:0]IP     = 8'd0
    );
    
    //----------------------------------------
    //Counter
    //----------------------------------------
    //- slow's clock down to 250ms/cycle
    //----------------------------------------
    localparam countMax = 25'd12_500_000;
    reg [24:0]count = 1;

    always @(posedge clock)
        if (count >= countMax)
            count <= 0;
        else
            count <= count + 1'd1;

    //----------------------------------------
    //Testing Displays
    //----------------------------------------
    always @(posedge clock)
    begin
     if (reset == 1)
     begin
         dOut   = 8'd0;
         dValid = 1'd0;
         GPO    = 6'd0;
         debug  = 4'd0;
         IP     = 8'd0;
     end
     else if (count == 0)
     begin
         dValid = 1'b1;
         dOut = dOut + 1'sb1;
         GPO = GPO + 1'b1;
         IP = IP + 1'b1;
     end
    end

endmodule