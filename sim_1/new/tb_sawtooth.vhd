library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_sawtooth is end;

architecture behavioural of tb_sawtooth is
    component sawtooth is
        port(
            clk: in std_logic;
            reset: in std_logic;
            amplitude: in std_logic_vector(6 downto 0);
            tick: in std_logic;
            value: out std_logic_vector(6 downto 0)
        );
    end component;
    
    constant clk_period: time := 1ns;
    constant amp: integer := 80;
    
    signal clk: std_logic := '1';
    signal reset: std_logic := '1';
    signal tick: std_logic;
    signal value: std_logic_vector(6 downto 0);
begin
    uut: sawtooth
        port map(
            clk => clk,
            reset => reset,
            amplitude => std_logic_vector(to_unsigned(amp, 7)),
            tick => tick,
            value => value
        );
        
    update_proc: process begin
        tick <= '1';
        wait for clk_period;
        tick <= '0';
        wait for 4*clk_period;
    end process;
        
    reset <= '0' after 5*clk_period/2;
    clk <= not clk after clk_period/2;
end;