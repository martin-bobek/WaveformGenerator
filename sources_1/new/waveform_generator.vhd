library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity waveform_generator is 
    port(
        clk: in std_logic;
        pwm_out: out std_logic;
        buttons: in std_logic_vector(4 downto 0);
        switches: in std_logic_vector(1 downto 0)
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
            amp_tick: out std_logic;
            freq_tick: out std_logic
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
    
    component linearizer is
        port(
            clk: in std_logic;
            reset: in std_logic;
            freq_tick: in std_logic;
            up: in std_logic;
            down: in std_logic;
            tick_period: out std_logic_vector(12 downto 0)
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
    
    component waveform is
        port(
            clk: in std_logic;
            reset: in std_logic;
            wave_sel: in std_logic_vector(1 downto 0);
            amplitude: in std_logic_vector(6 downto 0);
            tick: in std_logic;
            value: out std_logic_vector(6 downto 0)
        );
    end component;
    
    signal reset: std_logic; 
    signal amp_up, amp_down, amp_tick: std_logic;
    signal amplitude: std_logic_vector(6 downto 0);
    signal freq_up, freq_down, freq_tick: std_logic;
    signal tick_period: std_logic_vector(12 downto 0);
    signal pwm_value: std_logic_vector(6 downto 0);
    signal pwm_update, tick: std_logic;
    signal wave_sel: std_logic_vector(1 downto 0);
begin
    reset <= buttons(0);
    amp_up <= buttons(1);
    amp_down <= buttons(4);
    freq_up <= buttons(3);
    freq_down <= buttons(2);
    wave_sel <= switches(1 downto 0);
    
    pwm_gen: pwm
        generic map(
            width => 7,
            period => 100
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
            amp_tick => amp_tick,
            freq_tick => freq_tick
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
    
    frequency_counter: linearizer
        port map(
            clk => clk,
            reset => reset,
            freq_tick => freq_tick,
            up => freq_up,
            down => freq_down,
            tick_period => tick_period
        ); 
        
    tick_gen: tick_generator
        port map(
            clk => clk,
            reset => reset,
            period => tick_period,
            update => pwm_update,
            tick => tick
        );
        
    wave_gen: waveform
        port map(
            clk => clk,
            reset => reset,
            wave_sel => wave_sel,
            amplitude => amplitude,
            tick => tick,
            value => pwm_value
        );
end;
