-- -----------------------------------------------------------------------------
--
--  Title      :  FSMD implementation of Binary GCD (Stein's algorithm)
--  Developers :  Adapted from Jens Sparsø et al.
--  Purpose    :  FSMD (finite state machine with datapath) implementation 
--               of the Binary GCD circuit (hardware-friendly).
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd is
  port (
    clk   : in  std_logic;               -- Clock signal
    reset : in  std_logic;               -- Reset
    req   : in  std_logic;               -- Input operand / start computation
    AB    : in  unsigned(15 downto 0);   -- Input operand
    ack   : out std_logic;               -- Computation complete
    C     : out unsigned(15 downto 0)    -- GCD result
  );
end gcd;

architecture fsmd of gcd is

  type state_type is (
    Idle, LoadA, LoadB, Req0, Check, 
    ShiftBothEven, ShiftAEven, ShiftBEven, Subtract, LoadC
  );

  signal state, next_state : state_type;
  signal reg_a, next_reg_a : unsigned(15 downto 0);
  signal reg_b, next_reg_b : unsigned(15 downto 0);
  signal factor2, next_factor2 : unsigned(15 downto 0); -- multiply by 2 when both even

begin

  -- Combinational logic
  cl : process (req, AB, state, reg_a, reg_b, factor2)
  begin
    next_state <= state;
    next_reg_a <= reg_a;
    next_reg_b <= reg_b;
    next_factor2 <= factor2;
    ack <= '0';
    C <= (others => '0'); -- default

    case state is

      when Idle =>
        if req = '1' then
          next_state <= LoadA;
        end if;

      when LoadA =>
        next_reg_a <= AB;
        ack <= '1';
        if req = '0' then
          next_state <= Req0;
        end if;

      when Req0 =>
        ack <= '0';
        if req = '1' then
          next_state <= LoadB;
        end if;

      when LoadB =>
        next_reg_b <= AB;
        next_factor2 <= (others => '0');  -- start factor2 at 0, treat as 2^0 = 1
        next_state <= Check;

      when Check =>
        if reg_a = reg_b then
          next_state <= LoadC;
        elsif reg_a(0) = '0' and reg_b(0) = '0' then
          next_state <= ShiftBothEven;
        elsif reg_a(0) = '0' then
          next_state <= ShiftAEven;
        elsif reg_b(0) = '0' then
          next_state <= ShiftBEven;
        else
          next_state <= Subtract;
        end if;

      when ShiftBothEven =>
        next_reg_a <= reg_a srl 1;
        next_reg_b <= reg_b srl 1;
        next_factor2 <= factor2 + 1; -- keep track of number of shifts (power of 2)
        next_state <= Check;

      when ShiftAEven =>
        next_reg_a <= reg_a srl 1;
        next_state <= Check;

      when ShiftBEven =>
        next_reg_b <= reg_b srl 1;
        next_state <= Check;

      when Subtract =>
        if reg_a > reg_b then
          next_reg_a <= reg_a - reg_b;
        else
          next_reg_b <= reg_b - reg_a;
        end if;
        next_state <= Check;

      when LoadC =>
        C <= reg_a sll to_integer(factor2); -- multiply by 2^factor2
        ack <= '1';
        if req = '0' then
          next_state <= Idle;
        end if;

    end case;
  end process cl;

  -- Sequential logic (register updates)
  seq : process (clk, reset)
  begin
    if reset = '1' then
      reg_a <= (others => '0');
      reg_b <= (others => '0');
      factor2 <= (others => '0');
      state <= Idle;
    elsif rising_edge(clk) then
      reg_a <= next_reg_a;
      reg_b <= next_reg_b;
      factor2 <= next_factor2;
      state <= next_state;
    end if;
  end process seq;

end fsmd;
