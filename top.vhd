----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Zhbannikov I.Y. 
-- 
-- Create Date:    08:01:54 05/27/2014 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
	port( Clk : in std_logic; --clock signal
			Xin : in signed(15 downto 0); --input signal
			Yout : out signed(15 downto 0)  --filter output
        );
end top;

architecture Behavioral of top is

component DFF is
   port(
      Clk :in std_logic;               -- Clock input
      D :in  signed(15 downto 0);      -- Data input from the MCM block.
		Q : out signed(15 downto 0)      --output connected to the adder
      
   );
end component; 
   
signal W0,W1,W2,W3 : signed(15 downto 0) := (others => '0'); -- 8-bit coefficients
signal MCM0,MCM1,MCM2,MCM3 : signed(31 downto 0) := (others => '0'); -- intermediate products
signal add_out1,add_out2,add_out3 : signed(15 downto 0) := (others => '0');
signal Q1,Q2,Q3 : signed(15 downto 0) := (others => '0');

begin

	--filter coefficient initializations.
	--W = [-2 -1 3 4].
	W0 <= to_signed(-2,16);
	W1 <= to_signed(-1,16);
	W2 <= to_signed(3,16);
	W3 <= to_signed(4,16);

	--Multiple constant multiplications.
	MCM3 <= (W3*Xin) srl 16;
	MCM2 <= (W2*Xin) srl 16;
	MCM1 <= (W1*Xin) srl 16;
	MCM0 <= (W0*Xin) srl 16;
	
	

	--adders
	add_out1 <= Q1 + MCM2(15 downto 0);
	add_out2 <= Q2 + MCM1(15 downto 0);
	add_out3 <= Q3 + MCM0(15 downto 0);

	--flipflops(for introducing a delay).
	dff1 : DFF port map(Clk,MCM3(15 downto 0),Q1);
	dff2 : DFF port map(Clk,add_out1,Q2);
	dff3 : DFF port map(Clk,add_out2,Q3);

	--an output produced at every positive edge of clock cycle.
	process(Clk)
	begin
    if(rising_edge(Clk)) then
        Yout <= add_out3;
    end if;
	end process;

end Behavioral;

