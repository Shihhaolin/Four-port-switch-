

  
// add print and type policies here
typedef enum {ANY, SINGLE, MULTICAST, BROADCAST } ptype_t;
typedef enum {HEX, DEC, BIN } pp_t;
// packet class
class packet;

  // add properties here
  local string name;

  rand bit [3:0] target;
  rand bit [7:0] data;
       bit [3:0] source;
       ptype_t ptype;
  

  //add constraint to declare data isn't equal to zero
  constraint ts_bits{(target & source)==4'b0;}
  constraint cs_target{target != 0;}
  // add constructor to set instance name and source by arguments and packet type


  function new(string name, int idt) ;
   this.name=name;
   source= 4'b0001 << idt;
   ptype=ANY;
  endfunction

  function string gettype();
    return ptype.name();// the name() method returns the string representation of the given enumeration value. 
  endfunction           

  function string getname();
   return name ;
  endfunction
 
 // add print with policy
  function void print(input pp_t pp=BIN);
   
   $display("name: ", name);
   $display("ptype: ", gettype());
   case(pp)
     HEX: $display("target %0h,source %0h, data %0h", target, source, data); 
     DEC: $display("target %0d,source %0d, data %0d", target, source, data); 
     BIN: $display("target %b,source %b, data %b", target, source, data);  
   endcase
  
  endfunction
endclass

class psingle extends packet;
   constraint sin_target{target inside{1,2,4,8};}

  function new(string name,int idt);
    super.new(name,idt);
    ptype=SINGLE;
  endfunction //new()
endclass //psingle extends packet

class pmulticast extends packet;
   constraint mul_target{target inside{3,[5:7],[9:14]};}
  
  function new(string name,int idt);
    super.new(name,idt);
    ptype=MULTICAST;  
  endfunction //new()
endclass //pmulticast extends packet

class pbroadcast extends packet;
    constraint ts_bits{}  
    constraint bro_target{target==15;}
  
  function new(string name,int idt);
    super.new(name,idt);
    ptype=BROADCAST;
  endfunction //new()
endclass //pbroadcast extends packet