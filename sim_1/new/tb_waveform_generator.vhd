library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_waveform_generator is end;

architecture Behavioral of tb_waveform_generator is
    component waveform_generator is 
        port(
            clk: in std_logic;
            pwm: out std_logic;
            buttons: in std_logic_vector(4 downto 0)
        );
    end component;
begin


end Behavioral;
