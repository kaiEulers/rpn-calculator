//----------------------------------------
//CPU Module
//----------------------------------------
`include "CPU.vh"

module CPU(
	input 	wire 		[7:0]dIn,
	input	wire		sample,
	input 	wire		[2:0]PBs,
	input	wire		clock,
	input 	wire 		reset,
	input	wire		turbo,

	output 	wire 		[7:0]dOut,
	output 	wire		enableDisp,
	output 	wire 		[5:0]gOut,
	output 	wire		[3:0]debug,
	output	reg			[7:0]IP = 8'd0
	);

	//----------------------------------------
	//Counter
	//----------------------------------------
	//- slow's clock down to 250ms/cycle
	//----------------------------------------
	//countMax for ModelSim tests
	localparam countMax = 24'd0;
	// localparam countMax = 24'd12_500_000;

	reg [23:0]count = 1;

	always @(posedge clock)
		if (count >= countMax)
			count <= 0;
		else
			count <= count + 1'd1;


	//----------------------------------------
	//CPU Registers
	//----------------------------------------
	//- an array of 32 8bit registers 
	//----------------------------------------
	reg [7:0]register[0:31];

	//These wires are used to read the last four special registers register[28:31]
	wire [7:0]gOutReg 	= register[29];
	wire [7:0]dOutReg 	= register[30];
	wire [7:0]flagReg 	= register[31];

	`define RFLAG register[31]
	`define RDINP register[28]

	//Contents of register[30] is assigned to dOut to be displayed on the 7-segment display
	assign dOut = dOutReg;
	//Contents of the first 5 bits of register[29] is assigned to gOut to be displayed on the LEDRs
	assign gOut = gOutReg[5:0];


	//----------------------------------------
	//Program Memory
	//----------------------------------------
	wire [34:0]instruct;

	//ROM will return an instruction microcode given the address of the instruction (IP)
	asyncROM ROM(
		.address(IP),
		.instruct(instruct)
		);


	//----------------------------------------
	//Inputs
	//----------------------------------------
	wire [7:0]dIn_safe;
	synchroniser SYNC0(
		.clock(clock),
		.in(dIn[0]),

		.out(dIn_safe[0])
		);
	synchroniser SYNC1(
		.clock(clock),
		.in(dIn[1]),

		.out(dIn_safe[1])
		);
	synchroniser SYNC2(
		.clock(clock),
		.in(dIn[2]),

		.out(dIn_safe[2])
		);
	synchroniser SYNC3(
		.clock(clock),
		.in(dIn[3]),

		.out(dIn_safe[3])
		);
	synchroniser SYNC4(
		.clock(clock),
		.in(dIn[4]),

		.out(dIn_safe[4])
		);
	synchroniser SYNC5(
		.clock(clock),
		.in(dIn[5]),

		.out(dIn_safe[5])
		);
	synchroniser SYNC6(
		.clock(clock),
		.in(dIn[6]),

		.out(dIn_safe[6])
		);
	synchroniser SYNC7(
		.clock(clock),
		.in(dIn[7]),

		.out(dIn_safe[7])
		);

	wire [3:0]PB_safe;
	synchroniser SYNC8(
		.clock(clock),
		.in(PBs[0]),

		.out(PB_safe[0])
		);
	synchroniser SYNC9(
		.clock(clock),
		.in(PBs[1]),

		.out(PB_safe[1])
		);
	synchroniser SYNC10(
		.clock(clock),
		.in(PBs[2]),

		.out(PB_safe[2])
		);
	synchroniser SYNC11(
		.clock(clock),
		.in(sample),

		.out(PB_safe[3])
		);

	//The generate-statement is a shorthand way of instantiating modules. In the below statement, it will generate 4 instances of the detectFallEdge module. The generate-variable is also used to declare the inputs adn outputs of this instantiated modules.
	wire [3:0]PB_activated;
	genvar i;
	generate
		for (i = 0; i <= 3; i = i + 1)
		begin: detectFall
			detectFallEdge DFE(
				.clock(clock),
				.in(PB_safe[i]),

				.out(PB_activated[i])
				);
		end
	endgenerate


	//----------------------------------------
	//Turbo Switch
	//----------------------------------------
	wire turbo_safe;
	//Turbo switch needs to be synchronised to prevent glitching and mestablity
	synchroniser SYNC_turbo(
		.clock(clock),
		.in(turbo),

		.out(turbo_safe)
		);


	//----------------------------------------
	//Instruction Cycle
	//----------------------------------------
	//Wire "go" will be HIGH when counter finishes one cycle of counting
	wire go = ~reset && (count == 0 || turbo_safe);
	
	//The instruction returned by the ROM is split into its various parts
	wire [3:0]cmd_grp	= instruct[34:31];
	wire [2:0]cmd		= instruct[30:28];
	wire [1:0]arg1_typ	= instruct[27:26];
	wire [7:0]arg1		= instruct[25:18];
	wire [1:0]arg2_typ	= instruct[17:16];
	wire [7:0]arg2		= instruct[15:8];
	wire [7:0]addr		= instruct[7:0];

	always @(posedge clock)
		if (reset)
		begin
			//Reset button clears IP and the flagRegister
			IP 		<= 8'b0;
			`RFLAG 	<= 8'b0;
		end
		else if (PB_activated)
		begin: pushButtons
			//CPU is constantly detecting inputs from the four pushButtons 
			integer j;
			for (j = 0; j <= 3; j = j + 1)
				//If any of the pushButtons are activated, the corresponding flag in the flagRegister will also be activated. This will also be reflected on the LEDR[2:0].
				if (PB_activated[j])
					`RFLAG[j] <= 1;

			//If pushButton 4 is activated, the value of dIn will be store in the dInRegister.
			if (PB_activated[3])
				`RDINP <= dIn_safe;
		end
		else if (go)
		begin
			//Instruction Pointer (IP) stores the address of a particular instruction. It will increment when "go" is HIGH or reset to 0 when reset is HIGH.
			IP <= IP + 8'd1;

			//Executions are made depending on the microcode
			case (cmd_grp)

				//------------------------------
				//MOVE Command Group
				//------------------------------
				`MOV:
				begin: move
					reg [7:0]tempNum;

					//arg1 is a register address. tempNum will get the value that is store in register[arg1].
					tempNum = getNumber(arg1_typ, arg1);

					case (cmd)
						`SHL:
						begin
							//MSB of tempNum will be store in bit5 of the flag register
							`RFLAG[`SHFT] <= tempNum[7];
							//tempNum is bit shifted to the left
							tempNum = {tempNum[6:0], 1'b0};
						end
						`SHR:
						begin
							//LSB of tempNum will be store in bit5 of th flag register
							`RFLAG[`SHFT] <= tempNum[0];
							//tempNum is bit shifted to the right
							tempNum = {1'b0, tempNum[7:1]};
						end
					endcase

					//tempNum is stored in the register address register[arg2]
					register[getLocation(arg2_typ, arg2)] <= tempNum;
				end

				//------------------------------
				//OPERATION Command Group
				//------------------------------				
				`OPR:
				begin: operation
					reg [7:0]tempNum;
					reg [7:0]tempLoc;
					reg [8:0]result;
					reg signed [8:0]signedResult;

					//arg2 is a register address. Get the value of arg2
					tempNum = getNumber(arg2_typ, arg2);		
					//arg1 is a register address. Get register address of arg1
					tempLoc = getLocation(arg1_typ, arg1);

					//All signed values have to be read by verilog with $signed() before any mathemathetical operation is implemented
					case (cmd)
						//Unsigned Addition
						`UAD:	result = register[tempLoc] + tempNum;
						//Signed Addition
						`SAD:	signedResult = $signed(register[tempLoc]) + $signed(tempNum);
						//Unsigned Multiplication
						`UMT:	result = register[tempLoc] * tempNum;
						//Signed Multiplication
						`SMT:	signedResult = $signed(register[tempLoc]) * $signed(tempNum);
						//Bitwise AND	
						`AND:	result = register[tempLoc] & tempNum;
						//Bitwise OR
						`OR:	result = register[tempLoc] | tempNum;
						//Bitwise XOR
						`XOR:	result = register[tempLoc] ^ tempNum;
					endcase

					//Bit2 of all multiplication and addition commands is 0. If commands are multiplcations or additions...
					if (cmd[2] == 0)
						//Bit0 of unsigned multiplication and addition is 0
						if (cmd[0] == 0)
						begin
						 	//If commands are unsigned multiplication or addition and the result uses more than 8 bits, flag overflow bit in the flag register.
							`RFLAG[`OFLW] <= (result > 255);
						end
						//Bit0 of signed multiplication adn addition is 1. If commands are signed multiplication or addition...
						else
						begin
							//If commands are signed multiplication or addition and the result uses more than 8 bits, flag overflow bit in the flag register.
							`RFLAG[`OFLW] <= (signedResult > 127 || signedResult < -128);

							result = signedResult[7:0];
						end

					//Store result at the register location defined by arg1
					register[tempLoc] <= result[7:0];
				end

				//------------------------------
				//JUMP Command Group
				//------------------------------
				//If `JMP is the cmd_grp, assign arg1 to IP.
				`JMP:
				begin: jump
					reg cond;
					reg [7:0]tempNum1;
					reg [7:0]tempNum2;

					tempNum1 = getNumber(arg1_typ, arg1);
					tempNum2 = getNumber(arg2_typ, arg2);

					case (cmd)
						//Unconditional jump
						`UNC:		cond = 1;
						//Jump on equality
						`EQ:		cond = (tempNum1 == tempNum2);
						//Jump on unsigned less than
						`ULT:		cond = (tempNum1 < tempNum2);
						//Jump on signed less than
						`SLT:		cond = ($signed(tempNum1) < $signed(tempNum2));
						//Jump on unsigned less than or equal
						`ULE:		cond = (tempNum1 <= tempNum2);
						//Jump on signed less than or equal
						`SLE:		cond = ($signed(tempNum1) <= $signed(tempNum2));
						default: 	cond = 0;
					endcase

					if (cond)
						IP <= addr;
				end
					
				//------------------------------
            	//ATOMIC CLEAR & TEST Command Group
           		//------------------------------
           		`ATC:
           		begin: atomicCT
           			//If the flagRegister bit specified by cmd is active, jump IP to the address specifed by addr
           			if (`RFLAG[cmd])
           				IP <= addr;

           			//Clear the flagRegister bit specified by cmd
           			`RFLAG[cmd] <= 0;
           		end

			endcase
		end


	//----------------------------------------
	//LEDR Outputs for Special Bits
	//----------------------------------------
	assign enableDisp 	= gOutReg[`DVAL];
	assign debug[3] 	= flagReg[`SHFT];
	assign debug[2] 	= flagReg[`OFLW];
	assign debug[1] 	= flagReg[`SMPL];
	assign debug[0] 	= go;


	//----------------------------------------
	//Functions
	//----------------------------------------
	function [7:0]getNumber;
		input [1:0]arg_type;
		input [7:0]arg;
		
		begin
			case (arg_type)
				`REG: getNumber = register[arg[5:0]];
				`IND: getNumber = register[register[arg[5:0]][5:0]];
				default: getNumber = arg;
			endcase
		end
	endfunction

	function [7:0]getLocation;
		input [1:0]arg_type;
		input [7:0]arg;
			
		begin
			case (arg_type)
				`REG: getLocation = arg[5:0];
				`IND: getLocation = register[arg[5:0]][5:0];
				default: getLocation = 0;
			endcase
		end
	endfunction
endmodule