----------------------------------------------------------------------------------
-- Company: Lund University
-- Create Date: 04/04/2017 12:36:38 PM
-- Design Name: Stream Cipher and Attack
-- Module Name: Expresso top module - Structural
-- Project Name: Cryptography 
-- Description: 

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

----------------------------------------------------------------------------------

  entity expressoTop is
    Port ( 
        oExpressotopY       : out STD_LOGIC_VECTOR (31 downto 0);
        oExpressotopFinish  : out STD_LOGIC;
        iExpressotopIv      : in STD_LOGIC_VECTOR (95 downto 0);
        iExpressotopKey     : in STD_LOGIC_VECTOR (127 downto 0);
        iExpressotopAttack  : in STD_LOGIC; -- Used to enter attack mode (init)
        iExpressotopStart   : in STD_LOGIC;
        iExpressotopReset   : in STD_LOGIC;
        iExpressotopClk     : in STD_LOGIC;
        iExpressotopNewkey  : in STD_LOGIC -- Resetting IV/KEY
        );
  end ExpressoTop;

----------------------------------------------------------------------------------

architecture structural of ExpressoTop is

----------------------------------------------------------------------------------
  component Expresso is
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
  end component;


  component expressoFeedback is
    Port ( 
        iExpressofeedbackNfsrReg   : in STD_LOGIC_vector(255 downto 0);
        oExpressofeedbackVal   : out STD_LOGIC_vector(255 downto 0); -- Either NFSR or key/iv if new key.
        iExpressofeedbackNewkey: in STD_LOGIC;
        iExpressofeedbackKey: in STD_LOGIC_vector(127 downto 0); -- Key and IV
        iExpressofeedbackIv: in STD_LOGIC_vector(95 downto 0)
        );  
  end component;





----------------------------------------------------------------------------------

-- Call it lfsrNewval or something. 


signal expressotopNfsrFeedback : STD_LOGIC_vector(255 downto 0); -- From Expresso to Expresso feedback
signal expressotopNfsrVal : STD_LOGIC_vector(255 downto 0); -- From expresso feedback to Expresso (contains the NFSR reg or KEY/IV)




----------------------------------------------------------------------------------

begin


  ExpressoInst: Expresso
    Port map ( 
        oExpressoY       => oExpressotopY,
        oExpressoFinish  => oExpressotopFinish, 
        iExpressoVal     => expressotopNfsrVal, -- From expresso feedback to Expresso (contains the NFSR reg or KEY/IV)
        oExpressoNfsrReg => expressotopNfsrFeedback, -- From Expresso to Expresso feedback
        iExpressoAttack  => iExpressotopAttack, -- Used to get feedback from Y. 
        iExpressoStart   => iExpressotopStart,
        iExpressoReset   => iExpressotopReset,
        iExpressoClk     => iExpressotopClk      
        );  
        
  expressoFeedInst: expressoFeedback
    Port map ( 
        iExpressofeedbackNfsrReg => expressotopNfsrFeedback, -- From expresso, contains register value
        oExpressofeedbackVal     => expressotopNfsrVal, -- Either NFSR or key/iv if new key.
        iExpressofeedbackNewkey  => iExpressotopNewkey,
        iExpressofeedbackKey     => iExpressotopKey, -- Key and IV
        iExpressofeedbackIv      => iExpressotopIv    
        );                                          
                                          
   
  
  
  -- In the attack Y will be used for MDM
  -- When not attack, the controller sends it out to the CPU. 
----------------------------------------------------------------------------------

end structural;

