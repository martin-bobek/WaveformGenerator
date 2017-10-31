library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    port(
        clk: in std_logic;
        reset: in std_logic;
        amp_tick: out std_logic
    );
end;

architecture behavioural of clock_divider is
    constant div1: integer := 4000000;
    constant max1: unsigned(21 downto 0) := to_unsigned(div1 - 1, 22);
    
    signal pulse1: std_logic;
    signal counter1: unsigned(21 downto 0);
begin
    amp_tick <= pulse1;
    
    process(clk, reset) begin
        if (reset = '1') then
            pulse1 <= '0';
            counter1 <= (others => '0');
        elsif rising_edge(clk) then
            if (counter1 = max1) then
                pulse1 <= '1';
                counter1 <= (others => '0');
            else
                counter1 <= counter1 + 1;
            end if;
            
            if (pulse1 = '1') then
                pulse1 <= '0';
            end if;
        end if;
    end process;
end;