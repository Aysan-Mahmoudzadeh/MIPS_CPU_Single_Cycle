library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity SingleCycleCPU is
	port( 
	       clk : in STD_LOGIC;
			   reset : in STD_LOGIC
			--   instruction : out STD_LOGIC_VECTOR(31 downto 0)
			 );
end SingleCycleCPU;

architecture Structural of SingleCycleCPU is
 
--	component Instruction_Fetch is
--		port ( 
--		        jump_bool : in STD_LOGIC;
--		        branch_bool : in STD_LOGIC;
--		        clk : in STD_LOGIC;
--		        reset : in STD_LOGIC;		  
--		        branch_in : in STD_LOGIC_VECTOR (31 downto 0);
--		        instr : out STD_LOGIC_VECTOR (31 downto 0)
--		      );
 --   end component;
	

	component ControlUnit is
		port ( 
	       OPcode : in STD_LOGIC_VECTOR( 5 downto 0);
		     RegDst : out STD_LOGIC;
		     ALUSrc : out STD_LOGIC;
		     MemToReg : out STD_LOGIC;
		     RegWrite : out STD_LOGIC;
		     MemRead  : out STD_LOGIC;
		     MemWrite : out STD_LOGIC;
		--     Jump : out STD_LOGIC;
		     BranchNE : out STD_LOGIC;
		     Branch   : out STD_LOGIC;
		     ALUOp  : out STD_LOGIC_VECTOR( 1 downto 0)
		     );
	end component;
	
	component ALUCtrl is
		port (
		       ALUOp : in STD_LOGIC_VECTOR ( 1 downto 0);
		       Instr : in STD_LOGIC_VECTOR ( 5 downto 0);
		       ALUCtr : out STD_LOGIC_VECTOR ( 2 downto 0)
		       );
    end component;
	
	component ALU is
	port ( Data1 : in STD_LOGIC_VECTOR ( 31 downto 0);
		   Data2 : in STD_LOGIC_VECTOR ( 31 downto 0);
		   --Sign_Extended : in STD_LOGIC_VECTOR ( 31 downto 0);
		   --ALUSrc : in STD_LOGIC;
		   Zero : out STD_LOGIC;
		   ALU_Result : out STD_LOGIC_VECTOR ( 31 downto 0);
		   ALUCtr : in STD_LOGIC_VECTOR ( 2 downto 0)
		   ); --and/or/nand/mul/...
    end component;
	
	component Sign_Extend is
	port ( 
	       input : in STD_LOGIC_VECTOR (15 downto 0);
	       output : out STD_LOGIC_VECTOR (31 downto 0)
	      );
    end component;
	
	component Ram is
		generic (
			       	ADDR_WIDTH : integer := 32;
			       	DATA_WIDTH : integer := 32
			       );
	
	port (  
	       MemWrite : in STD_LOGIC;
		     MemRead : in STD_LOGIC;
	       clk : in STD_LOGIC;
	       reset : in STD_LOGIC;
		     address : in STD_LOGIC_VECTOR( ADDR_WIDTH-1 downto 0);
		     din : in STD_LOGIC_VECTOR( DATA_WIDTH-1 downto 0);
		     dout : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)
		   
		   );
    end component;
    
    component Register_File IS
  PORT(
	       clk, reset, reg_write : IN STD_LOGIC; 
	       write1, read1, read2 : IN STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	       write_data : IN STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	       read_data1, read_data2 : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 )
      );
