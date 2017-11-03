library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tick_generator is
    port(
        clk: in std_logic;
        reset: in std_logic;
        period: in std_logic_vector(12 downto 0);
        update: in std_logic;
        tick: out std_logic
    );
end;

architecture behavioural of tick_generator is
    constant one: unsigned(12 downto 0) := to_unsigned(1, 13);
    
    signal update_counter: unsigned(12 downto 0);
    signal captured_period: unsigned(12 downto 0);
    signal i_tick: std_logic;
begin
    tick <= i_tick;

    process(clk, reset) begin
        if (reset = '1') then
            i_tick <= '0';
            update_counter <= (others => '0');
            captured_period <= (others => '0');
        elsif rising_edge(clk) then
            if (update = '1') then
                if (update_counter = captured_period) then
                    captured_period <= unsigned(period);
                    update_counter <= one;
                    i_tick <= '1';
                else
                    update_counter <= update_counter + 1;
                end if;
            end if;
            
            if (i_tick = '1') then
                i_tick <= '0';
            end if;
        end if;
    end process;
end;
