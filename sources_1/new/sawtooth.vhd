library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sawtooth is
    port(
        clk: in std_logic;
        reset: in std_logic;
        amplitude: in std_logic_vector(6 downto 0);
        tick: in std_logic;
        value: out std_logic_vector(6 downto 0)
    );
end;

architecture behavioural of sawtooth is
    constant period_full: unsigned(7 downto 0) := to_unsigned(199, 8);
    
    signal captured_amplitude: unsigned(6 downto 0);
    signal u_value: unsigned(6 downto 0);
    signal tick_counter: unsigned(7 downto 0);
    signal level_prod, tick_prod: unsigned(14 downto 0);
begin
    value <= std_logic_vector(u_value);

    level_prod <= resize(to_unsigned(200, 8) * u_value, 15);
    tick_prod <= resize(captured_amplitude * tick_counter, 15);
    
    process(clk, reset) begin
        if (reset = '1') then
            u_value <= (others => '0');
            tick_counter <= period_full;
            captured_amplitude <= (others => '0');
        elsif rising_edge(clk) and (tick = '1') then
            if (tick_counter = period_full) then
                tick_counter <= (others => '0');
                u_value <= (others => '0');
                captured_amplitude <= unsigned(amplitude);
            else
                if (tick_prod >= level_prod) then
                    u_value <= u_value + 1;
                end if;
                
                tick_counter <= tick_counter + 1;
            end if;
        end if;
    end process;
end;