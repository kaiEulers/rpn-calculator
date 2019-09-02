//----------------------------------------
//Auxiliary Modules
//----------------------------------------

//----------------------------------------
//DetectFallingEdge Module
//----------------------------------------
module detectFallEdge(
	input wire 	clock,
	input wire 	in,

	output wire out
	);
	
	reg prevIn;

	always @(posedge clock)
		prevIn <= in;

	assign out = prevIn & ~in;

endmodule


//----------------------------------------
//Synchroniser Module
//----------------------------------------
//The clocks its input signal into an out_temp register, and then clocks the out_temp register signal into its output. It synchronises the input and the output with 2 clock cycles to prevent glitching and metastability.
//----------------------------------------
module synchroniser(
	input wire	clock,
	input wire 	in,

	output reg		out
	);
	
	reg out_temp;

	always @(posedge clock)
		out_temp <= in;

	always @(posedge clock)
		out <= out_temp;

endmodule


//----------------------------------------
//De-bouncer Module
//----------------------------------------
//When the de-bouncer detects an input signal (either 1 or 0), it counts till 30ms before it sends a synchronised input signal to its output.
//----------------------------------------
module debouncer(
	input wire	clock,
	input wire	in,

	output reg 	out
	);

	//A maximum count of 1_500_00 pertains to 30ms
	// localparam countMax = 21'd1_500_000;
	//countMax for ModelSim tests
	localparam countMax = 4'd0;

	reg 	[20:0]count = 4'd1;
	//Register "previous" stores the in_synced value of the previous clock cycle
	wire	in_synced;
	reg 	previous;

	//Synchronise the input
	synchroniser SYNC(
		.clock(clock),
		.in(in),

		.out(in_synced)
		);

	//The previous in_synced is stored in a register
	always @(posedge clock)
		previous <= in_synced;

	//Counter counts to 30ms
	always @(posedge clock)
		// If counter reaches its max value, reset count to 0.
		if (count >= countMax)
			count <= 4'd0;
		// If previous and current in_synced value hasn't changed, counter will start counting
		else if (previous == in_synced)
			count <= count + 4'd1;
		// Otherwise, count will remain at 1
		else
			count <= 4'd1;

	//When count reaches 0, out gets whatever value in_synced has
	always @(*)
		if (in_synced && (count == 0))
			out <= 1;
		else if (~in_synced && (count == 0))
			out <= 0;

endmodule


//----------------------------------------
//Display 2's Complement Number Module
//----------------------------------------
module disp2cNum(
	input wire signed 	[7:0]x,
	input wire 			enable,
	
	output wire			[6:0]disp3,
	output wire			[6:0]disp2,
	output wire			[6:0]disp1,
	output wire			[6:0]disp0
	);
	
	//Generate negative flag 
	wire neg;
	assign neg	= (x < 0);
	//Signed value x is in 2's complement form if it is a negative value. Signed values must be operated on with signed values to procure the intended outcome.
	//If x is negative, convert it from 2's complement to unsigned version of the negative value.
	wire [7:0]ux;
	assign ux = neg ? (-1)*x : x;

	//The modulus 10 of an integer will procure the LSB of the value.
	//Dividing an integer by 10^n will remove the n number of bits from the integer starting from the LSB.
	//In 2's complement notation, if the MSB is 1, the value is negative. If the MSB is 0, the value in positive.
	wire [7:0]digit2 	= ux/100;
	wire [7:0]digit1	= ux/10;
	wire [7:0]digit0	= ux;

	wire enableDigit3;
	wire enableDigit2;
	wire enableDigit1;
	wire enableDigit0;

	wire negDigit3;
	wire negDigit2;
	wire negDigit1;	
	wire negDigit0;

	//"Enable" pins for dispDec() modules
	assign enableDigit3 = enable && (neg && digit2 && digit1 && digit0);
	assign enableDigit2 = enable && ((~neg && digit2 && digit1 && digit0) | (neg && digit1 && digit0));
	assign enableDigit1 = enable && ((~neg && digit1 && digit0) | (neg && digit0));
	assign enableDigit0 = enable;
	
	//"Negative" pins for dispDec() modules
	assign negDigit3 = (neg && digit2 && digit1 && digit0);
	assign negDigit2 = (neg && (digit2 == 0) && digit1 && digit0);
	assign negDigit1 = (neg && (digit2 == 0) && (digit1 == 0) && digit0);
	assign negDigit0 = 0;

	dispDec DD3(
		.x(),
		.neg(negDigit3),
		.enable(enableDigit3),

		.segs(disp3)
		);
	dispDec DD2(
		.x(digit2),
		.neg(negDigit2),
		.enable(enableDigit2),

		.segs(disp2)
		);
	dispDec DD1(
		.x(digit1),
		.neg(negDigit1),
		.enable(enableDigit1),

		.segs(disp1)
		);
	dispDec DD0(
		.x(digit0),
		.neg(negDigit0),
		.enable(enableDigit0),

		.segs(disp0)
		);

endmodule
	
//----------------------------------------
//Display Decimal Number Module
//----------------------------------------
module dispDec(
	input wire 	[7:0]x,
	input wire 	neg,
	input wire 	enable,

	// output 	wire 	[7:0]xOut,
	// output	wire 	enableOut,
	output wire [6:0]segs
	);
	
	//Enable next dispDec module connected in series if x is more than 10
	// assign enableOut 	= (x/10 != 0);
	// assign xOut			= x/10;
	
	wire [3:0]digit 	= x%10;

	SSeg SS(.bin(digit),
		.neg(neg),
		.enable(enable),
		.segs(segs)
		);

endmodule


//----------------------------------------
//Display Hexadecimal Number Module
//----------------------------------------
module dispHex(
	input wire 	[7:0]x,
	input wire	enable,

	output wire	[6:0]disp1,
	output wire	[6:0]disp0
	);

	wire [3:0]digit1 	= x[7:4];
	wire [3:0]digit0 	= x[3:0];
	wire neg 			= 1'b0;

	SSeg SS1(
		.bin(digit1),
		.neg(neg),
		.enable(enable),

		.segs(disp1)
		);
	SSeg SS0(
		.bin(digit0),
		.neg(neg),
		.enable(enable),

		.segs(disp0)
		);
	
endmodule


//----------------------------------------
//Seven Segment Display Module
//----------------------------------------
module SSeg(
	input wire	[3:0]bin,
	input wire	neg,
	input wire	enable,

	output reg 	[6:0]segs
	); 

	always @(*)
	begin
		if (enable == 1)
		begin
			if (neg == 1) 
				segs = 7'b011_1111;
			else
				case (bin)
					0: 	segs = 7'b100_0000;
					1: 	segs = 7'b111_1001;
					2: 	segs = 7'b010_0100;
					3: 	segs = 7'b011_0000;
					4: 	segs = 7'b001_1001;
					5: 	segs = 7'b001_0010;
					6: 	segs = 7'b000_0010;
					7: 	segs = 7'b111_1000;
					8: 	segs = 7'b000_0000;
					9: 	segs = 7'b001_1000;
					10: segs = 7'b000_1000;
					11: segs = 7'b000_0011;
					12: segs = 7'b100_0110;
					13: segs = 7'b010_0001;
					14: segs = 7'b000_0110;
					15: segs = 7'b000_1110;
				endcase
		end
		else
		begin
			segs = 7'b111_1111;
		end
	end

endmodule