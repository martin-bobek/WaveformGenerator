library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ud_counter is 
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
end;

architecture behavioural of ud_counter is
    constant u_max: unsigned(width - 1 downto 0) := to_unsigned(max, width);
    constant u_min: unsigned(width - 1 downto 0) := to_unsigned(min, width);

    signal u_count: unsigned(width - 1 downto 0);
begin
    count <= std_logic_vector(u_count);

    process(clk, reset) begin
        if (reset = '1') then
            u_count <= u_max;
        elsif rising_edge(clk) and (enable = '1') then
            if (up = '1') and (u_count /= u_max) then
                u_count <= u_count + 1;
            elsif (down = '1') and (u_count /= u_min) then
                u_count <= u_count - 1;
            end if;
        end if;
    end process;
end;
