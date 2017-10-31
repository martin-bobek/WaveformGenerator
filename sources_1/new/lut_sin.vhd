library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lut_sin is
    port(
        input: in std_logic_vector(7 downto 0);
        output: out std_logic_vector(6 downto 0)
    );
end;

architecture behavioural of lut_sin is
    type rom is array(0 to 50) of unsigned(5 downto 0);
    
    signal u_input: unsigned(7 downto 0);
    
    constant lut: rom := (
        "000000",
        "000010",
        "000011",
        "000101",
        "000110",
        "001000",
        "001001",
        "001011",
        "001100",
        "001110",
        "001111",
        "010001",
        "010010",
        "010100",
        "010101",
        "010111",
        "011000",
        "011001",
        "011011",
        "011100",
        "011101",
        "011111",
        "100000",
        "100001",
        "100010",
        "100011",
        "100100",
        "100110",
        "100111",
        "101000",
        "101000",
        "101001",
        "101010",
        "101011",
        "101100",
        "101101",
        "101101",
        "101110",
        "101110",
        "101111",
        "110000",
        "110000",
        "110000",
        "110001",
        "110001",
        "110001",
        "110010",
        "110010",
        "110010",
        "110010",
        "110010"
        );
begin
    u_input <= unsigned(input);
    
    process(u_input) 
        variable lut_input: unsigned(5 downto 0);
        variable lut_output: unsigned(6 downto 0);
    begin
        if (u_input <= 50) then
            lut_input := u_input(5 downto 0);
            lut_output := '0' & lut(to_integer(lut_input));
            output <= std_logic_vector(50 + lut_output);
        elsif (u_input <= 100) then
            lut_input := resize(100 - u_input, 6);
            lut_output := '0' & lut(to_integer(lut_input));
            output <= std_logic_vector(50 + lut_output);
        elsif (u_input <= 150) then
            lut_input := resize(u_input - 100, 6);
            lut_output := '0' & lut(to_integer(lut_input));
            output <= std_logic_vector(50 - lut_output);
        elsif (u_input <= 200) then
            lut_input := resize(200 - u_input, 6);
            lut_output := '0' & lut(to_integer(lut_input));
            output <= std_logic_vector(50 - lut_output);
        else
            output <= (others => '0');
        end if;
    end process;
end;
