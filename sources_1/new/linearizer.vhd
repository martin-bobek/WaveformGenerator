library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity linearizer is
    port(
        clk: in std_logic;
        reset: in std_logic;
        freq_tick: in std_logic;
        up: in std_logic;
        down: in std_logic;
        tick_period: out std_logic_vector(12 downto 0)
    );
end;

architecture behavioural of linearizer is
    component ud_counter is
        generic(
            max: integer;
            min: integer;
            width: integer
        );
        port(
            clk: in std_logic;
            reset: in std_logic;
            enable: in std_logic;
            up: in std_logic;
            down: in std_logic;
            count: out std_logic_vector(width - 1 downto 0)
        );
    end component;
    
    constant one: unsigned(13 downto 0) := to_unsigned(1, 14);
    
    signal u_output: unsigned(12 downto 0);
    signal period: unsigned(13 downto 0);
    signal counter: unsigned(13 downto 0);
    signal last_dir, current_dir, not_dir: std_logic;
    signal update: std_logic;
    signal product: unsigned(16 downto 0);
begin
    not_dir <= not last_dir;
    tick_period <= std_logic_vector(u_output);
    product <= resize(period * u_output, 17);
    
    tick_period_counter: ud_counter
        generic map(
            max => 5000,
            min => 5,
            width => 13
        )
        port map(
            clk => clk,
            reset => reset,
            enable => update,
            up => not_dir,
            down => last_dir,
            unsigned(count) => u_output
        );

    process(clk, reset) begin
        if (reset = '1') then
            update <= '0';
            last_dir <= '0';
            current_dir <= '0';
            counter <= one;
        elsif rising_edge(clk) then
            if (freq_tick = '1') then
                if (up = '1') then
                    if (current_dir = '0') then
                        current_dir <= '1';
                        counter <= one;
                    else
                        if (counter = period) then
                            counter <= one;
                            last_dir <= '1';
                            update <= '1';
                        else
                            counter <= counter + 1;
                        end if;
                    end if;
                elsif (down = '1') then
                    if (current_dir = '1') then
                        current_dir <= '0';
                        counter <= one;
                    else
                        if (counter = period) then
                            counter <= one;
                            last_dir <= '0';
                            update <= '1';
                        else
                            counter <= counter + 1;
                        end if;
                    end if;
                else
                    counter <= one;
                end if;
            end if;
            
            if (update = '1') then
                update <= '0';
            end if;
        end if;
    end process;
    
    process(reset, clk) begin
        if (reset = '1') then
            period <= to_unsigned(10, 14);
        elsif rising_edge(clk) then
            if (last_dir = '1') then
                if (product < 50000) then
                    period <= period + 1;
                end if;
            else
                if (product > 50000) then
                    period <= period - 1;
                end if;
            end if;
        end if;
    end process;
end;
