class packet_vc extends component_base;
  agent age;
  
   function new (string name, component_base parent);
   super.new(name, parent);
   age =new("age", this);
   endfunction
   
   //virtual interface is passed ti=o the driver and monitor via hierachical pathname
   //likewise, portno is passed to sequencer and monitor
   function void configure(virtual interface port_if vif,int portno);
     age.drv.vif=vif;
     age.mon.vif=vif;
     age.seq.portno=portno;
     age.mon.portno=portno;
   endfunction
  
  task run(int runs);
  fork
   age.mon.run();
  join_none
   age.drv.run(runs);
   
  endtask

endclass //packet_vc extends compoment_base