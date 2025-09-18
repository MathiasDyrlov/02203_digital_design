----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2025 08:35:08
-- Design Name: 
-- Module Name: Talker_FSM - Behavioral
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

entity Talker_FSM is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ack_sync : in STD_LOGIC;
           ready : out STD_LOGIC;
           req_out : out STD_LOGIC);
end Talker_FSM;

architecture Behavioral of Talker_FSM is

type t_state_type is (idle, s_req1 , s_req0) ;
signal state_reg , state_next : t_state_type ;
signal req_buf_reg, req_buf_next : std_logic ;

begin

process(clk, reset)
begin
    if reset = '1' then
        state_reg <= idle;
        req_buf_reg <= '0';
    elsif clk' event and clk = '1' then
        state_reg <= state_next;
        req_buf_reg <= req_buf_next;
    end if;
end process;

process(state_reg, start, ack_sync)
begin
    ready <= '0';
    state_next <= state_reg;
    case state_reg is
        when idle =>
            if start = '1' then
                state_next <= s_req1;
            end if;
            ready <= '1';
            
        when s_req1 =>
            if ack_sync = '1' then
                state_next <= s_req0;
            end if;
        
        when s_req0 =>
            if ack_sync ='0' then
                state_next <= idle;
            end if;
    end case;
end process;

process(state_next)
begin
    case state_next is
        when idle =>
            req_buf_next <= '0';
        when s_req1 =>
            req_buf_next <= '1';
        when s_req0 =>
            req_buf_next <= '0';
    end case;
end process;

req_out <= req_buf_reg;

end Behavioral;
