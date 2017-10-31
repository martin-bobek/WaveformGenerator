library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity waveform_generator is 
    port(
        clk: in std_logic;
        pwm_out: out std_logic;
        buttons: in std_logic_vector(2 downto 0)
    );
end;

architecture behavioural of waveform_generator is
    component pwm is
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
    end component;
    
    component clock_divider is
        port(
            clk: in std_logic;
            reset: in std_logic;
            amp_tick: out std_logic
        );
    end component;
    
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
    
    component square is
        port(
            clk: in std_logic;
            reset: in std_logic;
            value: out std_logic_vector(6 downto 0);
            update: in std_logic;
            amplitude: in std_logic_vector(6 downto 0);
            tick_period: in std_logic_vector(13 downto 0)
        );
    end component;
    
    constant pwm_period: integer := 100;
    constant pwm_width: integer := 7;
    
    signal reset, amp_up, amp_down, amp_tick: std_logic;
    signal amplitude: std_logic_vector(6 downto 0);
    signal pwm_value: std_logic_vector(pwm_width - 1 downto 0);
    signal pwm_update: std_logic;
begin
    reset <= buttons(0);
    amp_up <= buttons(1);
    amp_down <= buttons(2); -- SHOULD BE BUTTON 4

    pwm_gen: pwm
        generic map(
            width => pwm_width,
            period => pwm_period
        )
        port map(
            clk => clk,
            reset => reset,
            input => pwm_value,
            output => pwm_out,
            update => pwm_update
        );
        
    divider: clock_divider
        port map(
            clk => clk,
            reset => reset,
            amp_tick => amp_tick
        );
    
    amplitude_counter: ud_counter
        generic map(
            max => 100,
            min => 0,
            width => 7
        )
        port map(
            clk => clk,
            reset => reset,
            enable => amp_tick,
            up => amp_up,
            down => amp_down,
            count => amplitude
        );
    
    square_gen: square
        port map(
            clk => clk,
            reset => reset,
            value => pwm_value,
            update => pwm_update,
            amplitude => amplitude,
            tick_period => "00000000001010" -- 10
        );
end;
