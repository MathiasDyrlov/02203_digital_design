----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2025 08:35:08
-- Design Name: 
-- Module Name: Listener_FSM - Behavioral
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

entity Listener_FSM is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           req_sync : in STD_LOGIC;
           ack_out : out STD_LOGIC);
end Listener_FSM;

architecture Behavioral of Listener_FSM is

type l_state_type is (s_ack0 , s_ack1) ;
signal state_reg , state_next : l_state_type;
signal ack_buf_reg, ack_buf_next : std_logic ; 

begin

process(clk, reset)
begin
    if reset = '1' then
        state_reg <= s_ack0;
        ack_buf_reg <= '0';
    elsif clk' event and clk = '1' then
        state_reg <= state_next;
        ack_buf_reg <= ack_buf_next;
    end if;
end process;

process(state_reg, req_sync)
begin
    state_next <= state_reg;
    case state_reg is
        when s_ack0 =>
            if req_sync = '1' then
                state_next <= s_ack1;
            end if;
        
        when s_ack1 =>
            if req_sync ='0' then
                state_next <= s_ack0;
            end if;
    end case;
end process;

process(state_next)
begin
    case state_next is
        when s_ack0 =>
            ack_buf_next <= '0';
        when s_ack1 =>
            ack_buf_next <= '1';
    end case;
end process;

ack_out <= ack_buf_reg;

end Behavioral;
