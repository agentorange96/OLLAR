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

//This is the top-level entity for the OLLAR processor
//Memory, peripherals and cores may be defined here
module OLLAR (CLOCK_PIN, RESET_PIN);
	//Define Inputs
	input						CLOCK_PIN				;	//System Clock
	input						RESET_PIN				;	//Reset System
	
	//Define Outputs
	
	//Define Registers
	reg		[31:00]		Input		[3:0]			;	//Memory & Peripheral Inputs
	
	//Assign Wires
	wire		[31:00]		Output	[3:0]			;	//Memory & Peripheral Outputs
	wire		[31:00]		Address	[3:0]			;	//Memory & Peripheral Address
	wire		[31:00]		Write		[3:0]			;	//Memory & Peripheral Write Enable
	
	//Instantiate Cores
	OLLAR_Core	C0	(CLOCK_PIN, RESET_PIN, Input[0], Output[0], Address[0], Write[0]);
	OLLAR_Core	C1	(CLOCK_PIN, RESET_PIN, Input[1], Output[1], Address[1], Write[1]);
	OLLAR_Core	C2	(CLOCK_PIN, RESET_PIN, Input[2], Output[2], Address[2], Write[2]);
	OLLAR_Core	C3	(CLOCK_PIN, RESET_PIN, Input[3], Output[3], Address[3], Write[3]);
										
endmodule
