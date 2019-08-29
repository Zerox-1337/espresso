----------------------------------------------------------------------------------
-- Company: Lund University
-- Create Date: 04/04/2017 12:36:38 PM
-- Design Name: Stream Cipher and Attack
-- Module Name: grain top module - Structural
-- Project Name: Cryptography 
-- Description: 

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

----------------------------------------------------------------------------------

  entity expresso is
    Port ( 
        oExpressoY       : out STD_LOGIC_VECTOR (31 downto 0);
        oExpressoFinish  : out STD_LOGIC;
        iExpressoVal     : in STD_LOGIC_VECTOR (255 downto 0); -- Either the Nfsr reg or the key/iv if newkey
        oExpressoNfsrReg : out STD_LOGIC_VECTOR (255 downto 0);
        iExpressoAttack  : in STD_LOGIC; -- Used to get feedback from Y. 
        iExpressoStart   : in STD_LOGIC;
        iExpressoReset   : in STD_LOGIC;
        iExpressoClk     : in STD_LOGIC
        );
  end expresso;

----------------------------------------------------------------------------------

architecture structural of expresso is

----------------------------------------------------------------------------------


signal expressoNfsrReg : STD_LOGIC_vector(255 downto 0); -- Actual register for NFSR
signal expressoNfsrNext : STD_LOGIC_vector(255 downto 0);

signal expressoOutputCounterReg :  unsigned(2 downto 0); -- Counting how many bits store
signal expressoOutputCounterNext :  unsigned(2 downto 0);

signal expressoOutputReg :  std_logic_vector(31 downto 0); -- For storing 16 bits before sending them out. 
signal expressoOutputNext :  std_logic_vector(31 downto 0);




--signal expresso

signal expressoYFeedback    : STD_LOGIC_vector(31 downto 0); -- Input to F and G containing Y, Used during INIT & ATTACK stage.

signal LOW                 : STD_LOGIC; -- Useful for testing. (Can be removed when project finished)



----------------------------------------------------------------------------------

begin
----------------------------------------------------------------------------------
  seq: process(iExpressoClk, iExpressoReset)
    begin
        if (iExpressoReset = '1') then
            expressoNfsrReg <= (others=>'0');
            expressoOutputReg <= (others=>'0');
            expressoOutputCounterReg <= (others=>'0');
        elsif (rising_edge(iExpressoClk)) then
            expressoNfsrReg <= expressoNfsrNext;
            expressoOutputReg <= expressoOutputNext;
            expressoOutputCounterReg <= expressoOutputCounterNext;
        end if;
  end process;        

