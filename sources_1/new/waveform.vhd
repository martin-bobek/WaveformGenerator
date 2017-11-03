library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity waveform is
    port(
        clk: in std_logic;
        reset: in std_logic;
        wave_sel: in std_logic_vector(1 downto 0);
        amplitude: in std_logic_vector(6 downto 0);
        tick: in std_logic;
        value: out std_logic_vector(6 downto 0)
    );
end;

architecture behavioural of waveform is
    component square is
        port(
            clk: in std_logic;
            reset: in std_logic;
            amplitude: in std_logic_vector(6 downto 0);
            tick: in std_logic;
            value: out std_logic_vector(6 downto 0)
        );
    end component;
        
    component sin is
        port(
            clk: in std_logic;
            reset: in std_logic;
            tick: in std_logic;
            value: out std_logic_vector(6 downto 0)
        );
    end component;
    
    component sawtooth is
        port(
            clk: in std_logic;
            reset: in std_logic;
            amplitude: in std_logic_vector(6 downto 0);
            tick: in std_logic;
            value: out std_logic_vector(6 downto 0)
        );
    end component;

    component triangle is
        port(
            clk: in std_logic;
            reset: in std_logic;
            amplitude: in std_logic_vector(6 downto 0);
            tick: in std_logic;
            value: out std_logic_vector(6 downto 0)
        );
    end component;
    
    signal sin_value, square_value, saw_value, triangle_value: std_logic_vector(6 downto 0);
begin
    value <= square_value   when (wave_sel = "00") else
             sin_value      when (wave_sel = "01") else
             saw_value      when (wave_sel = "10") else
             triangle_value;
    
    square_gen: square
        port map(
            clk => clk,
            reset => reset,
            amplitude => amplitude,
            tick => tick,
            value => square_value
        );
        
    sin_gen: sin
        port map(
            clk => clk,
            reset => reset,
            tick => tick,
            value => sin_value
        );
        
    saw_gen: sawtooth
        port map(
            clk => clk,
            reset => reset,
            amplitude => amplitude,
            tick => tick,
            value => saw_value
        );
        
    triangle_gen: triangle
        port map(
            clk => clk,
            reset => reset,
            amplitude => amplitude,
            tick => tick,
            value => triangle_value
        );
end;