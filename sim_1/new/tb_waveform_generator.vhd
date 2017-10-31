library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_waveform_generator is end;

architecture behavioural of tb_waveform_generator is
    component waveform_generator is 
        port(
            clk: in std_logic;
            pwm_out: out std_logic;
            buttons: in std_logic_vector(4 downto 0);
            switches: in std_logic_vector(0 downto 0)
        );
    end component;
    
    constant clk_period: time := 1ns;
        
    signal clk: std_logic := '1';
    signal reset: std_logic := '1';
    signal amp_down: std_logic := '1';
    signal pwm_out: std_logic;
    signal buttons: std_logic_vector(4 downto 0) := (others => '0');
    signal switches: std_logic_vector(0 downto 0) := (others => '1');
begin
    buttons(0) <= reset;
    buttons(2) <= amp_down;
    
    
    uut: waveform_generator
        port map(
            clk => clk,
            pwm_out => pwm_out,
            buttons => buttons,
            switches => switches
        );

    reset <= '0' after 5*clk_period/2;
    clk <= not clk after clk_period/2;
end;
