/*-----------------------------------------------------------------
File name     : switch_test.sv
Developers    : Brian Dickinson
Created       : 01/09/19
Description   : lab6_vc test module for 4-port switch VC with DUT instantiation
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

module top;

  // Check this import matches your VC package name
  import packet_pkg::*;

  logic clk = 1'b0;
  logic reset = 1'b0;

  // Declare a handle on your top level VC component class
   packet_vc pvc0, pvc1, pvc2, pvc3;

   always
    #10 clk <= ~clk;

  // 4-Port Switch interface instances for every port
  port_if port0(clk,reset);
  port_if port1(clk,reset);
  port_if port2(clk,reset);
  port_if port3(clk,reset);

  // DUT instantiation using interface ports
  switch_port sw1 (.port0, .port1, .port2, .port3, .clk, .reset);

   initial begin
    $timeformat(-9,2," ns",8);
    reset = 1'b0;
    @(negedge clk);
    reset = 1'b1;
    @(negedge clk);
    reset = 1'b0;

    // insert your VC instantiation, configuration and run code here:
    pvc0 =new("pvc0", null);//the top level should declare as null
    pvc0.configure(port0, 0);
    pvc1 =new("pvc1", null);
    pvc1.configure(port1, 1);
    pvc2 =new("pvc2", null);
    pvc2.configure(port2, 2);
    pvc3 =new("pvc3", null);
    pvc3.configure(port3, 4);
    
    fork
      pvc0.run(1);
      pvc1.run(1);
      pvc2.run(1);
      pvc3.run(1);
    join
    
    #500;

    $finish;
    end

 // Monitors to capture Switch output data
 initial begin : monitors
   fork
     port0.monitor(0);
     port1.monitor(1);
     port2.monitor(2);
     port3.monitor(3);
   join
 end

endmodule

