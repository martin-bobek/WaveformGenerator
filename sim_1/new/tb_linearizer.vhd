library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_linearizer is end;

architecture behavioural of tb_linearizer is 
    component linearizer is
        port(
            clk: in std_logic;
            reset: in std_logic;
            freq_tick: in std_logic;
            up: in std_logic;
            down: in std_logic;
            tick_period: out std_logic_vector(12 downto 0)
        );
    end component;
    
    constant clk_period: time := 1ns;
        
    signal clk: std_logic := '1';
    signal reset: std_logic := '1'; 
    signal freq_tick: std_logic; 
    signal up: std_logic := '1';
    signal down: std_logic := '0';
    signal tick_period: std_logic_vector(12 downto 0);
begin

    uut: linearizer
        port map(
            clk => clk,
            reset => reset,
            freq_tick => freq_tick,
            up => up,
            down => down,
            tick_period => tick_period
        );
        
    update_proc: process begin
        freq_tick <= '1';
        wait for clk_period;
        freq_tick <= '0';
        wait for 3*clk_period;
    end process;
    
    reset <= '0' after 5*clk_period/2;
    clk <= not clk after clk_period/2;
end;