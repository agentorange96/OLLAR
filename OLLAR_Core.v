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

//This file defines a single core for the OLLAR processor
module OLLAR (CLOCK_PIN, RESET_PIN, INPUT_PIN, OUTPUT_PIN, ADDRESS_PIN, WRITE_PIN);
	//Define Inputs
	input						CLOCK_PIN				;	//System Clock
	input						RESET_PIN				;	//Reset System
	input			[31:00]	INPUT_PIN				;	//Memory & Peripheral Input
	
	//Define Outputs
	output		[31:00]	OUTPUT_PIN				;	//Memory & Peripheral Output
	output		[31:00]	ADDRESS_PIN				;	//Memory & Peripheral Address
	output					WRITE_PIN				;	//Memory & Peripheral Write Enable
	
	//Define Registers
	reg			[31:00]	R		[31:00]			;	//General Purpose Registers
	reg			[31:00]	PC							;	//Program Counter
	reg			[31:00]	IR		[03:00]			;	//Instruction Register

	//Define Operations
	parameter	[08:00]	NOP	=8'b00000000	;	//Do nothing
	parameter	[08:00]	JMP	=8'b00000001	;	//Jump to address
	parameter	[08:00]	LD		=8'b00000010	;	//Load value into register
	parameter	[08:00]	ST		=8'b00000011	;	//Store value from register
	parameter	[08:00]	SET	=8'b00000100	;	//Set register to value in next word
	parameter	[08:00]	CLR	=8'b00000101	;	//Clear register
	parameter	[08:00]	ADD	=8'b01000000	;	//Addition
	
	//Instantiate Pipeline
	OLLAR_Pipeline	Pipeline	();
	
endmodule