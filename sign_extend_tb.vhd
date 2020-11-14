LIBRARY ieee  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
ENTITY sign_extend_tb  IS 
END ; 
 
ARCHITECTURE sign_extend_tb_arch OF sign_extend_tb IS
  --Input
  SIGNAL input   :  std_logic_vector (15 downto 0) :=(others =>'0');
  --Output 
  SIGNAL output   :  std_logic_vector (31 downto 0)  ; 
  COMPONENT Sign_Extend  
    PORT ( 
      input  : in std_logic_vector (15 downto 0) ; 
      output  : out std_logic_vector (31 downto 0) ); 
  END COMPONENT ; 
BEGIN
  DUT  : Sign_Extend  
    PORT MAP ( 
      input   => input  ,
      output   => output   ) ; 
      
      stim_proc: process
    begin
      Input <= X"0001";
      wait for 10 ns;
      
      Input <= X"8000";
      wait for 10 ns;
      
      Input <= X"00AB";
      wait for 10 ns;
      
      Input <= X"FFFA";
      wait for 10 ns;
      
      wait;
    end process;
END ; 

