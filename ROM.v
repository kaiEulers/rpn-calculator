`include "CPU.vh"

// Asynchronous ROM (Program Memory)
module asyncROM(
      input      [7:0]address,
      output reg [34:0]instruct
);
    always @(address)
        case (address) 

           //----------------------------------------
           //The Odd Number Loop Program
           //----------------------------------------
            // 0:  instruct = {`MOV, `PUR, `NUM, 8'd1, `REG, `DOUT, `N8};
            // 1:  instruct = {`MOV, `PUR, `NUM, 8'd3, `REG, `DOUT, `N8};
            // 2:  instruct = {`MOV, `PUR, `NUM, 8'd5, `REG, `DOUT, `N8};
            // 3:  instruct = {`MOV, `PUR, `NUM, 8'd7, `REG, `DOUT, `N8};
            // 4:  instruct = {`MOV, `PUR, `NUM, 8'd9, `REG, `DOUT, `N8};
            // 5:  instruct = {`MOV, `PUR, `NUM, 8'd11, `REG, `DOUT, `N8};
            // 6:  instruct = {`MOV, `PUR, `NUM, 8'd13, `REG, `DOUT, `N8};
            // 7:  instruct = {`MOV, `PUR, `NUM, 8'd15, `REG, `DOUT, `N8};
            // 8:  instruct = {`MOV, `PUR, `NUM, 8'd17, `REG, `DOUT, `N8};
            // 9:  instruct = {`MOV, `PUR, `NUM, 8'd19, `REG, `DOUT, `N8};

            // 10: instruct = {`JMP, `UNC, `N10, `N10, 8'd0};


            //----------------------------------------
            //The Shift Left Program
            //----------------------------------------
            // //Move the value 1'd1 to gOut register
            // 0:  instruct = {`MOV, `PUR, `NUM, 8'b0000_0001, `REG, `GOUT, `N8};
            // //Shift the value in gOut register to the left and then store it in gOut register again
            // 1:  instruct = {`MOV, `SHL, `REG, `GOUT, `REG, `GOUT, `N8};
            // 2:  instruct = {`MOV, `SHL, `REG, `GOUT, `REG, `GOUT, `N8};
            // 3:  instruct = {`MOV, `SHL, `REG, `GOUT, `REG, `GOUT, `N8};
            // 4:  instruct = {`MOV, `SHL, `REG, `GOUT, `REG, `GOUT, `N8};
            // 5:  instruct = {`MOV, `SHL, `REG, `GOUT, `REG, `GOUT, `N8};
            // 6:  instruct = {`MOV, `SHL, `REG, `GOUT, `REG, `GOUT, `N8};
            // 7:  instruct = {`MOV, `SHL, `REG, `GOUT, `REG, `GOUT, `N8};
            // 8:  instruct = {`MOV, `SHL, `REG, `GOUT, `REG, `GOUT, `N8};

            // 9: instruct = {`JMP, `UNC, `N10, `N10, 8'd0};
            

            //----------------------------------------
            //The Shift Right Program
            //----------------------------------------
            // // Move the value 1'd1 to gOut register
            // 0:  instruct = {`MOV, `PUR, `NUM, 8'b1000_0000, `REG, `GOUT, `N8};
            // //Shift the value in gOut register to the left and then store it in gOut register again
            // 1:  instruct = {`MOV, `SHR, `REG, `GOUT, `REG, `GOUT, `N8};
            // 2:  instruct = {`MOV, `SHR, `REG, `GOUT, `REG, `GOUT, `N8};
            // 3:  instruct = {`MOV, `SHR, `REG, `GOUT, `REG, `GOUT, `N8};
            // 4:  instruct = {`MOV, `SHR, `REG, `GOUT, `REG, `GOUT, `N8};
            // 5:  instruct = {`MOV, `SHR, `REG, `GOUT, `REG, `GOUT, `N8};
            // 6:  instruct = {`MOV, `SHR, `REG, `GOUT, `REG, `GOUT, `N8};
            // 7:  instruct = {`MOV, `SHR, `REG, `GOUT, `REG, `GOUT, `N8};
            // 8:  instruct = {`MOV, `SHR, `REG, `GOUT, `REG, `GOUT, `N8};

            // 9: instruct = {`JMP, `UNC, `N10, `N10, 8'd0};


            //----------------------------------------
            //The Unsigned +100 Program
            //----------------------------------------
            // 0:  instruct = {`MOV, `PUR, `NUM, 8'd0, `REG, `DOUT, `N8};
            // 4:  instruct = {`OPR, `UAD, `REG, `DOUT, `NUM, 8'd100, `N8};
            // 8:  instruct = {`JMP, `UNC, `N10, `N10, 8'd4};


            //----------------------------------------
            //The Signed -50 Program
            //----------------------------------------
            // 0:  instruct = {`MOV, `PUR, `NUM, 8'sd0, `REG, `DOUT, `N8};
            // 4:  instruct = {`OPR, `SAD, `REG, `DOUT, `NUM, -8'sd50, `N8};
            
            // 8:  instruct = {`JMP, `UNC, `N10, `N10, 8'd4};


            //----------------------------------------
            //The Jump Program
            //----------------------------------------
            // //Moves 1 into dOut
            // 0:  instruct = {`MOV, `PUR, `NUM, 8'd1, `REG, `DOUT, `N8};
            // //Multiply value in dOut by -2
            // 4:  instruct = {`OPR, `SMT, `REG, `DOUT, `NUM, -8'sd2, `N8};
            // //If dOut is less than 64, jump back to instruction 4
            // 7:  instruct = {`JMP, `SLT, `REG, `DOUT, `NUM, 8'd64, 8'd4};

            // //Moves 14 into dOut
            // 10:  instruct = {`MOV, `PUR, `NUM, 8'd14, `REG, `DOUT, `N8};
            // //Add value in dOut by -7
            // 13:  instruct = {`OPR, `SAD, `REG, `DOUT, `NUM, -8'sd7, `N8};
            // //If 0 is less than or equal to dOut, jump back to instruction 13
            // 16:  instruct = {`JMP, `SLE, `NUM, 8'd0, `REG, `DOUT, 8'd13};

            // 20:  instruct = {`JMP, `UNC, `N10, `N10, 8'd0};


            //----------------------------------------
            //The Atomic Clear & Test Program v1
            //----------------------------------------
            //- Program jumps is overflow flag is activated
            //BUG: if dOut lands on 0, program get stuck
            //----------------------------------------
            // //Set dOut to 1
            // 0:    instruct = set(`DOUT, 1);
            // //Multiply dOut by -4
            // 4:    instruct = opr(`SMT, `DOUT, -4);
            // //If the operation above results in an overflow, jump IP to 16
            // 8:    instruct = atc(`OFLW, 16);
            // //Jump IP back to 4 to repeat the multiplication process
            // 12:   instruct = jmp(4);

            // //set dOut to 250
            // 16:   instruct = set(`DOUT, 250);
            // //Add 2 to dOut
            // 20:   instruct = opr(`UAD, `DOUT, 2);
            // //If the operation above results in an overflow, jump IP to 0
            // 24:   instruct = atc(`OFLW, 0);
            // //Jump IP back to 20 to repeat the addition process
            // 28:   instruct = jmp(20);


            //----------------------------------------
            //The Atomic Clear & Test Program v2
            //----------------------------------------
            //- Program jumps is shifted out flag is activated
            //BUG: if dOut lands on 0, program get stuck
            //----------------------------------------
            // //Set dOut to 1
            // 0:    instruct = set(`DOUT, 1);
            // //Shift dOut to the left
            // 4:    instruct = {`MOV, `SHL, `REG, `DOUT, `REG, `DOUT, `N8};
            // //If the operation above results in an overflow, jump IP to 16
            // 8:    instruct = atc(`SHFT, 16);
            // //Jump IP back to 4 to repeat the multiplication process
            // 12:   instruct = jmp(4);

            // //set dOut to 250
            // 16:   instruct = set(`DOUT, 250);
            // //Add 2 to dOut
            // 20:   instruct = opr(`UAD, `DOUT, 2);
            // //If the operation above results in an overflow, jump IP to 0
            // 24:   instruct = atc(`OFLW, 0);
            // //Jump IP back to 20 to repeat the addition process
            // 28:   instruct = jmp(20);


            //----------------------------------------
            //The Bit Setting & Clearing Program
            //---------------------------------------- 
            // 0:    instruct = set(`DOUT, 0);
            // 4:    instruct = setBit(`DOUT, 0);
            // 8:    instruct = setBit(`DOUT, 1);
            // 12:   instruct = setBit(`DOUT, 2);
            // 16:   instruct = setBit(`DOUT, 3);
            // 20:   instruct = setBit(`DOUT, 4);
            // 24:   instruct = setBit(`DOUT, 5);
            // 28:   instruct = setBit(`DOUT, 6);
            // 32:   instruct = setBit(`DOUT, 7);

            // 36:   instruct = clearBit(`DOUT, 7);
            // 40:   instruct = clearBit(`DOUT, 6);
            // 44:   instruct = clearBit(`DOUT, 5);
            // 48:   instruct = clearBit(`DOUT, 4);
            // 52:   instruct = clearBit(`DOUT, 3);
            // 56:   instruct = clearBit(`DOUT, 2);
            // 60:   instruct = clearBit(`DOUT, 1);
            // 64:   instruct = clearBit(`DOUT, 0);

            // 68:   instruct = jmp(0);


            //----------------------------------------
            //The Program with Inputs from Board
            //----------------------------------------  
            // // Enable display
            // 0:    instruct = set(`FLAG, 128);
            // //Move all bits from the flagRegister to gOut. LEDR[4:0] should display these bits.
            // 1:    instruct = mov(`FLAG, `GOUT);
            // //Move value from the dInRegister to dOut. Display should display the output. 
            // 2:    instruct = mov(`DINP, `DOUT);

            // 3:    instruct = jmp(1);


            //----------------------------------------
            //The RPN Calculator
            //----------------------------------------

            //--------------------
            //INITIAL
            //--------------------
            //Enable display module
            0:    instruct = setBit(`GOUT, 7);
            //Reset stack count register[4] to 0
            1:    instruct = set(4, 8'b0000_0000);
            //Reset dOutReg to unknown
            2:    instruct = set(`DOUT, 8'b0000_0000);
            //Reset gOutReg to 0
            3:    instruct = opr(`AND, `GOUT, 8'b1000_0000);

            //--------------------
            //WAIT
            //--------------------
            //Jump to PUSH
            4:     instruct = atc(3, 15);
            //Jump to POP
            5:     instruct = atc(2, 26);
            //Jump to ADD
            6:     instruct = atc(1, 35);
            //Jump to MULTIPLY
            7:     instruct = atc(0, 39);
            //Jump back to the start of WAIT
            8:     instruct = jmp(4);
            
            //--------------------
            //SET-REGISTER4
            //--------------------
            //Set register[4] to 1 to increment the stack count from 0 to 1.
            9:    instruct = set(4, 1);
            //Jump back to PUSH, skipping the shifting oepration.
            10:   instruct = jmp(24);

            //--------------------
            //STACK-OVERFLOW
            //--------------------
            //Set LEDR that denotes a stack-overflow
            11:   instruct = setBit(`GOUT, 4);
            //Jump back to WAIT
            12:   instruct = jmp(4);

            //--------------------
            //VALUE-OVERFLOW
            //--------------------
            //Set LEDR that denotes a value-overflow
            13:   instruct = setBit(`GOUT, 5);
            //Jump back to POP
            14:   instruct = jmp(28);

            //--------------------
            //PUSH
            //--------------------
            ////Clear stack-overflow and value-overflow bits on gOutReg
            15:   instruct = opr(`AND, `GOUT, 8'b1100_1111);
            //Copy value of register[2] to register[3]
            16:   instruct = mov(2, 3);
            //Copy value of register[1] to register[2]
            17:   instruct = mov(1, 2);
            //Copy value of register[0] to register[1]
            18:   instruct = mov(0, 1);
            //Copy value of dInReg to register[0]
            19:   instruct = mov(`DINP, 0);
            //Copy value of register[0] to dOutReg
            20:   instruct = mov(0, `DOUT);
            //If register[4] is 0, jump to SET REGISTER4 and skip the upcoming bit shift
            21:   instruct = {`JMP, `EQ, `REG, 8'd4, `NUM, 8'b0000_0000, 8'd9};
            //If register[4] is equal to 0000_1000, jump to STACK-OVERFLOW
            22:   instruct = {`JMP, `EQ, `REG, 8'd4, `NUM, 8'b0000_1000, 8'd11};       
            //Otherwise, shift register[4] to the left. This increments the stack count.
            23:   instruct = shfL(4);
            //Set bit on gOutReg with active bits of register[4]
            24:   instruct = {`OPR, `OR, `REG, `GOUT, `REG, 8'd4, `N8};
            
            //Jump back to WAIT
            25:   instruct = jmp(4);

            //--------------------
            //POP
            //--------------------
            //Clear stack-overflow and value-overflow bits on gOutReg
            26:   instruct = opr(`AND, `GOUT, 8'b1100_1111);
            //If over-flow bit is activated, jump to VALUE-OVERFLOW
            27:   instruct = atc(4, 13);
            //Copy value of register[1] to register[0]
            28:   instruct = mov(1, 0);
            //Copy value of register[2] to register[1]
            29:   instruct = mov(2, 1);
            //Copy value of register[3] to register[2]
            30:   instruct = mov(3, 2);
            //Copy value of register[0] to dOutReg
            31:   instruct = mov(0, `DOUT);
            //Clear bit on gOutReg with active bits of register[4]
            32:   instruct = {`OPR, `XOR, `REG, `GOUT, `REG, 8'd4, `N8};
            //Otherwise, shift register[4] to the left. This increments the stack count.
            33:   instruct = shfR(4);
            
            //Jump back to WAIT
            34:   instruct = jmp(4);

            //--------------------
            //ADD
            //--------------------
            //Jump to WAIT if register[4] is 0000_0000 because operation can only be performed with at least two values.
            35:   instruct = {`JMP, `EQ, `REG, 8'd4, `NUM, 8'b0000_0000, 8'd4};
            //Jump to WAIT if register[4] is 0000_0001. Same reason as before.
            36:   instruct = {`JMP, `EQ, `REG, 8'd4, `NUM, 8'b0000_0001, 8'd4};
            //Signed addition between register[1] and register[0]. Result is stored in register[1].
            37:   instruct = {`OPR, `SAD, `REG, 8'd1, `REG, 8'd0, `N8}; 
            //Jump to POP
            38:   instruct = jmp(26);

            //--------------------
            //MULTIPLY
            //--------------------
            //Jump to WAIT if register[4] is 0000_0000 because operation can only be performed with at least two values.
            39:   instruct = {`JMP, `EQ, `REG, 8'd4, `NUM, 8'b0000_0000, 8'd4};
            //Jump to WAIT if register[4] is 0000_0001. Same reason as before.
            40:   instruct = {`JMP, `EQ, `REG, 8'd4, `NUM, 8'b0000_0001, 8'd4};
             //Signed multiplication between register[1] and register[0]. Result is stored in register[1].
            41:   instruct = {`OPR, `SMT, `REG, 8'd1, `REG, 8'd0, `N8}; 
            //Jump to POP
            42:   instruct = jmp(26);


            //Default instruction is a "No Operation" NOP
            default: instruct = 35'b0;
        endcase


      //----------------------------------------
      //Functions
      //----------------------------------------
      //set() moves a value into a register
      function [34:0]set;
            input [7:0]regNum;
            input [7:0]value;
            set= {`MOV, `PUR, `NUM, value, `REG, regNum, `N8};
      endfunction

      //mov() moves a value from a source register to a destination register
      function [34:0]mov;
            input [7:0]sourceReg;
            input [7:0]destReg;
            mov= {`MOV, `PUR, `REG, sourceReg, `REG, destReg, `N8};
      endfunction

      //shfL() bit shifts the value of a register to the left
      function [34:0]shfL;
            input [7:0]regNum;
            shfL = {`MOV, `SHL, `REG, regNum, `REG, regNum, `N8};
      endfunction

      //shfR() bit shifts the value of a register to the left
      function [34:0]shfR;
            input [7:0]regNum;
            shfR = {`MOV, `SHR, `REG, regNum, `REG, regNum, `N8};
      endfunction

      //jmp() jumps the instruction pointer to teh specified address
      function [34:0]jmp;
            input [7:0]address;
            jmp = {`JMP, `UNC, `N10, `N10, address};
      endfunction
     
      //atc() will check the bit of the flagRegister. If the bit is activated, the instruction pointer will jump to the specified address and the bit will be cleared.
      function [34:0]atc;
            input [2:0]bitNum;
            input [7:0]address;
            atc = {`ATC, bitNum, `N10, `N10, address};
      endfunction

      //opr() perform a specifed operation on the specified register using the specified value
      function [34:0]opr;
            input [2:0]operand;
            input [7:0]regNum;
            input [7:0]value;
            opr = {`OPR, operand, `REG, regNum, `NUM, value, `N8};
      endfunction

      //setBit will set the a specified bit of a register to 1
      function [34:0]setBit;
            input [7:0]regNum;
            input [2:0]bitNum;
            setBit = {`OPR, `OR, `REG, regNum, `NUM, 8'b1<<bitNum, `N8};
      endfunction

      //clearBit will clear the a specified bit of a register to 0
      function [34:0]clearBit;
            input [7:0]regNum;
            input [2:0]bitNum;
            clearBit = {`OPR, `AND, `REG, regNum, `NUM, ~(8'b1<<bitNum), `N8};
      endfunction

endmodule