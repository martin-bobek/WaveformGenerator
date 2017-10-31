library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    port(
        clk: in std_logic;
        reset: in std_logic;
        amp_tick: out std_logic;
        freq_tick: out std_logic
    );
end;

architecture behavioural of clock_divider is
    constant div1: integer := 40000;
    constant max1: unsigned(15 downto 0) := to_unsigned(div1 - 1, 16);
    signal pulse1: std_logic;
    signal counter1: unsigned(15 downto 0);
    
    constant div2: integer := 100;
    constant max2: unsigned(6 downto 0) := to_unsigned(div2 - 1, 7);
    signal pulse2: std_logic;
    signal counter2: unsigned(6 downto 0);
begin
    freq_tick <= pulse1;
    amp_tick <= pulse2;
    
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
    
    process(clk, reset) begin
            if (reset = '1') then
                pulse2 <= '0';
                counter2 <= (others => '0');
            elsif rising_edge(clk) then
                if (pulse1 = '1') then
                    if (counter2 = max2) then
                        pulse2 <= '1';
                        counter2 <= (others => '0');
                    else
                        counter2 <= counter2 + 1;
                    end if;
                end if;
                
                if (pulse2 = '1') then
                    pulse2 <= '0';
                end if;
            end if;
        end process;
end;