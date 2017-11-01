library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tick_generator is        -- consider moving period capturing in here
    port(
        clk: in std_logic;
        reset: in std_logic;
        period: in std_logic_vector(12 downto 0);
        update: in std_logic;
        tick: out std_logic
    );
end;

architecture behavioural of tick_generator is
    signal update_counter: unsigned(12 downto 0);
    signal u_period: unsigned(12 downto 0);
    
    signal i_tick: std_logic;
begin
    u_period <= unsigned(period);
    tick <= i_tick;

    process(clk, reset) begin
        if (reset = '1') then
            i_tick <= '0';
            update_counter <= (others => '0');
        elsif rising_edge(clk) then
            if (update = '1') then
                if (update_counter = u_period) then
                    update_counter <= to_unsigned(1,13);
                    i_tick <= '1';
                else
                    update_counter <= update_counter + 1;
                end if;
            elsif (i_tick = '1') then
                i_tick <= '0';
            end if;
        end if;
    end process;
end;
