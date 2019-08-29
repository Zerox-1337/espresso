----------------------------------------------------------------------------------
-- Company: 
-- Create Date: 04/04/2017 12:36:38 PM
-- Design Name: Stream Cipher and Attack
-- Module Name: fFunc - Behavioral
-- Project Name: Cryptography 
-- Description: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity expressoFeedback is
  Port ( 
    iExpressofeedbackNfsrReg   : in STD_LOGIC_vector(255 downto 0);
    oExpressofeedbackVal   : out STD_LOGIC_vector(255 downto 0); -- Either NFSR or key/iv if new key.
    iExpressofeedbackNewkey: in STD_LOGIC;
    iExpressofeedbackKey: in STD_LOGIC_vector(127 downto 0); -- Key and IV
    iExpressofeedbackIv: in STD_LOGIC_vector(95 downto 0)
    );
end expressoFeedback;

architecture Behavioral of expressoFeedback is

begin
    process(iExpressofeedbackNewkey, iExpressofeedbackKey,iExpressofeedbackIv , iExpressofeedbackNfsrReg)
       begin
         if (iExpressofeedbackNewkey = '1') then
           oExpressofeedbackVal <= "01111111111111111111111111111111" & iExpressofeedbackIv & iExpressofeedbackKey; -- Original
           --oExpressofeedbackVal <= iExpressofeedbackKey & iExpressofeedbackIv & "01111111111111111111111111111111";
         else
          
          oExpressofeedbackVal <= iExpressofeedbackNfsrReg;
         
        end if;
    end process;
end Behavioral;
