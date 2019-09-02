//----------------------------------------
//Test Bench Template
//----------------------------------------
// module name_test;

// 	//Inputs
// 	reg

// 	//Outputs
// 	wire
		
// 	initial
// 	begin
// 		$monitor();
		
//		$stop;
// 	end
// endmodule


//----------------------------------------
//Testing MyComputer
//----------------------------------------
// module MyComputer_test;

// 	//Inputs
// 	reg CLOCK_50,
// 	reg [3:0]KEY,
// 	reg [9:0]SW,
	
// 	//Outputs
// 	wire [9:0]LEDR;
// 	wire [6:0]HEX0;
// 	wire [6:0]HEX1;
// 	wire [6:0]HEX2;
// 	wire [6:0]HEX3;
// 	wire [6:0]HEX4;
// 	wire [6:0]HEX5;
		
// 	MyComputer COM(
// 		.KEY(KEY),
// 		.SW(SW),

// 		.LEDR(LEDR),
// 		.HEX0(HEX0),
// 		.HEX1(HEX1),
// 		.HEX2(HEX2),
// 		.HEX3(HEX3),
// 		.HEX4(HEX4),
// 		.HEX5(HEX5)	
// 		);

// 	initial
// 		forever
// 			#1 CLOCK_50 = !CLOCK_50;

// 	initial
// 	begin
// 		$monitor();
		

// 		$stop;
// 	end
// endmodule


//----------------------------------------
//Testing CPU
//----------------------------------------
module CPU_test;

	//Inputs
	reg [7:0]dIn;
	reg sample;
	reg [2:0]PBs;
	reg reset;
	reg turbo;
	reg clock;
	//Outputs
	wire enableDisp;
	wire [7:0]IP;
	wire [3:0]debug;
	wire [5:0]gOut;
	wire [7:0]dOut;
		
	CPU C0(
		.reset(reset),
		.turbo(turbo),
		.clock(clock),
		.dIn(dIn),
		.sample(sample),
		.PBs(PBs),

		.dOut(dOut),
		.enableDisp(enableDisp),
		.gOut(gOut),
		.debug(debug),
		.IP(IP)
		);

	initial
		forever
			#1 clock = !clock;

	initial
	begin
		$monitor();
		reset = 0;
		turbo = 0;
		sample = 1;
		clock = 1;
		PBs = 3'b111;
		dIn = 8'd0;

 		#200


		$stop;
	end
endmodule


//----------------------------------------
//Testing detectFallEdge
//----------------------------------------
module detectFallEdge_test;
	
	//Inputs
	reg clock;
	reg in;
	//Outputs
	wire in_synced;
	wire out;

	synchroniser S(
		.clock(clock),
		.in(in),

		.out(in_synced)
		);

	detectFallEdge D(
		.clock(clock),
		.in(in_synced),

		.out(out)
		);

	initial
		forever
			#1 clock = !clock;

	initial
	begin
		$monitor();
		clock = 1;
		#2
		in = 1;
		#2
		in = 0;
		#10
		in = 1;
		#2
		in = 0;
		#10

		$stop;
	end

endmodule


//----------------------------------------
//Testing de-bouncer - SUCCESSFUL!!!
//----------------------------------------
module debouncer_test;

	//Inputs
	reg clock;
	reg in;
	//Outputs
	wire out;
	
	debouncer D0(
		.clock(clock),
		.in(in),

		.out(out)
		);

	initial
		forever
			#1 clock = !clock;

	initial
	begin
		$monitor();
		clock = 1;
		in = 0;
		#5
		in = 1;
		#5
		in = 0;
		#5
		in = 1;
		#5
		in = 0;
		#5

		$stop;
	end

endmodule


//----------------------------------------
//Testing disp2cNum - SUCCESSFUL!!!
//----------------------------------------
module disp2cNum_test;
	
	//Inputs
	reg signed [7:0]x;
	reg enable;
	//Outputs
	wire [6:0]disp0;
	wire [6:0]disp1;
	wire [6:0]disp2;
	wire [6:0]disp3;

	disp2cNum M0(
		.x(x),
		.enable(enable),

		.disp0(disp0),
		.disp1(disp1),
		.disp2(disp2),
		.disp3(disp3)
		);

	initial
	begin
		$monitor(
			enable,,
			x,,
			,,,,
			disp3,,
			disp2,,
			disp1,,
			disp0,,
			);

		enable = 1;
		x = 'dx;
		#1
		x = 0;
		repeat(257)
		begin
			#1
			x = x + 8'sd1;
		end

		$stop;
	end
endmodule


//----------------------------------------
//Testing dispHex - SUCCESSFUL!!!
//----------------------------------------
module dispHex_test;

	//Inputs
	reg [7:0]x;
	reg enable;
	//Outputs
	wire [6:0]disp1;
	wire [6:0]disp0;

	dispHex M0(
		.x(x),
		.enable(enable),

		.disp1(disp1),
		.disp0(disp0)
		);
		
	initial
	begin
		$monitorh(
			x,,
			,,,,
			disp1,,
			disp0
			);
		
		enable = 1;
		x = 0;
		repeat (32)
		begin
			#1
			x = x + 1;
		end
	end
endmodule


//----------------------------------------
//Testing dispDec - SUCESSFUL!!!
//----------------------------------------
module dispDec_test;

	//Inputs
	reg [7:0]x;
	reg neg;
	reg enable;
	//Outputs
	wire [6:0]segs;

	dispDec M0(
		.x(x),
		.neg(neg),
		.enable(enable),

		.segs(segs)
		);
		
	initial
	begin
		$monitor(
			x,,
			segs
			);

		enable = 1;
		neg = 0;
		x = 0;
		repeat (19)
		begin
			#1
			x = x + 1;
		end
	end
endmodule


//----------------------------------------
//Testing SSeg - SUCESSFUL!!!
//----------------------------------------
module SSeg_test;

	//Inputs
	reg [3:0]bin;
	reg neg;
	reg enable;
	//Outputs
	wire [6:0]segs;

	SSeg M0(
		.bin(bin),
		.neg(neg),
		.enable(enable),

		.segs(segs)
		);

	initial
		begin
			$monitorb(
				bin,,
				segs
				);
			
			enable = 1;
			neg = 0;
			bin = 0;

			repeat (15)
			begin
				#1
				bin = bin + 1;
			end
		end
endmodule