

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




