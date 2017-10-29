library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity square is
    port(
        clk: in std_logic;
        reset: in std_logic;
        value: out std_logic_vector(6 downto 0);
        update: in std_logic;
        amplitude: in std_logic_vector(6 downto 0);
        tick_period: in std_logic_vector(13 downto 0)
    );
end;

architecture behavioural of square is
    constant period_half: unsigned(6 downto 0) := to_unsigned(49, 7);
    constant period_full: unsigned(6 downto 0) := to_unsigned(99, 7);

    signal captured_period: unsigned(13 downto 0);
    signal update_counter: unsigned(13 downto 0);
    signal tick_counter: unsigned(6 downto 0);
    signal tick: std_logic;
begin
    process(clk, reset) begin
        if (reset = '1') then
            tick <= '0';
            update_counter <= (others => '0');
        elsif rising_edge(clk) then
            if (update = '1') then
                if (update_counter = captured_period) then
                    update_counter <= to_unsigned(1,14);
                    tick <= '1';
                else
                    update_counter <= update_counter + 1;
                end if;
            elsif (tick = '1') then
                tick <= '0';
            end if;
        end if;
    end process;
    
    process(clk, reset) begin
        if (reset = '1') then
            value <= (others => '0');
            tick_counter <= period_full;
            captured_period <= (others => '0');
        elsif rising_edge(clk) then
            if (tick = '1') then
                if (tick_counter = period_full) then
                    tick_counter <= (others => '0');
                    value <= amplitude;
                    captured_period <= unsigned(tick_period);
                elsif (tick_counter = period_half) then
                    value <= (others => '0');
                    tick_counter <= tick_counter + 1;
                else
                    tick_counter <= tick_counter + 1;
                end if;
            end if;
        end if;
    end process;
end;
