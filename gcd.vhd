-- -----------------------------------------------------------------------------
--
--  Title      :  FSMD implementation of GCD
--             :
--  Developers :  Jens Sparsø, Rasmus Bo Sørensen and Mathias Møller Bruhn
--           :
--  Purpose    :  This is a FSMD (finite state machine with datapath) 
--             :  implementation the GCD circuit
--             :
--  Revision   :  02203 fall 2019 v.5.0
--
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd is
  port (clk : in std_logic;             -- The clock signal.
    reset : in  std_logic;              -- Reset the module.
    req   : in  std_logic;              -- Input operand / start computation.
    AB    : in  unsigned(15 downto 0);  -- The two operands.
    ack   : out std_logic;              -- Computation is complete.
    C     : out unsigned(15 downto 0)); -- The result.
end gcd;

architecture fsmd of gcd is

  type state_type is (Idle, LoadA, LoadB, Check, NewA, NewB, LoadC); -- Input your own state names

  signal reg_a, next_reg_a, next_reg_b, reg_b : unsigned(15 downto 0);

  signal state, next_state : state_type;


begin

  -- Combinatoriel logic

  cl : process (req,ab,state,reg_a,reg_b, reset)
  begin
    case (state) is
        when Idle =>
            ack <= '0';
            next_reg_a <= x"0000";
            next_reg_b <= x"0000";
            C <= (others => 'Z');
            if req = '1' then
                next_state <= LoadA;
            end if;
        
        when LoadA =>
            if req = '1' then
                next_reg_a <= AB;
                ack <= '1';
            elsif req = '0' then
                next_state <= loadB;
                ack <= '0';
            end if;
            
        when LoadB =>
            if req <= '1' then
                next_reg_b <= AB;
                next_state <= check;
            end if;
            
        
        when Check =>
            if Reg_A = Reg_B then
                next_state <= LoadC;
            elsif Reg_A < Reg_B then
                next_state <= NewB;
            elsif Reg_b < reg_a then
                next_state <= NewA;
            end if;
        
        when NewA =>
            next_Reg_A <= Reg_A-Reg_B;
            next_state <= Check;
            
        when NewB =>
            next_Reg_B <= Reg_b-reg_a;
            next_state <= Check;
            
        when LoadC =>
            ack <= '1';
            C <= Reg_A;
            next_state <= idle; 
        
        when others =>
            next_state <= idle;   

    end case;
  end process cl;

  -- Registers

  seq : process (clk, reset)
  begin
    if reset = '1' then
        reg_a <= x"0000";
        reg_b <= x"0000";
        state <= idle;
    elsif clk' event and clk = '1' then
        reg_a <= next_reg_a;
        reg_b <= next_reg_b;
        state <= next_state;
    end if;

  end process seq;


end fsmd;
