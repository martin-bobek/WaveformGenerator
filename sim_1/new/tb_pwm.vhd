library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_pwm is end;

architecture behavioural of tb_pwm is
    component pwm is
        generic(
            width: integer;
            cycle: integer
        );
        port(
            clk: in std_logic;
            reset: in std_logic;
            input: in std_logic_vector(width - 1 downto 0);
            output: out std_logic
        );
    end component;
    
    constant input_val: integer := 7;
    constant clk_period: time := 10ns;
    constant input: std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(input_val,4));
    
    signal clk: std_logic := '1';
    signal reset: std_logic := '1';
    signal output: std_logic;
begin
    uut: pwm 
        generic map(
            width => 4,
            cycle => 10
        )
        port map(
            clk => clk,
            reset => reset,
            input => input,
            output => output
        );      
    
    reset <= '0' after 5*clk_period/2;
    clk <= not clk after clk_period/2;
end;
