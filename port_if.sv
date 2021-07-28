/*-----------------------------------------------------------------
File name     : port_if.sv
Developers    : Brian Dickinson
Created       : 01/08/19
Description   : lab6 4-Port Switch interface
Notes         : From the Cadence "Essential SystemVerilog for UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2019
-----------------------------------------------------------------*/

interface port_if(input bit clk,reset);

  import packet_pkg::*;

  // input port signals
  logic suspend_ip, valid_ip;
  logic [15:0] data_ip;
  // output port signals
  logic suspend_op, valid_op;
  logic [15:0] data_op;

  // reset for interface signals
  always@(posedge reset) begin 
    valid_ip = 1'b0;
    suspend_op = 1'b0;
  end

  // drive packet onto signals (for driver component)
  task drive_packet(input packet pkt);
     // packet drive
     @(negedge clk iff suspend_ip == 0);
     data_ip =  {pkt.data, pkt.source, pkt.target};
     valid_ip = 1'b1;
     @(negedge clk iff suspend_ip == 0);
     valid_ip = 1'b0;
     repeat (2) @(negedge clk);
  endtask

 // collect packet from signals (for monitor component)
 task collect_packet(output packet pkt);
   @(posedge valid_ip)
   pkt = new("pkt",0);
   {pkt.data, pkt.source, pkt.target} = data_ip;
    pkt.ptype = derive_type(pkt.target);
  endtask
    
 // monitor task for output signals
 task monitor(int portno);
   packet pkt;
   $display("MONITOR started for port %0d",portno);
   forever begin
     @(posedge valid_op)
     pkt = new("pkt",0);
     {pkt.data, pkt.source, pkt.target} = data_op;
     pkt.ptype = derive_type(pkt.target);
     $display("port%0d interface monitor: packet OUT @%t",portno, $time);
     pkt.print();
   end
 endtask

 // function to derive packet type from target address
 function ptype_t derive_type(logic[3:0] target);
   case (target) inside
     1,2,4,8: derive_type = SINGLE;
     15     : derive_type = BROADCAST;
     3,[5:7],[8:14]: derive_type = MULTICAST;
     0      : $display("ERROR: target 0 found in task monitor");
     default: $display("ERROR: unknown target %b found in task monitor",target);
   endcase
  endfunction
   
      
endinterface
