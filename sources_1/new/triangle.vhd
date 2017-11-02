library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity triangle is
    port(
          clk: in std_logic;
          reset: in std_logic;
          value: out std_logic_vector(6 downto 0);
          update: in std_logic;
          amplitude: in std_logic_vector(6 downto 0);
          tick_period: in std_logic_vector(12 downto 0)
    ); 
end;

architecture behavioural of triangle is
    component tick_generator is
        port(
            clk: in std_logic;
            reset: in std_logic;
            period: in std_logic_vector(12 downto 0);
            update: in std_logic;
            tick: out std_logic
        );
    end component;
    
    constant period_half: unsigned(7 downto 0) := to_unsigned(99, 8);
    constant period_full: unsigned(7 downto 0) := to_unsigned(199, 8);

    signal captured_period: std_logic_vector(12 downto 0);
    signal tick_counter: unsigned(7 downto 0);
    signal tick: std_logic;
    signal u_value: unsigned(6 downto 0) := (others => '0');
begin
    value <= std_logic_vector(u_value);

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
            u_value <= "0000010";
            tick_counter <= period_full;
            captured_period <= (others => '0');
        elsif rising_edge(clk) and (tick = '1') then
            if (tick_counter = period_full) then
                tick_counter <= (others => '0');
                u_value <= (others => '0');
                captured_period <= tick_period;
            elsif (tick_counter <= period_half) then
                u_value <= u_value + 1;
                tick_counter <= tick_counter + 1;
            else
                tick_counter <= tick_counter + 1;
                u_value <= u_value - 1;
            end if;
        end if;
    end process;
end; 