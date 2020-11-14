LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Instruction_Fetch is
	port ( 
	  		   jump_bool : in STD_LOGIC;
		     branch_bool : in STD_LOGIC;
		     clk : in STD_LOGIC;
		     reset : in STD_LOGIC;
	       branch_in : in STD_LOGIC_VECTOR (31 downto 0);
		     instr : out STD_LOGIC_VECTOR (31 downto 0)
		    );
end Instruction_Fetch;

architecture Structural of Instruction_Fetch is
  
	component program_counter is
		port ( 
		    		  reset : in STD_LOGIC;
			      clk : in STD_LOGIC;
		        input : in STD_LOGIC_VECTOR (31 downto 0);
			      output : out STD_LOGIC_VECTOR ( 31 downto 0)
			    );
	end component;
	
	component InstrMem32bit
		port ( 
		        address :in STD_LOGIC_VECTOR ( 31 downto 0);
				    Instr : out STD_LOGIC_VECTOR (31 downto 0)
			  	);
	end component;
	
	component Adder
		port ( 
		        num1 : in STD_LOGIC_VECTOR (31 downto 0);
			      num2 : in STD_LOGIC_VECTOR (31 downto 0);
			      result : out STD_LOGIC_VECTOR (31 downto 0)
			    );
	end component;
	
	component Left_Shift
		port ( 
		        input : in STD_LOGIC_VECTOR (31 downto 0);
		        output : out STD_LOGIC_VECTOR (31 downto 0)
		       );
	end component;
	
	component Mux
		port (
		  	    sel : in STD_LOGIC;
		       inputA : in STD_LOGIC_VECTOR (31 downto 0);
		       inputB : in STD_LOGIC_VECTOR (31 downto 0);
			     output : out STD_LOGIC_VECTOR (31 downto 0)
			    );
	end component;
	component ControlUnit is
	port ( 
	       OPcode : in STD_LOGIC_VECTOR( 5 downto 0);
		     RegDst : out STD_LOGIC;
		     ALUSrc : out STD_LOGIC;
		     MemToReg : out STD_LOGIC;
		     RegWrite : out STD_LOGIC;
		     MemRead  : out STD_LOGIC;
		     MemWrite : out STD_LOGIC;
		     Jump : out STD_LOGIC;
		     BranchNE : out STD_LOGIC;
		     Branch   : out STD_LOGIC;
		     ALUOp  : out STD_LOGIC_VECTOR( 1 downto 0)
		     );
	end
			    
--	component BinaryMUX is
--    Port ( inputA : in  STD_LOGIC_VECTOR (4 downto 0);
--           inputB : in  STD_LOGIC_VECTOR (4 downto 0);
--           sel : in  STD_LOGIC;
--           output : out  STD_LOGIC_VECTOR (4 downto 0));
		    
--	end component;
	
	signal pc_output :STD_LOGIC_VECTOR (31 downto 0);

	--constant pc_INCREMENT : STD_LOGIC_VECTOR (31 downto 0) := X"00000004";

	signal pc_adder_output :STD_LOGIC_VECTOR (31 downto 0);

	signal branch_shift_output : STD_LOGIC_VECTOR (31 downto 0);

	signal branch_adder_output : STD_LOGIC_VECTOR (31 downto 0);

	signal jump_shift_output : STD_LOGIC_VECTOR (31 downto 0);

	signal InstrMemOut : STD_LOGIC_VECTOR (31 downto 0);

	signal jump_32bit_signal : STD_LOGIC_VECTOR (31 downto 0);

	signal branchMux_output : STD_LOGIC_VECTOR (31 downto 0);

--	signal pc_new_value : STD_LOGIC_VECTOR (31 downto 0);

	SIGNAL jump : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	signal branch_bool : std_logic;
	signal Op : std_logic_vector( 5 downto 0);
	signal branchMuxand : std_logic;


	
begin
	
	ControlBranch : ControlUnit ( Op , RegDst ,ALUSrc, MemToReg , RegWrite , MemRead , MemWrite , Jump , BranchNE , branch_bool , ALUOp  );
	Op <= InstrMemOut ( 31 downto 26);
	branchMuxand <= branch_bool and ;
	BranchMux : Mux port map ( branchMuxand , pc_adder_output, branch_adder_output,  branchMux_output); 
	Branch_Adder : Adder port map ( branch_shift_output, pc_adder_output, branch_adder_output);
	
	Pc : program_counter port map ( reset , clk, branchMux_output , pc_output);
	
	InstrMem : InstrMem32bit port map (pc_output , InstrMemOut);
	
	instr <= InstrMemOut;

	pc_adder : Adder port map ( pc_output , X"00000001" , pc_adder_output );

	Shift_Branch : Left_Shift port map ( branch_in, branch_shift_output );

	

	jump <= "000000" & InstrMemOut(25 downto 0);
	Jump_Shift : Left_Shift PORT MAP( jump, jump_shift_output);

	jump_32bit_signal <= pc_adder_output (31 downto 28) & jump_shift_output(27 downto 0);

	

	--JumpMux : Mux port map (jump_bool, branchMux_output, jump_32bit_signal,  pc_new_value);
		
end Structural;