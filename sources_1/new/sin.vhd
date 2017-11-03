library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sin is 
    port(
        clk: in std_logic;
        reset: in std_logic;
        tick: in std_logic;
        value: out std_logic_vector(6 downto 0)
    );
end;

architecture behavioural of sin is
    component lut_sin is
        port(
            input: in std_logic_vector(7 downto 0);
            output: out std_logic_vector(6 downto 0)
        );
    end component;
    
    constant period_full: unsigned(7 downto 0) := to_unsigned(199, 8);
    
    signal tick_counter: unsigned(7 downto 0);
begin
    lut: lut_sin
        port map(
            input => std_logic_vector(tick_counter),
            output => value
        );
    
    process(clk, reset) begin
        if (reset = '1') then
            tick_counter <= (others => '0');
        elsif rising_edge(clk) and (tick = '1') then
            if (tick_counter = 199) then
                tick_counter <= (others => '0');
            else
                tick_counter <= tick_counter + 1;
            end if;
        end if;
    end process;
end;
