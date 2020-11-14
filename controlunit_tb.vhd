LIBRARY ieee  ; 
USE ieee.std_logic_1164.all  ; 
ENTITY controlunit_tb  IS 
END ; 
 
ARCHITECTURE controlunit_tb_arch OF controlunit_tb IS
  SIGNAL Jump   :  STD_LOGIC  ; 
  SIGNAL MemToReg   :  STD_LOGIC  ; 
  SIGNAL BranchNE   :  STD_LOGIC  ; 
  SIGNAL RegWrite   :  STD_LOGIC  ; 
  SIGNAL RegDst   :  STD_LOGIC  ; 
  SIGNAL ALUOp   :  std_logic_vector (1 downto 0)  ; 
  SIGNAL Branch   :  STD_LOGIC  ; 
  SIGNAL MemWrite   :  STD_LOGIC  ; 
  SIGNAL ALUSrc   :  STD_LOGIC  ; 
  SIGNAL OPcode   :  std_logic_vector (5 downto 0)  ; 
  SIGNAL MemRead   :  STD_LOGIC  ; 
  COMPONENT ControlUnit  
    PORT ( 
      Jump  : out STD_LOGIC ; 
      MemToReg  : out STD_LOGIC ; 
      BranchNE  : out STD_LOGIC ; 
      RegWrite  : out STD_LOGIC ; 
      RegDst  : out STD_LOGIC ; 
      ALUOp  : out std_logic_vector (1 downto 0) ; 
      Branch  : out STD_LOGIC ; 
      MemWrite  : out STD_LOGIC ; 
      ALUSrc  : out STD_LOGIC ; 
      OPcode  : in std_logic_vector (5 downto 0) :=(others =>'0'); 
      MemRead  : out STD_LOGIC ); 
  END COMPONENT ; 
BEGIN
  DUT  : ControlUnit  
    PORT MAP ( 
      Jump   => Jump  ,
      MemToReg   => MemToReg  ,
      BranchNE   => BranchNE  ,
      RegWrite   => RegWrite  ,
      RegDst   => RegDst  ,
      ALUOp   => ALUOp  ,
      Branch   => Branch  ,
      MemWrite   => MemWrite  ,
      ALUSrc   => ALUSrc  ,
      OPcode   => OPcode  ,
      MemRead   => MemRead   ) ; 
      
      stim_proc: process
      begin
        
        OPcode <= "000000"; --R_type
        wait for 10 ns;
        
        OPcode <= "100011"; --Load
        wait for 10 ns;
        
        OPcode <= "101011"; --Store
        wait for 10 ns;
        
        OPcode <= "000100"; --Branch
        wait for 10 ns;
        
        OPcode <= "000010"; --Jump
        wait for 10 ns;
        
        OPcode <= "000101"; --Branch Not Equal
        wait for 10 ns;
        
        OPcode <= "001000"; --ADDI
        wait for 10 ns;
        
        wait;
    end process;
END ; 

