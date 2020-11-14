LIBRARY ieee  ; 
USE ieee.std_logic_1164.all  ; 
ENTITY instruction_fetch_tb  IS 
END ; 
 
ARCHITECTURE instruction_fetch_tb_arch OF instruction_fetch_tb IS
   COMPONENT Instruction_Fetch
    PORT(
         branch_in : IN  std_logic_vector(31 downto 0);
         jump_bool : IN  std_logic;
         branch_bool : IN  std_logic;
         clk : IN  std_logic;
         reset : IN  std_logic;
         instr : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal branch_in : std_logic_vector(31 downto 0) := (others => '0');
   signal jump_bool : std_logic := '0';
   signal branch_bool : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';

 	--Outputs
   signal instr : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Instruction_Fetch PORT MAP (
          branch_in => branch_in,
          jump_bool => jump_bool,
          branch_bool => branch_bool,
          clk => clk,
          reset => reset,
          instr => instr
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
   
 reset_process: process
	begin
		wait for clk_period/3;
		reset <= '0';
	wait;
	end process;

END;


