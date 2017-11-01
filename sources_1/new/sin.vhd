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
    
    component tick_generator is
        port(
            clk: in std_logic;
            reset: in std_logic;
            period: in std_logic_vector(12 downto 0);
            update: in std_logic;
            tick: out std_logic
        );
    end component;
    
    signal captured_period: std_logic_vector(12 downto 0);
    signal tick_counter: unsigned(7 downto 0);
    signal tick: std_logic;
begin
    lut: lut_sin
        port map(
            input => std_logic_vector(tick_counter),
            output => value
        );
    
    tick_gen: tick_generator
        port map(
            clk => clk,
            reset => reset,
            period => captured_period,
            update => update,
            tick => tick
        );
    
    process(clk, reset) begin
        if (reset = '1') then
            tick_counter <= (others => '0');
            captured_period <= (others => '0');
        elsif rising_edge(clk) and (tick = '1') then
            if (tick_counter = 199) then
                tick_counter <= (others => '0');
                captured_period <= tick_period;
            else
                tick_counter <= tick_counter + 1;
            end if;
        end if;
    end process;
end;
