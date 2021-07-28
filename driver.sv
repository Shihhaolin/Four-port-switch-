class driver extends component_base;
   virtual interface port_if vif;
   packet pkt;
   sequencer seq;

  //deep clone (copy all of the constructor) 
  function new (string name, component_base parent);
   super.new(name, parent);
  endfunction

task run(int runs);
  repeat(runs) begin
   seq.get_next_item(pkt);
   pkt.print();
   vif.drive_packet(pkt);
  end
endtask //runsr 

endclass