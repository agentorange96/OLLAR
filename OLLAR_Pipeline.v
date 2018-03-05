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
	
	//Define Operations
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
	
	