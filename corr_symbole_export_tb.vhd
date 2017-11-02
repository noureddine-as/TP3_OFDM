LIBRARY ieee  ; 
LIBRARY work  ; 
library std;
use std.textio.ALL;

USE ieee.std_logic_1164.all  ; 
USE ieee.numeric_std.all;
USE work.log2_package.all  ;

ENTITY corr_symbole_export_tb  IS 
  GENERIC (
    gFFT_length  : POSITIVE   := 256 ;  
    gBits  : POSITIVE   := 14 ;  
    gGard_length  : POSITIVE   := 32;
    gMax_channel : POSITIVE := 2 ); 
END ; 
 
ARCHITECTURE exe2_tb_arch OF corr_symbole_export_tb IS
 
  
  SIGNAL Corr_symbole_result   :  std_logic_vector ((gBits + log2(gGard_length)-1) downto 0); -- 
  SIGNAL In_re,In_re0, In_im   :  std_logic_vector (gBits - 1 downto 0)  :=(others => '0'); 
  SIGNAL CLK   :  STD_LOGIC  ; 
  SIGNAL RSTn   :  STD_LOGIC  ; 
  SIGNAL Enable   :  STD_LOGIC  ; 
  signal Channel_number 		: std_logic_vector((log2(gMax_channel-1)-1) downto 0);

 
  COMPONENT corr_symbole  
    GENERIC ( 
      gFFT_length  : POSITIVE ; 
      gBits  : POSITIVE ; 
      gGard_length  : POSITIVE  );  
    PORT ( 
      Corr_symbole_result  : out std_logic_vector (gBits + log2(gGard_length)-1 downto 0) ; 
      In_re  : in std_logic_vector (gBits - 1 downto 0) ; 
      CLK  : in STD_LOGIC ;
      Enable : in std_logic; -- Global Enable 
      RSTn  : in STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : corr_symbole  
    GENERIC MAP ( 
      gFFT_length  => gFFT_length  ,
      gBits  => gBits  ,
      gGard_length  => gGard_length   )
    PORT MAP ( 
      Corr_symbole_result   => Corr_symbole_result  ,
      In_re   => In_re  ,
      CLK   => CLK  ,
      Enable => Enable, -- Global Enable
      RSTn   => RSTn   ) ; 
      
RSTn 		<= '0', '1' after 5 ns;
Enable <= '1';
      
P: process
begin
  clk <= '0';
  wait for 10 ns;
  clk <= '1';
  wait for 10 ns;
end process P;

LECTURE : process
  variable L,M	: LINE;
  file ENTREE	 : TEXT is in	"D:\TPs\TP_FPGA_PDSP\PDSP\TP3_OFDM\in_re5_chan2_data.txt"; 		--nom de fichier des échantillons
  file SORTIE	 : TEXT is out	"D:\TPs\TP_FPGA_PDSP\PDSP\TP3_OFDM\corr_symbol_out1.txt"; 
  variable A,B	: integer := 0;
 
begin
	wait for 10 ns;
	READLINE(ENTREE, L);
	READ(L,A);
	in_re 		<= std_logic_vector(TO_SIGNED(A,gBits)) after 2 ns;
	in_im		<= std_logic_vector(TO_SIGNED(-A,gBits)) after 2 ns;
	wait for 10 ns; 

	WRITE(M,to_INTEGER(SIGNED(Corr_symbole_result))	,LEFT, 6);
	WRITELINE(SORTIE, M);
	
end process LECTURE;

END ; 

