----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2025 08:35:08
-- Design Name: 
-- Module Name: Talker_str - Behavioral
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

entity Talker_str is
    Port ( clkt : in STD_LOGIC;
           resett : in STD_LOGIC;
           ack_in : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           req_out : out STD_LOGIC);
end Talker_str;

architecture Behavioral of Talker_str is

signal ack_sync : std_logic;

component synchronizer
port (
clk: in std_logic;
in_async : in std_logic ;
reset : in std_logic;
out_sync : out std_logic);
end component;

component talker_fsm
port (
ack_sync : in std_logic ;
clk: in std_logic;
reset : in std_logic ;
start : in std_logic ;
ready : out std_logic ;
req_out : out std_logic
);
end component;

begin

sync_unit : synchronizer
port map (clk=>clkt, reset=>resett , in_async=>ack_in,
out_sync=>ack_sync); 

fsm_unit : talker_fsm
port map (clk=>clkt, reset=>resett, start=>start, ack_sync=>ack_sync, ready=>ready,
req_out=>req_out) ;

end Behavioral;
