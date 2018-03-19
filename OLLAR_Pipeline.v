/*	Open-source Licence Logic & Arithmetic RISC (OLLAR)
	Copyright 2018 Peter A. Miller
	
	This file is part of OLLAR.
	
	OLLAR is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	OLLAR is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with OLLAR.  If not, see <http://www.gnu.org/licenses/>.
*/

//This file defines a the operations of the OLLAR processor
module OLLAR_Ops();
	//Define Inputs
	
	//Define Outputs
	
	//Define Registers
	reg			[05:00]		Use	[2:0]			;	//Tracks register use [5]=Valid [4:0]=Register
	reg			[31:00]	RegLoc0	[2:0]			;	//Tracks location of used register
	reg			[31:00]	RegLoc1	[2:0]			;	//
	reg			[31:00]	RegLoc2	[2:0]			;	//
	reg			[07:00]	Operation[2:0]			;	//Tracks requested operation
	reg						Option	[1:0]			;	//Tracks whether an option is used (IE, use next word)
	reg			[15:00]	Condition[1:0]			;	//Tracks conditions on which to execute operation
	reg			[31:00]	OpIn		[3:0]			;	//Stores inputs to operations (3 is 0 or from memory)
	reg			[31:00]	OpOut		[2:0]			;	//Stores outputs from operations
	reg			[31:00]	SRIn		[3:0]			;	//Stores input status registers (3 is the SR from the previous operation)
	reg			[31:00]	SROut		[3:0]			;	//Stores output status registers (3 is the SR going into the next operation)
	reg			[32:00]	Scratch					;	//Used as an intermediate workspace for operations (Particularly those which produce carry)
	
	//Define Status Bits
	parameter				C		=0					;	//Carry
	parameter				N		=1					;	//Negative
	parameter				V		=2					;	//Overflow
	parameter				Z		=3					;	//Zero
	
	//Define Operation Codes
	parameter	[08:00]	NOP	=8'b00000000	;	//Do nothing
	parameter	[08:00]	JMP	=8'b00000001	;	//Jump to address
	parameter	[08:00]	LD		=8'b00000010	;	//Load value into register
	parameter	[08:00]	ST		=8'b00000011	;	//Store value from register
	parameter	[08:00]	SET	=8'b00000100	;	//Set register to value in next word
	parameter	[08:00]	CLR	=8'b00000101	;	//Clear register
	parameter	[08:00]	CPY	=8'b00001000	;	//Copy value from one register to another
	parameter	[08:00]	SWP	=8'b00001001	;	//Swap the values in two registers
	parameter	[08:00]	CHK	=8'b00100000	;	//Retreive SR Info
	parameter	[08:00]	ADD	=8'b01000000	;	//Addition
	parameter	[08:00]	SUB	=8'b01000001	;	//Subtraction
	parameter	[08:00]	MUL	=8'b01000010	;	//Multiplication
	parameter	[08:00]	DIV	=8'b01000011	;	//Division
	parameter	[08:00]	AND	=8'b10000000	;	//Bitwise AND
	parameter	[08:00]	NAND	=8'b10000001	;	//Bitwise NAND
	parameter	[08:00]	OR		=8'b10000010	;	//Bitwise OR
	parameter	[08:00]	NOR	=8'b10000011	;	//Bitwise NOR
	parameter	[08:00]	XOR	=8'b10000100	;	//Bitwise XOR
	parameter	[08:00]	XNOR	=8'b10000101	;	//Bitwise XNOR
	parameter	[08:00]	NOT	=8'b10000111	;	//Bitwise NOT
	parameter	[08:00]	SRL	=8'b11000000	;	//Shift right logical
	parameter	[08:00]	SLL	=8'b11000001	;	//Shift left logical
	parameter	[08:00]	SRLC	=8'b11000010	;	//Shift right logical through carry
	parameter	[08:00]	SLLC	=8'b11000011	;	//Shift left logical through carry
	parameter	[08:00]	SRA	=8'b11000100	;	//Shift right arithmetic
	parameter	[08:00]	SLA	=8'b11000101	;	//Shift left arithmetic
	parameter	[08:00]	SRAC	=8'b11000110	;	//Shift right arithmetic through carry
	parameter	[08:00]	SLAC	=8'b11000111	;	//Shift left arithmetic through carry
	parameter	[08:00]	SRR	=8'b11001000	;	//Shift right rotate
	parameter	[08:00]	SLR	=8'b11001001	;	//Shift left rotate
	parameter	[08:00]	SRRC	=8'b11001010	;	//Shift right rorate through carry
	parameter	[08:00]	SLRC	=8'b11001011	;	//Shift left rotate through carry
	
	//Pipeline
	always@posedge clock
	
	//Reset
	if(Reset == 1)
		begin
		
		end
	
	//Machine State 3 - Store Data
	if(Stall[3] == 0)
		begin
		Case(Operation[2])
			LD:
				begin
				PC = PC + 1;
				Address = PC;
				Stall[0] = 1;
				Stall[1] = 1;
				Stall[2] = 1;
				Stall[3] = 1;
				R[RegLoc2[2]][31:0] = Input;
				R[RegLoc2[2]][C+32] = 0;
				R[RegLoc2[2]][N+32] = Input[31];
				R[RegLoc2[2]][V+32] = 0;
				R[RegLoc2[2]][Z+32] = Input == 0;
				SR = R[RegLoc2[2]][35:32];
				end
			ST:
				begin
				PC = PC + 1;
				Address = PC;
				Stall[0] = 1;
				Stall[1] = 1;
				Stall[2] = 1;
				Stall[3] = 1;
				SR = SROut[3];
				end
			Default:
				begin
				R[RegLoc0[2]] = OpOut[0];
				R[RegLoc1[2]] = OpOut[1];
				R[RegLoc2[2]] = OpOut[2];
				SR = SROut[3];
				end
			endcase
			
		end
	
	//Machine State 2 - Perform Operation
	if(Stall[2] == 0)
		begin
		//Set default outputs
		OpOut			[0]	=	OpIn			[0]	;
		OpOut			[1]	=	OpIn			[1]	;
		OpOut			[2]	=	OpIn			[2]	;
		SROut			[0]	= 	SRIn			[0]	;
		SROut			[1]	= 	SRIn			[1]	;
		SROut			[2]	=	SRIn			[2]	;
		SROut			[3]	=	SRIn			[3]	;
		Stall			[3]	=	0						;
		Case(Operation[1])
			NOP:
				begin
				//Do nothing
				end
			JMP:
				begin
				if(Option[1] == 0)
					begin
					OpIn[1] = 0;
					end
				PC = OpIn[1] + OpIn[3];
				Stall[0] = 1;
				Stall[1] = 1;
				Stall[2] = 1;
				Stall[3] = 1;
				SR = 4'b0000;
				end
			LD:
				begin
				if(Option[1] == 0)
					begin
					OpIn[1] = 0;
				end
				Address = OpIn[1] + OpIn[3];
				Stall[0] = 1;
				Stall[1] = 1;
				Stall[2] = 1;
				end
			ST:
				begin
				if(Option[1] == 0)
					begin
					OpIn[1] = 0;
					end
				Address = OpIn[1] + OpIn[3];
				Output = OpIn[0];
				Stall[0] = 1;
				Stall[1] = 1;
				Stall[2] = 1;
				end
			SET:
				begin
				if(Option[1] == 1)
					begin
					OpOut[2] = OpIn[3];
					SROut[2][C] = 0;
					SROut[2][N] = OpOut[2][31];
					SROut[2][V] = 0;
					SROut[2][Z] = OpOut == 0;
					SROut[3] = SROut[2]
					end
				end
			CPY:
				begin
				OpOut[2] = OpIn[0];
				SROut[2] = SRIn[0];
				SROut[3] = SROut[2];
				end
			SWP:
				begin
				OpOut[2] = OpIn[0];
				OpOut[0] = OpIn[2];
				SROut[2] = SRIn[0];
				SROut[0] = SRIn[2];
				SROut[3] = SROut[2];
				end
			CLR:
				begin
				OpOut[2] = 0;
				SROut[2][C] = 0;
				SROut[2][N] = 0;
				SROut[2][V] = 0;
				SROut[2][Z] = 1;
				SROut[3] = SROut[2];
				end
			ADD:
				begin
				if(Option[1] == 1)
					begin
					OpIn[1] = OpIn[3];
					end
				Scratch = OpIn[0] + OpIn[1];
				OpOut[2] = Scratch[31:0];
				SROut[2][C] = Scratch[32];
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = (OpIn[0][31] ~^ OpIn[1][31]) && (OpIn[0][31] ^ OpOut[2][31]);
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			SUB:
				begin
				if(Option[1] == 1)
					begin
					OpIn[1] = OpIn[3];
					end
				OpOut[2] = OpIn[0] - OpIn[1];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			MUL:
				begin
				if(Option[1] == 1)
					begin
					OpIn[1] = OpIn[3];
					end
				Scratch = OpIn[0] * OpIn[1];
				OpOut[2] = Scratch[31:0];
				SROut[2][C] = Scratch[32];
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = (OpIn[0] == 8'HFFFFFFFF) && (OpIn[1] == 8'H80000000) || (OpIn[1] == 8'HFFFFFFFF) && (OpIn[0] == 8'H80000000);
				if(OpIn[0] ~= 0)
					begin
					SROut[2][V] = OpIn[1] == OpOut[2] / OpIn[0]);
					end
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			DIV:
				begin
				if(Option[1] == 1)
					begin
					OpIn[1] = OpIn[3];
					end
				OpOut[2] = OpIn[0] / OpIn[1];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];];
				SROut[2][V] = (OpIn[1] == 0) || (OpIn[0] == 8'HFFFFFFFF) && (OpIn[1] == 8'H80000000) || (OpIn[1] == 8'HFFFFFFFF) && (OpIn[0] == 8'H80000000);
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			AND:
				begin
				if(Option[1] == 1)
					begin
					OpIn[1] = OpIn[3];
					end
				OpOut[2] = OpIn[0] & OpIn[1];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			NAND:
				begin
				if(Option[1] == 1)
					begin
					OpIn[1] = OpIn[3];
					end
				OpOut[2] = OpIn[0] ~& OpIn[1];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			OR:
				begin
				if(Option[1] == 1)
					begin
					OpIn[1] = OpIn[3];
					end
				OpOut[2] = OpIn[0] | OpIn[1];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			NOR:
				begin
				if(Option[1] == 1)
					begin
					OpIn[1] = OpIn[3];
					end
				OpOut[2] = OpIn[0] ~| OpIn[1];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			XOR:
				begin
				if(Option[1] == 1)
					begin
					OpIn[1] = OpIn[3];
					end
				OpOut[2] = OpIn[0] ^ OpIn[1];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			XNOR:
				begin
				if(Option[1] == 1)
					begin
					OpIn[1] = OpIn[3];
					end
				OpOut[2] = OpIn[0] ~^ OpIn[1];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			NOT:
				begin
				OpOut[2] = ~ OpIn[2];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			SRL:
				begin
				OpOut[2][30:0] = OpIn[0][31:1];
				OpOut[2][31] = 0;
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			SLL:
				begin
				OpOut[2][31:1] = OpIn[0][30:0];
				OpOut[2][0] = 0;
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			SRLC:
				begin
				OpOut[2][30:0] = OpIn[0][31:1];
				OpOut[2][31] = SRIn[0][C];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			SLLC:
				begin
				OpOut[2][31:1] = OpIn[0][30:0];
				OpOut[2][0] = 0;
				SROut[2][C] = OpIn[0][31];
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			SRA:
				begin
				OpOut[2][30:0] = OpIn[0][31:1];
				OpOut[2][31] = OpIn[0][31];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			SLA:
				begin
				OpOut[2][31:1] = OpIn[0][30:0];
				OpOut[2][0] = 0;
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			SRAC:
				begin
				OpOut[2][30:0] = OpIn[0][31:1];
				OpOut[2][31] = SRIn[0][C];
				SROut[2][C] = SRIn[0][C];
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			SLAC:
				begin
				OpOut[2][31:1] = OpIn[0][30:0];
				OpOut[2][0] = 0;
				SROut[2][C] = OpIn[0][31];
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end	
			SRR:
				begin
				OpOut[2][30:0] = OpIn[0][31:1];
				OpOut[2][31] = OpIn[0][0];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			SLR:
				begin
				OpOut[2][31:1] = OpIn[0][30:0];
				OpOut[2][0] = OpIn[0][31];
				SROut[2][C] = 0;
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			SRRC:
				begin
				OpOut[2][30:0] = OpIn[0][31:1];
				OpOut[2][31] = SRIn[0][C];
				SROut[2][C] = OpIn[0][C];
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			SLRC:
				begin
				OpOut[2][31:1] = OpIn[0][30:0];
				OpOut[2][0] = SRIn[0][C];
				SROut[2][C] = OpIn[0][31];
				SROut[2][N] = OpOut[2][31];
				SROut[2][V] = 0;
				SROut[2][z] = OpOut[2] == 0;
				SROut[3] = SROut[2];
				end
			endcase
		//Forward Values
		Operation	[2]	=	Operation	[1]	;
		RegLoc0		[2]	= 	RegLoc0		[1]	;
		RegLoc1		[2]	= 	RegLoc1		[1]	;
		RegLoc2		[2]	= 	RegLoc2		[1]	;
		
		end
	
	//Machine State 1 - Fetch Operands
	if(Stall[1] == 0)
		begin
		//Check if a register is in use by Machine State 2
		//If so, any new value has yet to be written back
		//Therefore, the new value must be taken from the pipeline
		//RegLoc0
		if			((Use[0][4:0] == RegLoc0[0]) && (Use[0][5] == 1))
			begin
			OpIn[0] = OpOut[0];
			SRIn[0] = SROut[0];
			end
		else if	((Use[1][4:0] == RegLoc0[0]) && (Use[1][5] == 1))
			begin
			OpIn[0] = OpOut[1];
			SRIn[0] = SROut[1];
			end
		else if	((Use[2][4:0] == RegLoc0[0]) && (Use[2][5] == 1))
			begin
			OpIn[0] = OpOut[2];
			SRIn[0] = SROut[2];
			end
		else
			begin
			OpIn[0] = R[RegLoc0[0]][31:0];
			SRIn[0] = R[RegLoc0[0]][35:32];
			end
		//RegLoc1
		if			((Use[0][4:0] == RegLoc0[0]) && (Use[0][5] == 1))
			begin
			OpIn[1] = OpOut[0];
			SRIn[1] = SROut[0];
			end
		else if	((Use[1][4:0] == RegLoc0[0]) && (Use[1][5] == 1))
			begin
			OpIn[1] = OpOut[1];
			SRIn[1] = SROut[1];
			end
		else if	((Use[2][4:0] == RegLoc0[0]) && (Use[2][5] == 1))
			begin
			OpIn[1] = OpOut[2];
			SRIn[1] = SROut[2];
			end
		else
			begin
			OpIn[1] = R[RegLoc0[0]][31:0];
			SRIn[1] = R[RegLoc0[0]][35:32];
			end
		//RegLoc2
		if			((Use[0][4:0] == RegLoc0[0]) && (Use[0][5] == 1))
			begin
			OpIn[2] = OpOut[0];
			SRIn[2] = SROut[0];
			end
		else if	((Use[1][4:0] == RegLoc0[0]) && (Use[1][5] == 1))
			begin
			OpIn[2] = OpOut[1];
			SRIn[2] = SROut[1];
			end
		else if	((Use[2][4:0] == RegLoc0[0]) && (Use[2][5] == 1))
			begin
			OpIn[2] = OpOut[2];
			SRIn[2] = SROut[2];
			end
		else
			begin
			OpIn[2] = R[RegLoc0[0]][31:0];
			SRIn[2] = R[RegLoc0[0]][35:32];
			end
		SRIn[3] = SR;
		//Set Use Information
		Use	[0][5]		=	1						;
		Use	[1][5]		=	1						;
		Use	[2][5]		=	1						;
		Use	[0][4:0]		=	RegLoc0		[0]	;
		Use	[1][4:0]		=	RegLoc1		[0]	;
		Use	[2][4:0]		=	RegLoc2		[0]	;
		if(option[0] == 1)
		//Load next memory address if needed
			begin
			Opin[3] = Input;
			Stall[0] = 1;
			Stall[1] = 1;
			PC = PC + 1;
			Address = PC;
			end
		//Forward Values
		Operation	[1]	=	Operation	[0]	;
		Option		[1]	=	Option		[0]	;
		Condition	[1]	=	Condition	[0]	;
		RegLoc0		[1]	= 	RegLoc0		[0]	;
		RegLoc1		[1]	= 	RegLoc1		[0]	;
		RegLoc2		[1]	= 	RegLoc2		[0]	;
		Stall			[2]	=	0						;
		end
		
	
	//Machine State 0 - Fetch Instruction
	if(Stall[0] == 0)
		begin
		Operation	[0]	=	Input		[31:24]	;
		Option		[0]	=	Input		[23]		;
		Condition	[0]	=	Input		[22:15]	;
		RegLoc0		[0]	=	Input		[14:10]	;
		RegLoc1		[0]	=	Input		[09:05]	;
		RegLoc2		[0]	=	Input		[04:00]	;
		PC						=	PC + 1				;
		Address				=	PC						;
		Stall			[1]	=	0						;
		end

	//Unstall a completely stalled pipeline
	if(Stall == 4'b1111)
		begin
		Stall			[0]	=	0						;
		Use			[0][5]=	0						;
		Use			[1][5]=	0						;
		Use			[2][5]=	0						;
		end
	end
	
	