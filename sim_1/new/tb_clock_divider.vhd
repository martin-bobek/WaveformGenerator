library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clock_divider is end;

architecture behavioural of tb_clock_divider is
    component clock_divider is
        port(
            clk: in std_logic;
            reset: in std_logic;
            amp_tick: out std_logic
        );
    end component;
    
    constant clk_period: time := 2ns;
    
    signal clk: std_logic := '1';
    signal reset: std_logic := '1';
    signal amp_tick: std_logic;
begin
    uut: clock_divider
        port map(
            clk => clk,
            reset => reset,
            amp_tick => amp_tick
        );
    
    reset <= '0' after 5*clk_period/2;
    clk <= not clk after clk_period/2;
end;