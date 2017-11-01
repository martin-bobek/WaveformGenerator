library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sin is 
    port(
        clk: in std_logic;
        reset: in std_logic;
        value: out std_logic_vector(6 downto 0);
        update: in std_logic;
        tick_period: in std_logic_vector(12 downto 0)
    );
end;

architecture behavioural of sin is
    component lut_sin is
        port(
            input: in std_logic_vector(7 downto 0);
            output: out std_logic_vector(6 downto 0)
        );
    end component;
    
    signal captured_period: unsigned(12 downto 0);
    signal update_counter: unsigned(12 downto 0);
    signal tick_counter: unsigned(7 downto 0);
    signal tick: std_logic;
begin
    lut: lut_sin
        port map(
            input => std_logic_vector(tick_counter),
            output => value
        );
    
    process(clk, reset) begin
        if (reset = '1') then
            tick <= '0';
            update_counter <= (others => '0');
        elsif rising_edge(clk) then
            if (update = '1') then
                if (update_counter = captured_period) then
                    update_counter <= to_unsigned(1,13);
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
            tick_counter <= (others => '0');
            captured_period <= (others => '0');
        elsif rising_edge(clk) and (tick = '1') then
            if (tick_counter = 199) then
                tick_counter <= (others => '0');
                captured_period <= unsigned(tick_period);
            else
                tick_counter <= tick_counter + 1;
            end if;
        end if;
    end process;
end;
