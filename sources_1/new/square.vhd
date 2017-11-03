library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity square is
    port(
        clk: in std_logic;
        reset: in std_logic;
        amplitude: in std_logic_vector(6 downto 0);
        tick: in std_logic;
        value: out std_logic_vector(6 downto 0)
    );
end;

architecture behavioural of square is
    constant period_half: unsigned(7 downto 0) := to_unsigned(99, 8);
    constant period_full: unsigned(7 downto 0) := to_unsigned(199, 8);

    signal tick_counter: unsigned(7 downto 0);
begin

    process(clk, reset) begin
        if (reset = '1') then
            value <= (others => '0');
            tick_counter <= period_full;
        elsif rising_edge(clk) and (tick = '1') then
            if (tick_counter = period_full) then
                tick_counter <= (others => '0');
                value <= amplitude;
            else 
                if (tick_counter = period_half) then
                    value <= (others => '0');
                end if;
                
                tick_counter <= tick_counter + 1;
            end if;
        end if;
    end process;
end;
