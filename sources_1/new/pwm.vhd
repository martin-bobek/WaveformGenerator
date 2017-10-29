library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm is
    generic(
        width: integer;
        cycle: integer
    );
    port(
        clk: in std_logic;
        reset: in std_logic;
        input: in std_logic_vector(width - 1 downto 0);
        output: out std_logic
    );
end;

architecture behavioural of pwm is 
    signal counter: unsigned(width - 1 downto 0);
    signal captured_input: unsigned(width - 1 downto 0);
    
    constant max_value: unsigned(width - 1 downto 0) := to_unsigned(cycle, width);
    constant zero_input: std_logic_vector(width - 1 downto 0) := (others => '0');
begin
    process(clk, reset) begin
        if (reset = '1') then
            counter <= max_value;
            captured_input <= (others => '0');
            output <= '0';
        elsif rising_edge(clk) then
            if (counter = max_value) then
                if (input = zero_input) then
                    output <= '0';
                else
                    output <= '1';
                end if;
                counter <= to_unsigned(1, width);
                captured_input <= unsigned(input);
            else
                if (counter = captured_input) then
                    output <= '0';
                end if;
                counter <= counter + 1;
            end if;
        end if;
    end process;
end;