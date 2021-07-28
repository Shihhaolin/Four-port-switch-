/*-----------------------------------------------------------------
File name     : vc_test.sv
Developers    : Brian Dickinson
Created       : 01/08/19
Description   : Test module for 4-Port Switch VC - initial test without DUT
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

module packet_test;

  // Check import matches your package name`
  import packet_pkg::*;

  logic clk = 1'b0;
  logic reset = 1'b0;

  // 4-Port Switch interface instance
  port_if port0 (clk, reset);

  // Add your VC top level class handle
  packet_vc pvc;
  // Clock generator
  always
    #10 clk <= ~clk;

  initial begin
    // Hold suuspend low to allow data to be output
    port0.suspend_ip = 0;
    $timeformat(-9,2," ns",8);
    reset = 1'b0;
    @(negedge clk);
    reset = 1'b1;
    @(negedge clk);
    reset = 1'b0;

    // insert your VC instantiation, configuration and run code here:
    pvc =new("pvc", null);//the top level should declare as null
    pvc.configure(port0, 0);
    pvc.run(3);


    $finish;
  end

//--------------------validate functions for verification --------------------

function int countones (input logic[3:0] vec);
  countones = 0;
  foreach (vec [i])
    if (vec[i]) countones++;
endfunction

function void validate (input packet ap);
  int sco, tco;
  sco = countones(ap.source);
  tco = countones(ap.target);
  if (sco != 1) 
     $display("ERROR in source %h - no. bits set = %0d", ap.source, sco);
  if (ap.ptype == BROADCAST) begin
    if  (ap.target != 4'hf) 
       $display("ERROR: broadcast packet target is %h not 4'hf", ap.target);
  end
  else 
  begin
    if ( |(ap.source & ap.target) == 1'b1)   
      $display("ERROR: non-broadcast packet %s has same source %h and target %h bit set", ap.getname(), ap.source, ap.target);
    if ((ap.ptype == "single") & (tco != 1)) 
      $display("ERROR: single packet %s does not have only one bit set in target %h", ap.getname(), ap.target);
    if ((ap.ptype == "multicast") & (tco < 2)) 
      $display("ERROR: multicast packet %s does not have more than one bit set in target %h", ap.getname(), ap.target);
  end
endfunction
     
endmodule
   

