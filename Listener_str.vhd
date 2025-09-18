----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2025 08:35:08
-- Design Name: 
-- Module Name: Listener_str - Behavioral
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

entity Listener_str is
    Port ( clkl : in STD_LOGIC;
           resetl : in STD_LOGIC;
           req_in : in STD_LOGIC;
           ack_out : out STD_LOGIC);
end Listener_str;

architecture Behavioral of Listener_str is

signal req_sync : std_logic;

component synchronizer
port (
clk: in std_logic;
in_async : in std_logic ;
reset : in std_logic;
out_sync : out std_logic);
end component;

component listener_fsm
port (
clk: in std_logic;
req_sync : in std_logic ;
reset : in std_logic ;
ack_out : out std_logic
);
end component;

begin

sync_unit : synchronizer
port map (clk=>clkl, reset=>resetl , in_async=>req_in,
out_sync=>req_sync); 

fsm_unit : listener_fsm
port map (clk=>clkl, reset=>resetl, req_sync=>req_sync,
ack_out=>ack_out);

end Behavioral;
