LIBRARY ieee  ; 
USE ieee.std_logic_arith.all  ; 
USE ieee.STD_LOGIC_SIGNED.all  ;
use ieee.std_logic_1164.all;        

USE work.log2_package.all;

-- LOG
-- my_fifo shifting --> OK
-- ABS substraction --> OK

-- ** TO BE VERIFIED **
-- Indexes of the beginning of arrays, for loops ...etc?
-- Can we use abs() function ?
-- 

entity corr_symbole is
  generic ( 
    gBits   :Positive := 14; -- Nb de bits d'un échantillon
    gFFT_length :Positive := 256; --Nb d'echantillons par symbole
    gGard_length : Positive := 32 -- Logueur de la garde
  
  );
  port (
    CLK : in STD_LOGIC;   -- Global clock
    Enable : in std_logic; -- Global Enable
    RSTn : in std_logic; -- Le reset global
    In_re : in std_logic_vector(gBits-1 downto 0); --La valeur réelle de l'échantillon à l'entrée
    Corr_symbole_result : out std_logic_vector(gBits + Log2(gGard_length) - 1 downto 0) -- la correlation symbole
   --diff : out std_logic_vector(gBits downto 0) --
  );
end corr_symbole;

architecture arch of corr_symbole is
  
  type FIFO is array(1 to gFFT_length) of std_logic_vector(gBits-1 downto 0);
  type DELAY_GUARD is array(1 to gGard_length) of std_logic_vector(gBits downto 0);
  
  signal my_fifo : FIFO;
  signal my_delay_guard : DELAY_GUARD;
  
  signal In_re_sr : std_logic_vector(gBits-1 downto 0); -- après le SR1
  signal s_in_retard : std_logic_vector(gBits - 1 downto 0);
  signal s_res_add : std_logic_vector(gBits downto 0);
  
  signal s_int0, s_int1 : std_logic_vector(gBits downto 0);
  
  signal s_int2, s_int3 : std_logic_vector((gBits + Log2(gGard_length) - 1) downto 0);

begin
  
-- Shift register
process(CLK, RSTn)  
begin
  if RSTn = '0' then
    my_fifo <=(others => (others =>  '0'));
  elsif rising_edge(CLK) then
    my_fifo(1) <= In_re;
    for i in 2 to (gFFT_length) loop
      my_fifo(i) <= my_fifo(i-1);
    end loop;
  end if;
end process;  
  
-- Soustraction)
--process(CLK, RSTn)  
--begin
--  if RSTn = '0' then
--     s_res_add <=(others =>  '0');
--  elsif rising_edge(CLK) then
--    -- abs might work but don't what really happens there
--     s_res_add <= abs((s_in_retard(gBits-1)&s_in_retard) - (In_re_sr(gBits-1)&In_re_sr));
--       s_res_add <= (s_in_retard(gBits-1)&s_in_retard) - (In_re_sr(gBits-1)&In_re_sr);
--  end if;
--end process;  

s_res_add <= (s_in_retard(gBits-1)&s_in_retard) - (In_re_sr(gBits-1)&In_re_sr);

-- Abs
process(CLK, RSTn)  
begin
  if RSTn = '0' then
     s_int0 <=(others =>  '0');
  elsif rising_edge(CLK) then
    -- abs might work but don't what really happens there
--     s_res_add <= abs((s_in_retard(gBits-1)&s_in_retard) - (In_re_sr(gBits-1)&In_re_sr));

      if s_res_add(gBits-1) = '1' then
        s_int0 <= not(s_res_add) + 1 ; -- 2's complement
      else
        s_int0 <= s_res_add;
      end if;

  end if;
end process; 

-- Delay Guard
process(CLK, RSTn)  
begin
    if RSTn = '0' then
        my_delay_guard <=(others => (others =>  '0'));
  elsif rising_edge(CLK) then
    my_delay_guard(1) <= s_int0;
    for i in 2 to gGard_length loop
      my_delay_guard(i) <= my_delay_guard(i-1);
    end loop;
end if;
end process; 

-- Op. 2
--process(CLK, RSTn)  
--begin
--  if RSTn = '0' then
--        s_int2 <=(others =>  '0');
--  elsif rising_edge(CLK) then
--    --s_res_add <= abs((s_in_retard(gBits-1)&s_in_retard) - (In_re(gBits-1)&In_re));
--    s_int2 <= (s_int0(gBits)&s_int0(gBits)&s_int0(gBits)&s_int0(gBits)&s_int0) - (s_int1(gBits)&s_int1(gBits)&s_int1(gBits)&s_int1(gBits)&s_int1) + s_int3;
--  end if;
--end process;  

s_int2 <= (s_int0(gBits)&s_int0(gBits)&s_int0(gBits)&s_int0(gBits)&s_int0) - (s_int1(gBits)&s_int1(gBits)&s_int1(gBits)&s_int1(gBits)&s_int1) + s_int3;


-- SR2 
process(CLK, RSTn)  
begin
  if RSTn = '0' then
        s_int3 <=(others =>  '0');
  elsif rising_edge(CLK) then
    s_int3 <= s_int2;
  end if;
end process; 
 
-- SR1
--process(CLK, RSTn)  
--begin
--  if RSTn = '0' then
--        In_re_sr <=(others =>  '0');
--  elsif rising_edge(CLK) then
--    In_re_sr <= In_Re;
--  end if;
--end process; 
    In_re_sr <= In_Re;

s_in_retard <= my_fifo(gFFT_length);
s_int1 <= my_delay_guard(gGard_length);
--s_int0 <= s_res_add;

Corr_symbole_result <= s_int3;

end arch;



