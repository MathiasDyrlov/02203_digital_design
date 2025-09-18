----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2025 09:20:33
-- Design Name: 
-- Module Name: Synchronizer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Synchronizer is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           in_async : in STD_LOGIC;
           out_sync : out STD_LOGIC);
end Synchronizer;

architecture Behavioral of Synchronizer is

signal meta_reg , sync_reg : std_logic ;
signal meta_next , sync_next : std_logic ;

begin

process(clk, reset)
begin
    if reset = '1' then
        meta_reg <= '0';
        sync_reg <= '0';
    elsif clk' event and clk = '1' then
        meta_reg <= meta_next;
        sync_reg <= sync_next;
    end if;
end process;

meta_next <= in_async;
sync_next <= meta_reg;

out_sync <= sync_reg;

end Behavioral;
