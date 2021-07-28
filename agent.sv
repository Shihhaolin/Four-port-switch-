class agent extends component_base;
    sequencer seq;
    driver    drv;
    monitor   mon;
  
  
  function new (string name, component_base parent);
   super.new(name, parent);
   drv =new("drv", this);
   seq =new("seq", this);
   mon =new("mon", this);
   drv.seq =seq;
  endfunction


endclass //agent extends component_base