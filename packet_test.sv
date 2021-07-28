/*-----------------------------------------------------------------
File name     : packet_test.sv
Developers    : Brian Dickinson
Created       : 01/08/19
Description   : lab1  module for testing packet data
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

module packet_test;

import packet_pkg::*;

port_if port0(clk, reset);

packet_vc pvc;

logic clk=1'b0;
logic reset=1'b0;

always 
#5 clock=~clock;


  pvc =new("pvc", null);
  pcv.configure(port0, 0)
  pvc.run(3);
  


endmodule




