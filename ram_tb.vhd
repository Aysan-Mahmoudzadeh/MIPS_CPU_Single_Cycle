LIBRARY ieee  ; 
USE ieee.NUMERIC_STD.all  ; 
USE ieee.std_logic_1164.all  ; 
ENTITY ram_tb  IS 
  GENERIC (
    ADDR_WIDTH  : INTEGER   := 32 ;  
    DATA_WIDTH  : INTEGER   := 32 ); 
END ; 
 
ARCHITECTURE ram_tb_arch OF ram_tb IS
  SIGNAL dout   :  std_logic_vector (DATA_WIDTH - 1 downto 0)  ; 
  SIGNAL address   :  std_logic_vector (ADDR_WIDTH - 1 downto 0) := (others => '1')  ; 
  SIGNAL clk   :  STD_LOGIC  ; 
  SIGNAL MemWrite   :  STD_LOGIC := '0' ; 
  SIGNAL din   :  std_logic_vector (DATA_WIDTH - 1 downto 0)  ; 
--  SIGNAL reset   :  STD_LOGIC  ; 
  SIGNAL MemRead   :  STD_LOGIC :='0' ; 
  COMPONENT Ram  
    GENERIC ( 
      ADDR_WIDTH  : INTEGER  := 32; 
      DATA_WIDTH  : INTEGER := 32 );  
    PORT ( 
         MemWrite : in STD_LOGIC;
		     MemRead : in STD_LOGIC;
	       clk : in STD_LOGIC;
	--       reset : in STD_LOGIC;
		     address : in STD_LOGIC_VECTOR( ADDR_WIDTH-1 downto 0);
		     din : in STD_LOGIC_VECTOR( DATA_WIDTH-1 downto 0);
		     dout : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
		     );
  END COMPONENT ; 
  
              
   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
BEGIN
  DUT  : Ram  
    GENERIC MAP ( 
      ADDR_WIDTH  => ADDR_WIDTH  ,
      DATA_WIDTH  => DATA_WIDTH   )
    PORT MAP ( 
      MemWrite   => MemWrite  ,
      MemRead   => MemRead ,
      
      clk   => clk  ,
   --   reset   => reset  ,
      address   => address  ,
      din   => din  ,
      dout   => dout  
         ) ;

 

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
    --  wait for 100 ns;	

		address <= X"00000000";
		MemWrite <= '1';
		din <= X"12345678";		
      wait for clk_period;
		--wait for clk_period;

		MemWrite <= '0';
		MemRead <= '1';            
 

		wait for clk_period;
		--wait for clk_period;
		
		address <= X"00000001";
		MemRead <= '0';
		MemWrite <= '1';
		din <= X"55555555";	
		wait for clk_period;
		--wait for clk_period;
		
		address <= X"00000000";
		MemWrite <= '0';
		MemRead <= '1';
		wait for clk_period;
		--wait for clk_period;
		
		address <= X"00000001";
		wait for clk_period;
		--wait for clk_period;
		
		address <= X"00000000";
		MemRead <= '0';
		MemWrite <= '1';
		din <= X"33333333";	
		wait for clk_period;
		
		MemWrite <= '0';
		MemRead <= '1';
		wait for clk_period;
		--wait for clk_period;
		
		

      -- insert stimulus here 

      wait;
   end process;
 
END ; 

