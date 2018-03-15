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
	reg			[5:0]		Use	[2:0]				;	//Tracks register use [5]=Valid [4:0]=Register
	
	//Define Operation Codes
	parameter	[08:00]	NOP	=8'b00000000	;	//Do nothing
	parameter	[08:00]	JMP	=8'b00000001	;	//Jump to address
	parameter	[08:00]	LD		=8'b00000010	;	//Load value into register
	parameter	[08:00]	ST		=8'b00000011	;	//Store value from register
	parameter	[08:00]	SET	=8'b00000100	;	//Set register to value in next word
	parameter	[08:00]	CLR	=8'b00000101	;	//Clear register
	parameter	[08:00]	ADD	=8'b01000000	;	//Addition
	parameter	[08:00]	SUB	=8'b01000001	;	//Subtraction
	parameter	[08:00]	MUL	=8'b01000010	;	//Multiplication
	parameter	[08:00]	DIV	=8'b01000011	;	//Division
	parameter	[08:00]	AND	=8'b10000000	;	//Bitwise AND
	parameter	[08:00]	NAND	=8'b10000001	;	//Bitwise NAND
	parameter	[08:00]	OR		=8'b10000010	;	//Bitwise OR
	parameter	[08:00]	NOR	=8'b10000011	;	//Bitwise NOR
	parameter	[08:00]	XOR	=8'b10000100	;	//Bitwise XOR
	parameter	[08:00]	NOT	=8'b10000101	;	//Bitwise NOT
	parameter	[08:00]	SHR	=8'b10001000	;	//Shift right
	parameter	[08:00]	SHL	=8'b10001001	;	//Shift left
	parameter	[08:00]	SHRC	=8'b10001010	;	//Shift right through carry
	parameter	[08:00]	SHLC	=8'b10001011	;	//Shift left through carry
	parameter	[08:00]	RTR	=8'b10001100	;	//Rotate right
	parameter	[08:00]	RTL	=8'b10001101	;	//Rotate left
	parameter	[08:00]	RTRC	=8'b10001110	;	//Rotate right through carry
	parameter	[08:00]	RTLC	=8'b10001111	;	//Rotate left through carry
	
	//Pipeline
	always@posedge clock
	
	//Reset
	if(Reset == 1)
		begin
		
		end
	
	//Machine State 3 - Store Data
	if(Stall[3] == 0)
		begin
		
		end
	
	//Machine State 2 - Perform Operation
	if(Stall[2] == 0)
		begin
		
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
			Operand[0] = OpOut[0];
			end
		else if	((Use[1][4:0] == RegLoc0[0]) && (Use[1][5] == 1))
			begin
			Operand[0] = OpOut[1];
			end
		else if	((Use[2][4:0] == RegLoc0[0]) && (Use[2][5] == 1))
			begin
			Operand[0] = OpOut[2];
			end
		else
			begin
			Operand[0] = R[RegLoc0[0]];
			end
		//RegLoc1
		if			((Use[0][4:0] == RegLoc1[0]) && (Use[0][5] == 1))
			begin
			Operand[1] = OpOut[0];
			end
		else if	((Use[1][4:0] == RegLoc1[0]) && (Use[1][5] == 1))
			begin
			Operand[1] = OpOut[1];
			end
		else if	((Use[2][4:0] == RegLoc1[0]) && (Use[2][5] == 1))
			begin
			Operand[1] = OpOut[2];
			end
		else
			begin
			Operand[1] = R[RegLoc1[0]];
			end
		//RegLoc2
		if			((Use[0][4:0] == RegLoc2[0]) && (Use[0][5] == 1))
			begin
			Operand[2] = OpOut[0];
			end
		else if	((Use[1][4:0] == RegLoc2[0]) && (Use[1][5] == 1))
			begin
			Operand[2] = OpOut[1];
			end
		else if	((Use[2][4:0] == RegLoc2[0]) && (Use[2][5] == 1))
			begin
			Operand[2] = OpOut[2];
			end
		else
			begin
			Operand[2] = R[RegLoc2[0]];
			end
		//All use flags are cleared
		Use[0][5] = 0;
		Use[1][5] = 0;
		Use[2][5] = 0;
		//Operations take in the values they need
		//Any registers to be modified must be marked
		case(Operation)
		NOP:		//Unused values need not be stated
			begin
			//No Operands
			//Nothing Used
			end
		JMP:
			begin
			OpIn[0] = Operand[0];
			OpIn[1] = Operand[1];
			OpIn[3] = Input;
			Stall[0] = 1;
			Stall[1] = 1;
			PC = PC + 1;
			Address = PC;
			end
		LD:
			begin
			OpIn[0] = Input;
			OpIn[1] = 0;
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			Stall[0] = 1;
			Stall[1] = 1;
			PC = PC + 1;
			if(Option[0] == 1)
				begin
				OpIn[1] = Operand[1];
				end
			Address = OpIn[0] + OpIn[1];
			end
		ST:
			begin
			OpIn[0] = Operand[0];
			OpIn[1] = 0;
			Stall[0] = 1;
			Stall[1] = 1;
			PC = PC + 1;
			if(Option[0] == 1)
				begin
				OpIn[1] = Operand[1];
				end
			Address = OpIn[0] + OpIn[1];
			end
		SET:
			begin
			OpIn[0] = Input;
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			Stall[0] = 1;
			Stall[1] = 1;
			PC = PC + 1;
			Address = PC;
			end
		CLR:
			begin
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			end
		ADD:
			begin
			OpIn[0] = Operand[0];
			OpIn[1] = Operand[1];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			if(Option[0] == 1)
				begin
				OpIn[2] = Input;
				Stall[0] = 1;
				Stall[1] = 1;
				PC = PC + 1;
				Address = PC;
				end
			end
		SUB:
			begin
			OpIn[0] = Operand[0];
			OpIn[1] = Operand[1];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			if(Option[0] == 1)
				begin
				OpIn[2] = Input;
				Stall[0] = 1;
				Stall[1] = 1;
				PC = PC + 1;
				Address = PC;
				end
			end
		MUL:
			begin
			OpIn[0] = Operand[0];
			OpIn[1] = Operand[1];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			if(Option[0] == 1)
				begin
				OpIn[2] = Input;
				Stall[0] = 1;
				Stall[1] = 1;
				PC = PC + 1;
				Address = PC;
				end
			end
		DIV:
			begin
			OpIn[0] = Operand[0];
			OpIn[1] = Operand[1];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			if(Option[0] == 1)
				begin
				OpIn[2] = Input;
				Stall[0] = 1;
				Stall[1] = 1;
				PC = PC + 1;
				Address = PC;
				end
			end
		AND:
			begin
			OpIn[0] = Operand[0];
			OpIn[1] = Operand[1];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			if(Option[0] == 1)
				begin
				OpIn[2] = Input;
				Stall[0] = 1;
				Stall[1] = 1;
				PC = PC + 1;
				Address = PC;
				end
			end
		NAND:
			begin
			OpIn[0] = Operand[0];
			OpIn[1] = Operand[1];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			if(Option[0] == 1)
				begin
				OpIn[2] = Input;
				Stall[0] = 1;
				Stall[1] = 1;
				PC = PC + 1;
				Address = PC;
				end
			end
		OR:
			begin
			OpIn[0] = Operand[0];
			OpIn[1] = Operand[1];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			if(Option[0] == 1)
				begin
				OpIn[2] = Input;
				Stall[0] = 1;
				Stall[1] = 1;
				PC = PC + 1;
				Address = PC;
				end
			end
		NOR:
			begin
			OpIn[0] = Operand[0];
			OpIn[1] = Operand[1];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			if(Option[0] == 1)
				begin
				OpIn[2] = Input;
				Stall[0] = 1;
				Stall[1] = 1;
				PC = PC + 1;
				Address = PC;
				end
			end
		XOR:
			begin
			OpIn[0] = Operand[0];
			OpIn[1] = Operand[1];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			if(Option[0] == 1)
				begin
				OpIn[2] = Input;
				Stall[0] = 1;
				Stall[1] = 1;
				PC = PC + 1;
				Address = PC;
				end
			end
		NOT:
			begin
			OpIn[0] = Operand[2];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			end
		SHR:
			begin
			OpIn[0] = Operand[2];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			end
		SHRC:
			begin
			OpIn[0] = Operand[2];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			end
		SHL:
			begin
			OpIn[0] = Operand[2];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			end
		SHLC:
			begin
			OpIn[0] = Operand[2];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			end
		RTR:
			begin
			OpIn[0] = Operand[2];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			end
		RTRC:
			begin
			OpIn[0] = Operand[2];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			end
		RTL:
			begin
			OpIn[0] = Operand[2];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			end
		RTLC:
			begin
			OpIn[0] = Operand[2];
			Use[0][5] = 1;
			Use[0][4:0] = RegLoc2[0];
			end
		endcase
	//Forward Values
	Option		[1]	=	Optio			[0];
	Condition	[1]	=	Condition	[0];
	RegLoc0		[1]	= 	RegLoc0		[0];
	RegLoc1		[1]	= 	RegLoc1		[0];
	RegLoc2		[1]	= 	RegLoc2		[0];
	Stall			[2]	=	0					;
	end
		
	
	//Machine State 0 - Fetch Instruction
	if(Stall[0] == 0)
		begin
		Operation	=	Input[31:24];
		Option[0]	=	Input[23]	;
		Condition[0]=	Input[22:15];
		RegLoc0[0]	=	Input[14:10];
		RegLoc1[0]	=	Input[09:05];
		RegLoc2[0]	=	Input[04:00];
		PC				=	PC + 1		;
		Address		=	PC				;
		Stall[1]		=	0				;
		end

	end
	
	