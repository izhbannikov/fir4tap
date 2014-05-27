-- Create Date:    08:06:14 05/27/2014 
-- Module Name:    DFF - Behavioral 
-- Project Name: FIR 4-tap filter
-- This code represents a D flip-flop (DFF), which can be used to emulate delays
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DFF is
	port(
      Clk :in std_logic;      -- Clock input
      D :in  signed(15 downto 0);      -- Data input from the MCM block.
		Q : out signed(15 downto 0)     --output connected to the adder
   );
end DFF;

architecture Behavioral of DFF is
	signal qt : signed(15 downto 0) := (others => '0');
begin

Q <= qt;

process(Clk)
begin
  if ( rising_edge(Clk) ) then
    qt <= D;
  end if;      
end process; 

end Behavioral;

