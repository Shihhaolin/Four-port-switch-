class sequencer extends component_base;
  
  int portno;
  int ok;
   //deep clone (copy all of the constructor) 
  function new (string name, component_base parent);
   super.new(name, parent);//call the constructor in component_base.sv
  endfunction
  
  function void get_next_item(output packet pac);
   psingle psin;
   pmulticast pmul;
   pbroadcast pbro;

    randcase
      1:begin:single
        psin=new("psin", portno);
        ok=psin.randomize();//the result are only success or failure
        pac=psin;
        end
      1:begin:multicast
        pmul=new("pmul", portno);
        ok=pmul.randomize();
        pac=pmul;
        end
      1:begin:broadcast
        pbro=new("pbro", portno);
        ok=pbro.randomize();
        pac=pbro;
        end
    endcase
    
  endfunction

endclass //sequencer extends superClass