function [data,use_flags] = TechnologyParameters(use_flags)
% Tech flags
% each tech turns on certain flags
data.tech_flag = 0;

%base case
if data.tech_flag == 0
    use_flags.use_homes = 1;
    use_flags.use_commercial = 1;
    use_flags.use_billing = 0;
    data.measure_losses = 0; 
    data.dump_bills = 0; 
    data.collect_house_states = 0;
    data.collect_setpoints = 0;
    data.measure_capacitors = 0;
    data.measure_regulators = 0;
    
% CVR
elseif data.tech_flag == 1
    
% Automation
elseif data.tech_flag == 2
    
% FDIR
elseif data.tech_flag == 3
    
% TOU/CPP w/ tech
elseif data.tech_flag == 4
    
% TOU/CPP w/o tech
elseif data.tech_flag == 5
    
% TOU w/ tech
elseif data.tech_flag == 6

% TOU w/o tech
elseif data.tech_flag == 7

% DLC
elseif data.tech_flag == 8
    
% Thermal
elseif data.tech_flag == 9
    
% PHEV
elseif data.tech_flag == 10
    
% Solar Residential
elseif data.tech_flag == 11
    
% Solar Commercial
elseif data.tech_flag == 12
    
% Wind Residential
elseif data.tech_flag == 13
    
% Wind Commercial
elseif data.tech_flag == 14
    
% combined W&S 
elseif data.tech_flag == 15
    
end

% Use flags structure
% 1. Use homes
% 2. Use battery storage
% 3. Use markets
% 4. Use commercial buildings
% 5. Use vvc
% 6. Use customer billing
% 7. Use solar
% 8. Use PHEV
% 9. Use distribution automation
%10. Use wind
% Recorder flags
% Other parameters

% Home parameters
if (use_flags.use_homes == 1)
    % ZIP fractions and their power factors - Residential
    data.z_pf = 1;
    data.i_pf = 1;
    data.p_pf = 1;
    data.zfrac = 0.3;
    data.ifrac = 0.3;
    data.pfrac = 1 - data.zfrac - data.ifrac;

    % Determines how many houses to populate (bigger avg_house = less houses)
    data.avg_house = 50000;

    % waterheaters 1 = yes, 0 = no
    data.use_wh = 1; 
end

% Battery Parameters
if (use_flags.use_batt == 2 || use_flags.use_batt == 1)
    data.battery_energy = 1000000; % 10 MWh
    data.battery_power = 250000; % 1.5 MW

    data.efficiency = 0.86;   %percent
    data.parasitic_draw = 10; %Watts
end

% Market Parameters -- TODO
% 1 - Active Control
% 2 - Transactive Control
% 3 - DLC
if (use_flags.use_market == 1)
    % market name, 
    % period, 
    % mean, 
    % stdev,
    % slider setting (range: 0.001 - 1; NOTE: do not use zero;
    % name of the price player/schedule)
    % percent penetration,
    % slider setting (range: 0 - 1), 
    % randomize or not [-1 will randomize settings]
    data.market_info = {'Market_1';
                        300;
                        'current_price_mean_24h';
                        'current_price_stdev_24h';
                        0.5;
                        'ExamplePrices2.player';
                        1.0;
                        1.0;
                        1.0};
end

% Commercial building parameters
if (use_flags.use_commercial == 0)
    % zip loads
    data.c_z_pf = 1;
    data.c_i_pf = 1;
    data.c_p_pf = 1;
    data.c_zfrac = 0.3;
    data.c_ifrac = 0.3;
    data.c_pfrac = 1 - data.c_zfrac - data.c_ifrac;
elseif (use_flags.use_commercial == 1)
    % buildings -- needs work
    data.avg_commercial = 50000;
    data.cooling_COP = 3;
end

% VVC parameters
if (use_flags.use_vvc == 1)
    data.output_volt = 2401;  % voltage to regulate to - 2401::120
end

% Customer billing parameters
if (use_flags.use_billing == 1) %FLAT RATE
    data.monthly_fee = 10; % $
    % Average rate by region from, merged using Viraj spreadsheet
    % EIA: http://www.eia.doe.gov/electricity/epm/table5_6_b.html
    data.flat_price = [0.1262,0.1308,0.1066,0.1044,0.1044]; % $ / kWh
elseif(use_flags.use_billing == 2) %TIERED RATE
    data.monthly_fee = 10; % $
    data.flat_price = 0.1; % $ / kWh - first tier price
    data.tier_energy = 500; % kWh - the transition between 1st and 2nd tier
    data.second_tier_price = 0.08; % $ / kWh
elseif(use_flags.use_billing == 3) %RTP/TOU RATE - market must be activated
    data.monthly_fee = 10; % $
    data.flat_price = 0.1; % $ / kWh
end

% Solar parameters
if (use_flags.use_solar == 1)
    
end

% PHEV parameters
if (use_flags.use_phev == 1)
    
end

% DA parameters
if (use_flags.use_da == 1)

end

% Wind parameters
if (use_flags.use_wind == 1)
    
end

% Recorder parameters
    data.measure_losses = 0; % 1 = yes, 0 = no
    data.dump_bills = 0; % 1 = yes, 0 = no
    data.dump_voltage = 0; % 1 = yes, 0 = no
    data.measure_market = 0;
    data.collect_house_states = 0;
    data.collect_setpoints = 0;
    data.measure_capacitors = 0;
    data.measure_regulators = 0;
    
% Other parameters    
    % simulation start and end times -> please use format: yyyy-mm-dd HH:MM:SS
    data.start_date = '2009-01-01 00:00:00';
    data.end_date = '2010-01-02 00:00:00';

    % How often do you want to measure?
    data.meas_interval = 60;  %applies to everything
    meas = datenum(data.end_date) - datenum(data.start_date); %days between start and end
    meas2 = meas*24*60*60;  %seconds between start and end dates
    data.meas_limit = 20*ceil(meas2/data.meas_interval);
    
    % Skews
    data.residential_skew_std = 1800;
    data.residential_skew_max = 5400;
    data.commercial_skew_std = 1800; %These are in 30 minute blocks
    data.commercial_skew_max = 5400;
    
data.tech_number = data.tech_flag;
end