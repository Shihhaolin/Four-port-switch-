class monitor extends component_base;
  virtual interface port_if vif;
  packet pkt;
  int portno;

  function new (string name, component_base parent);
    super.new(name, parent);
  endfunction

task run();
forever begin

vif.collect_packet(pkt);
$display("monitor @%0s", pathname());
pkt.print();
end
endtask

endclass //monitor extends component_base