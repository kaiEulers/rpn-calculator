//----------------------------------------
//Top Level Design
//----------------------------------------
module MyComputer(
	input 	wire 	CLOCK_50,
	input	wire	[3:0]KEY,
	input	wire	[9:0]SW,

	output 	wire 	[9:0]LEDR,
	output 	wire 	[6:0]HEX0,
	output 	wire 	[6:0]HEX1,
	output 	wire 	[6:0]HEX2,
	output 	wire 	[6:0]HEX3,
	output 	wire 	[6:0]HEX4,
	output 	wire 	[6:0]HEX5
	);
	
	wire reset;
	wire [7:0]dOut;
	wire enableDisp;
	wire [7:0]IP;
	

	//----------------------------------------
	//Debouncing Reset Input
	//----------------------------------------
	debouncer DB0(
		.clock(CLOCK_50),
		.in(SW[9]),

		.out(reset)
		);


	//----------------------------------------
	//Central Processing Unit
	//----------------------------------------
	CPU C0(
	// CPU_test C0(
		.dIn(SW[7:0]),
		.sample(~KEY[3]),
		.PBs(~KEY[2:0]),
		.clock(CLOCK_50),
		.reset(reset),
		.turbo(SW[8]),

		.dOut(dOut),
		.enableDisp(enableDisp),
		.gOut(LEDR[5:0]),
		.debug(LEDR[9:6]),
		.IP(IP)
		);


	//----------------------------------------
	//Display Outputs
	//----------------------------------------
	disp2cNum DD0(
		.x(dOut),
		.enable(enableDisp),

		.disp0(HEX0),
		.disp1(HEX1),
		.disp2(HEX2),
		.disp3(HEX3)
		);

	dispHex DH0(
		.x(IP),
		.enable(enableDisp),	

		.disp0(HEX4),
		.disp1(HEX5)
		);

endmodule