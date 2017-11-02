LIBRARY ieee  ; 
USE ieee.std_logic_1164.all  ; 
--USE ieee.std_logic_arith.all  ; 
USE ieee.STD_LOGIC_SIGNED.all  ;

package log2_package is 
  function Log2( a :in integer) return integer;
end log2_package;

package body log2_package is
  
  function Log2(a :in integer) return integer is 
  
  variable mem_a    : integer;
  variable result    : integer;
  
  begin
    mem_a :=a;
    result :=0;
    while mem_a >= 1 loop
      mem_a := mem_a/2;
      result := result +1; 
    end loop;
    return result;
  end Log2;
end package body;