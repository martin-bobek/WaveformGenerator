library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_triangle is end;

architecture behavioural of tb_triangle is
    component triangle is
        port(
            clk: in std_logic;
            reset: in std_logic;
            value: out std_logic_vector(6 downto 0);
            update: in std_logic;
            amplitude: in std_logic_vector(6 downto 0);
            tick_period: in std_logic_vector(12 downto 0)
        );
    end component;
    
    constant clk_period: time := 1ns;
    constant amp: integer := 100;
    constant period: integer := 5;
    
    signal clk: std_logic := '1';
    signal reset: std_logic := '1';
    signal update: std_logic;
    signal value: std_logic_vector(6 downto 0);
begin
    uut: triangle
        port map(
            clk => clk,
            reset => reset,
            value => value,
            update => update,
            amplitude => std_logic_vector(to_unsigned(amp, 7)),
            tick_period => std_logic_vector(to_unsigned(period, 13))
        );
        
    update_proc: process begin
        update <= '1';
        wait for clk_period;
        update <= '0';
        wait for 3*clk_period;
    end process;
        
    reset <= '0' after 5*clk_period/2;
    clk <= not clk after clk_period/2;
end;