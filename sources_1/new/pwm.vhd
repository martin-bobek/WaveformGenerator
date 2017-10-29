library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm is
    generic(
        width: integer;
        period: integer
    );
    port(
        clk: in std_logic;
        reset: in std_logic;
        input: in std_logic_vector(width - 1 downto 0);
        output: out std_logic;
        update: out std_logic
    );
end;

architecture behavioural of pwm is 
    signal counter: unsigned(width - 1 downto 0);
    signal captured_input: unsigned(width - 1 downto 0);
    signal i_update: std_logic;
    
    constant max_value: unsigned(width - 1 downto 0) := to_unsigned(period, width);
    constant zero_input: std_logic_vector(width - 1 downto 0) := (others => '0');
begin
    update <= i_update;

    process(clk, reset) begin
        if (reset = '1') then
            counter <= max_value - 1;
            captured_input <= (others => '0');
            output <= '0';
            i_update <= '0';
        elsif rising_edge(clk) then
            if (counter = max_value) then
                if (input = zero_input) then
                    output <= '0';
                else
                    output <= '1';
                end if;
                
                i_update <= '1';
                counter <= to_unsigned(1, width);
            else
                if (counter + 1 = max_value) then
                    captured_input <= unsigned(input);
                end if;
                
                if (counter = captured_input) then
                    output <= '0';
                end if;
                
                counter <= counter + 1;
            end if;
            
            if (i_update = '1') then
                i_update <= '0';
            end if;
        end if;
    end process;
end;