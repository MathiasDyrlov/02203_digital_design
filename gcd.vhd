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

component Talker_str is
    Port ( clkt : in STD_LOGIC;
           resett : in STD_LOGIC;
           ack_in : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           req_out : out STD_LOGIC);
end component Talker_str;

component Listener_str is
    Port ( clkl : in STD_LOGIC;
           resetl : in STD_LOGIC;
           req_in : in STD_LOGIC;
           ack_out : out STD_LOGIC);
end component Listener_str;

  type state_type is (Idle, LoadA, LoadB, Check, NewA, NewB, LoadC, CZ); -- Input your own state names

  signal ack_sig, ready_sig, req_sig : STD_LOGIC;

  signal reg_a, next_reg_a, next_reg_b, reg_b : unsigned(15 downto 0);

  signal state, next_state : state_type;


begin

U0: talker_str port map(clkt => clk, resett => reset, ack_in => ack_sig, 
            start => req, ready => ready_sig,req_out => req_sig);

U1: Listener_str port map(clkl => clk, resetl => reset, req_in => req_sig, ack_out => ack_sig);

  -- Combinatoriel logic

  cl : process (req,ab,state,reg_a,reg_b,reset, ack_sig)
  begin
    case (state) is
        when Idle =>
            ack <= '0';
            if req = '1' then
                next_state <= LoadA;
            else 
                next_state <= next_state;
            end if;
        
        when LoadA =>
            ack <= ack_sig;
            if falling_edge(ack_sig) then
                next_state <= loadB;
            elsif req = '1' then
                next_reg_a <= AB;
            else 
                next_state <= next_state;
            end if;
            
        when LoadB =>
            next_Reg_B <= AB;
            next_state <= Check;
            
        
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
            next_state <= CZ;
        
        when CZ =>
            C <= (others => 'Z');
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