END component;

	component Mux is
		port (
		        InputA , InputB : in STD_LOGIC_VECTOR(31 downto 0);
				    sel : in STD_LOGIC;
				    Output : out std_logic_vector(31 downto 0)
				  );
	end component;
	
	
	component	BinaryMUX is
    Port ( inputA : in  STD_LOGIC_VECTOR (4 downto 0);
           inputB : in  STD_LOGIC_VECTOR (4 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (4 downto 0));
    end component;
	
	component program_counter is
		port ( 
		    	reset : in STD_LOGIC;
			    clk : in STD_LOGIC;
		        input : in STD_LOGIC_VECTOR (31 downto 0);
			    output : out STD_LOGIC_VECTOR ( 31 downto 0)
			    );
	end component;
	
	component InstrMem32bit is
		port ( 
		        address :in STD_LOGIC_VECTOR ( 31 downto 0);
				    Instr : out STD_LOGIC_VECTOR (31 downto 0)
			  	);
	end component;
	

	
	component Adder is
		port ( 
		        num1 : in STD_LOGIC_VECTOR (31 downto 0);
			      num2 : in STD_LOGIC_VECTOR (31 downto 0);
			      result : out STD_LOGIC_VECTOR (31 downto 0)
			    );
	end component;
	
	component Left_Shift is
		port ( 
		        input : in STD_LOGIC_VECTOR (31 downto 0);
		        output : out STD_LOGIC_VECTOR (31 downto 0)
		       );
	end component;
	

	
--	signal instr_alu : std_logic_vector( 31 downto 0);
--	signal ALUinstr :std_logic_vector( 15 downto 0);
	
--	signal pc_output :STD_LOGIC_VECTOR (31 downto 0);

	--constant pc_INCREMENT : STD_LOGIC_VECTOR (31 downto 0) := X"00000004";

--	signal pc_adder_output :STD_LOGIC_VECTOR (31 downto 0);
	
	--Fetch signal
--	signal jump_bool : std_logic;
	signal branch_bool : std_logic;
---	signal instr : std_logic_vector(31 downto 0);
	
	--ControlUnit signal
	signal OPcode : STD_LOGIC_VECTOR( 5 downto 0);
	signal ALUOp  : STD_LOGIC_VECTOR( 1 downto 0);
	signal RegDst : STD_LOGIC;
	signal ALUSrc : STD_LOGIC;
	signal MemToReg : STD_LOGIC;
	signal RegWrite : STD_LOGIC;
	signal MemRead  : STD_LOGIC;
	signal MemWrite : STD_LOGIC;
	signal branchFromCtrlUnit : std_logic;
	signal branchNEFromCtrlUnit : std_logic;
	
	
	--ALU Control signal
	signal  ALUCtr : std_logic_vector(2 downto 0);
--	signal instrALUC : std_logic_vector(5 downto 0);
	
	--ALU signal
	signal RegData1 : std_logic_vector(31 downto 0);
	signal RegData2 : std_logic_vector(31 downto 0);
	---signal Sign_Extended : std_logic_vector(31 downto 0);
	signal Zero : std_logic;
	signal ALU_Result : std_logic_vector(31 downto 0);
--	signal branch1 : std_logic;
--	signal branch2 :std_logic;
	
	--RAM signal
	signal RamDataOut : std_logic_vector(31 downto 0);

-----Sign_Extended
--	signal instr_sign_Extended : std_logic_vector ( 15 downto 0);
	signal Sign_Extended_Output : std_logic_vector(31 downto 0);
--Register File signals
	signal WriteData : std_logic_vector(31 downto 0);
	signal WriteAddr : std_logic_vector(4 downto 0);
	
	--signal Mux
	signal MuxAlu_out : std_logic_vector( 31 downto 0);
--	signal instr_ALU_ctr : std_logic_vector ( 5 downto 0);

signal pc_output :STD_LOGIC_VECTOR (31 downto 0);

	--constant pc_INCREMENT : STD_LOGIC_VECTOR (31 downto 0) := X"00000004";

	signal pc_adder_output :STD_LOGIC_VECTOR (31 downto 0);

--	signal branch_shift_output : STD_LOGIC_VECTOR (31 downto 0);

	signal branch_adder_output : STD_LOGIC_VECTOR (31 downto 0);

--	signal jump_shift_output : STD_LOGIC_VECTOR (31 downto 0);

	signal InstrMemOut : STD_LOGIC_VECTOR (31 downto 0);

--	signal jump_32bit_signal : STD_LOGIC_VECTOR (31 downto 0);

	signal branchMux_output : STD_LOGIC_VECTOR (31 downto 0);

--	signal pc_new_value : STD_LOGIC_VECTOR (31 downto 0);

--	SIGNAL jump : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
--	signal Op : std_logic_vector( 5 downto 0);
--	signal branchMuxand : std_logic;
	
	
begin
	Pc : program_counter port map ( reset , clk, branchMux_output , pc_output);
	BranchMux : Mux port map ( pc_adder_output, branch_adder_output,  branch_bool ,  branchMux_output);
	InstrMem : InstrMem32bit port map (pc_output , InstrMemOut);
	pc_adder : Adder port map ( pc_output , X"00000001" , pc_adder_output );
	Sign_Extended1 : Sign_Extend port map (InstrMemOut(15 downto 0) , Sign_Extended_Output);
	OPcode <= InstrMemOut(31 downto 26);
	CtrlUnit : ControlUnit port map ( OPcode  , RegDst ,ALUSrc , MemToReg , RegWrite , MemRead , MemWrite  , branchNEFromctrlUnit , branchFromctrlUnit , ALUOP);
	branch_bool <= (branchFromCtrlUnit AND Zero) Or (branchNEFromCtrlUnit AND not Zero);
	Branch_Adder : Adder port map (  Sign_Extended_Output, pc_adder_output, branch_adder_output);
	MuxReg : BinaryMUX port map(InstrMemOut(20 downto 16),InstrMemOut(15 downto 11),RegDst, WriteAddr);
   	RegFile : Register_File port map( clk, reset, RegWrite , WriteAddr ,InstrMemOut(25 downto 21)  , InstrMemOut(20 downto 16), WriteData, RegData1,RegData2 );
	MuxAlu : Mux port map ( RegData2, Sign_Extended_Output, ALUSrc, MuxAlu_out);
	ALUControl : ALUCtrl port map ( ALUOp , InstrMemOut(5 downto 0) , ALUCtr);
	ALUMain : ALU port map ( RegData1, MuxAlu_out, Zero, ALU_Result, ALUCtr);
	Ram1 : Ram port map ( MemWrite, MemRead , clk , reset , ALU_Result, RegData2, RamDataOut);
	MuxRam : Mux port map ( ALU_Result, RamDataOut, MemToReg, WriteData);
end Structural;	
	
--	InstrFetch : Instruction_Fetch port map (jump_bool, branch_bool, clk, reset, Sign_Extended_Output, instr);
	
	  
	  
	--ControlBranch : ControlUnit ( Op , RegDst ,ALUSrc, MemToReg , RegWrite , MemRead , MemWrite , Jump , BranchNE , branch_bool , ALUOp  );
	--Op <= InstrMemOut ( 31 downto 26);
	
	 
	--Shift_Branch : Left_Shift port map ( Sign_Extended_Output, branch_shift_output );
--	Branch_Adder : Adder port map ( branch_shift_output, pc_adder_output, branch_adder_output);
	
	
	
	

	
	

	
	
	
	
	
	
	
	  
		
		
--	jump <= "000000" & InstrMemOut(25 downto 0);
--	Jump_Shift : Left_Shift PORT MAP( jump, jump_shift_output);

--	jump_32bit_signal <= pc_adder_output (31 downto 28) & jump_shift_output(27 downto 0);
	
		
	
		
		  
		
		--WriteData <= RamDataOut when MemToReg ='1' else
		--		ALU_Result;
	
		
	  
	  
--	  instruction <= instr;
	  


		
--		Pc : program_counter port map ( reset , clk,pc_adder_output , pc_output);	
--		InstrMem32bit_out : InstrMem32bit( pc_output , instr_alu );
--		ALUinstr <= instr_alu ( 15 downto 0);
		
--		instr_ALU_ctr <= ALUinstr ( 5 downto 0);
		
		

		
--	instrALUC <= instr( 5 downto 0);
	
	
  
	
--	ALUMain : ALU port map ( RegData1, RegData2, Sign_Extended_Output, ALUSrc, Zero, ALU_Result, ALUCtr);
	
--		branch1 <= branchFromCtrlUnit;
--		branch2 <= branchNEFromCtrlUnit;
--		branch_bool <= (branch1 AND Zero) Or (branch2 AND not Zero);

	--  WriteAddr <= instr(20 downto 16) when RegDst = '0' else
	  --            instr(15 downto 11);
	  		-- RegFile : RegisterFile PORT MAP(WriteData, clk, reset, instr(25 downto 21) , RegData1, instr(20 downto 16), RegData2, WriteAddr, RegWrite);

	   
	
	
	