library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity waveform_generator is 
    port(
        clk: in std_logic;
        pwm: out std_logic;
        buttons: in std_logic_vector(4 downto 0)
    );
end;

architecture behavioural of waveform_generator is

begin

end;