----------------------------------------------------------------------------------
  comb: process(expressoNfsrReg, expressoOutputCounterReg, expressoOutputReg, iExpressoAttack, iExpressoStart, iExpressoVal)
            
    variable Z, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8 : std_logic_vector(3 downto 0); 
    variable nfsr255Next, nfsr217Next : std_logic_vector(3 downto 0); 
    -- Used to store values temp to make the code more readable. Variables in this case will be wires.
    begin
        if (iExpressoStart = '1') then -- Circuit on
            oExpressoNfsrReg <= expressoNfsrReg; -- Always sends out the reg so we can get the value to do calculations with depending on key IV. 
            expressoNfsrNext <= "0000" & iExpressoVal(255 downto 4); -- Always use the value from expresso feedback as the next value default (for most bits)

            
          for I in 0 to 3 loop
              
              expressoNfsrNext(251 - I) <= iExpressoVal(252 + I) xor (iExpressoVal(42 + I) and iExpressoVal(83 + I)) xor iExpressoVal(8 + I);
              expressoNfsrNext(247 - I) <= iExpressoVal(248 + I) xor (iExpressoVal(44 + I) and iExpressoVal(102 + I)) xor iExpressoVal(40 + I);
              expressoNfsrNext(243 - I) <= iExpressoVal(244 + I) xor (iExpressoVal(43 + I) and iExpressoVal(118 + I)) xor iExpressoVal(103 + I);
              expressoNfsrNext(239 - I) <= iExpressoVal(240 + I) xor (iExpressoVal(46 + I) and iExpressoVal(141 + I)) xor iExpressoVal(117 + I);
              expressoNfsrNext(235 - I) <= iExpressoVal(236 + I) xor not( not( (iExpressoVal(67+ I) and iExpressoVal(90+ I)) ) 
              xor not( (iExpressoVal(110+ I) and iExpressoVal(137+ I)) ) );
              
              expressoNfsrNext(231 - I) <= iExpressoVal(232 + I) xor (iExpressoVal(50 + I) and iExpressoVal(159 + I)) xor iExpressoVal(189 + I);
               
              expressoNfsrNext(213 - I) <= iExpressoVal(214 + I) xor (iExpressoVal(4 + I) and iExpressoVal(45 + I));
              expressoNfsrNext(209 - I) <= iExpressoVal(210 + I) xor (iExpressoVal(6 + I) and iExpressoVal(64 + I));
              expressoNfsrNext(205 - I) <= iExpressoVal(206 + I) xor (iExpressoVal(5 + I) and iExpressoVal(80 + I));
              expressoNfsrNext(201 - I) <= iExpressoVal(202 + I) xor (iExpressoVal(8 + I) and iExpressoVal(103 + I));
              
              expressoNfsrNext(197 - I) <= iExpressoVal(198 + I) xor not( not( (iExpressoVal(29+ I) and iExpressoVal(52+ I)) ) 
              xor not( (iExpressoVal(72+ I) and iExpressoVal(99+ I)) ) );

              expressoNfsrNext(193 - I) <= iExpressoVal(194 + I) xor (iExpressoVal(12 + I) and iExpressoVal(121 + I));
              
              Z1(3-I) := iExpressoVal(80 + I) xor iExpressoVal(99 + I) xor iExpressoVal(137 + I) xor iExpressoVal(227 + I);
              Z2(3-I) := iExpressoVal(222 + I) xor iExpressoVal(187 + I) xor (iExpressoVal(243 + I) and iExpressoVal(217 + I));
              Z3(3-I) := (iExpressoVal(247 + I) and iExpressoVal(231 + I)) xor (iExpressoVal(213 + I) and iExpressoVal(235 + I));
            
              Z5(3-I) := (iExpressoVal(174 + I) and iExpressoVal(44 + I)) xor (iExpressoVal(164 + I) and iExpressoVal(29 + I));

              
              -- feedback
            end loop;
            -- Changed every nfsr255Next to just 2.
            
            
              Z4(3) := (iExpressoVal(255) and iExpressoVal(251)) xor (iExpressoVal(181) and iExpressoVal(239));
              Z6(3) := iExpressoVal(255) and iExpressoVal(247) and iExpressoVal(243) and iExpressoVal(213) and iExpressoVal(181) and iExpressoVal(174);
              Z7(3) := Z1(3) xor Z2(3) xor Z3(3) xor Z4(3);
              Z8(3) := Z5(3) xor Z6(3);
              Z(3) := Z7(3) xor Z8(3); -- Don't get scared, it's just wires.
              nfsr255Next(2) := iExpressoVal(0) xor (iExpressoVal(41) and iExpressoVal(70)) xor (iExpressoAttack and Z(3));
              nfsr217Next(2) := iExpressoVal(218) xor (iExpressoVal(3) and iExpressoVal(32)) xor (iExpressoAttack and Z(3));
              
              Z4(2) := (nfsr255Next(2) and iExpressoVal(252)) xor (iExpressoVal(182) and iExpressoVal(240));
              Z6(2) :=  nfsr255Next(2) and iExpressoVal(248) and iExpressoVal(244) and iExpressoVal(214) and iExpressoVal(182) and iExpressoVal(175);
              Z7(2) := Z1(2) xor Z2(2) xor Z3(2) xor Z4(2);
              Z8(2) := Z5(2) xor Z6(2);
              Z(2) := Z7(2) xor Z8(2); -- Don't get scared, it's just wires.
              nfsr255Next(1) := iExpressoVal(1) xor (iExpressoVal(42) and iExpressoVal(71)) xor (iExpressoAttack and Z(2)); 
              nfsr217Next(1) := iExpressoVal(219) xor (iExpressoVal(4) and iExpressoVal(33)) xor (iExpressoAttack and Z(2));
              
              Z4(1) := (nfsr255Next(1) and iExpressoVal(253)) xor (iExpressoVal(183) and iExpressoVal(241));
              Z6(1) :=  nfsr255Next(1) and iExpressoVal(249) and iExpressoVal(245) and iExpressoVal(215) and iExpressoVal(183) and iExpressoVal(176);
              Z7(1) := Z1(1) xor Z2(1) xor Z3(1) xor Z4(1);
              Z8(1) := Z5(1) xor Z6(1);
              Z(1) := Z7(1) xor Z8(1); -- Don't get scared, it's just wires.
              nfsr255Next(0) := iExpressoVal(2) xor (iExpressoVal(43) and iExpressoVal(72)) xor (iExpressoAttack and Z(1));                           
              nfsr217Next(0) := iExpressoVal(220) xor (iExpressoVal(5) and iExpressoVal(34)) xor (iExpressoAttack and Z(1));
              
              Z4(0) := (nfsr255Next(0) and iExpressoVal(254)) xor (iExpressoVal(184) and iExpressoVal(242));
              Z6(0) :=  nfsr255Next(0) and iExpressoVal(250) and iExpressoVal(246) and iExpressoVal(216) and iExpressoVal(184) and iExpressoVal(177);
              Z7(0) := Z1(0) xor Z2(0) xor Z3(0) xor Z4(0);
              Z8(0) := Z5(0) xor Z6(0);
              Z(0) := Z7(0) xor Z8(0); -- Don't get scared, it's just wires.
              
              expressoNfsrNext(255) <= nfsr255Next(2);  
              expressoNfsrNext(254) <= nfsr255Next(1);
              expressoNfsrNext(253) <= nfsr255Next(0);
              expressoNfsrNext(252) <= iExpressoVal(3) xor (iExpressoVal(44) and iExpressoVal(73)) xor (iExpressoAttack and Z(0));
              
              expressoNfsrNext(217) <= nfsr217Next(2);  
              expressoNfsrNext(216) <= nfsr217Next(1);
              expressoNfsrNext(215) <= nfsr217Next(0);
              expressoNfsrNext(214) <= iExpressoVal(221) xor (iExpressoVal(6) and iExpressoVal(35)) xor (iExpressoAttack and Z(0)); 
              
            
            expressoOutputNext <= expressoOutputReg(27 downto 0) & Z;
            
            if (expressoOutputCounterReg = "111") then -- When we get a new key. 
               expressoOutputCounterNext <= "000";
               oExpressoY <= expressoOutputReg(27 downto 0) & Z; 
               oExpressoFinish <= '1'; -- When 16 bit has been generated.
            else -- no new keys
                expressoOutputCounterNext <= expressoOutputCounterReg + 1;
                oExpressoY <= (others => '0'); -- Send nothing until the output is finished
                
                oExpressoFinish <= '0';
            end if;
        
        else -- Circuit off, reset
            expressoNfsrNext <= (others=>'0');
            expressoOutputNext <= (others=>'0');
            expressoOutputCounterNext <= (others=>'0');
            oExpressoNfsrReg <= (others=>'0');
            oExpressoFinish <= '0';
            oExpressoY <= (others => '0'); -- Send nothing until the output is finished
        
        end if;
  
  end process;
  

  
----------------------------------------------------------------------------------
  
end structural;