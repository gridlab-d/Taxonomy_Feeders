function [data] = TaxFeederData(file_to_extract,region)
% This will contain data particular to each taxonomy feeder

% Secondary, or load side, of transformers
% I think its the same for every feeder, but just in case...
data.nom_volt2 = 480;

if (strcmp(file_to_extract,'GC-12.47-1.glm')~=0)
    % Nominal Voltage of the trunk of the feeder
    data.nom_volt = 12470;
    
    % substation rating in MVA - add'l 15% gives rated kW & pf = 0.87
    data.feeder_rating = 1.15*5.38; 
            
    % Determines how many houses to populate (bigger avg_house = less houses)
    data.avg_house = 8000;
    
    % Determines sizing of commercial loads (bigger = less houses)
    data.avg_commercial = 13000;
    
    % End-of-line measurements for each feeder
    % name of node, phases to measure
    data.EOL_points={'GC-12-47-1_node_7','ABC',1};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.regulators={'GC-12-47-1_reg_1'};
    
    % Capacitor outtage information for each feeder
    % Name of capacitor , player file name
    data.capacitor_outtage={'GC-12-47-1_cap_1','GC-12-47-1_cap_1_outtage.player'};
        
    % Peak power of the feeder in kVA
    % these first values are special to GC since it spans 5 regions
    emissions_p = [5363;5754;6637;6321;5916];
    data.emissions_peak = emissions_p(region);
    
    % TOU/CPP pricing information
    % these first values are special to GC since it spans 5 regions
    reg_TOU_prices = [0.067963,0.135925;
                      0.070366,0.140733;
                      0.052073,0.104146;
                      0.056109,0.112218;
                      0.057159,0.114317];
    reg_CPP_prices = [0.062578,0.125157,0.625783;
                      0.062985,0.125969,0.629846;
                      0.047060,0.094120,0.470602;
                      0.050696,0.101391,0.506957;
                      0.052585,0.105169,0.525845];
    reg_TOU_hours = [12,12,6;
                     16,8,6;
                     15,9,6;
                     14,10,6;
                     16,8,6];
    reg_TOU_stats = [0.101944,0.062031;
                     0.099654,0.062596;
                     0.074837,0.046766;
                     0.081813,0.050356;
                     0.080949,0.052260];
    reg_CPP_stats = [0.098356,0.062031;
                     0.094147,0.062596;
                     0.071249,0.046766;
                     0.077729,0.050356;
                     0.078901,0.052260];             
    data.TOU_prices = reg_TOU_prices(region,:); % 1st, 2nd tier price
    data.CPP_prices = reg_CPP_prices(region,:); % 1st, 2nd, and CPP tier prices
    data.TOU_hours = reg_TOU_hours(region,:); % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = reg_TOU_stats(region,:); % mean and stdev to be set in stub auction
    data.CPP_stats = reg_CPP_stats(region,:);
    data.TOU_price_player = {['GC_1247_1_t0_r' num2str(region) '_TOU.player']};
    data.CPP_price_player = {['GC_1247_1_t0_r' num2str(region) '_CPP.player']};
    data.CPP_flag = {['CPP_days_R' num2str(region) '.player']}; % player that specifies which day is a CPP day (critical_day)
     
    % 0 residential, 0 commercial, 3 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R1-12.47-1.glm')~=0)
    data.nom_volt = 12500;
    data.feeder_rating = 1.15*7.272; % Peak in MW (Only transformer sizing)
    data.avg_house = 4000;
    data.avg_commercial = 20000;
    data.EOL_points={'R1-12-47-1_node_533','A',1;
                     'R1-12-47-1_node_311','B',1;
                     'R1-12-47-1_node_302','C',1};
    data.capacitor_outtage={'R1-12-47-1_cap_1','R1-12-47-1_cap_1_outtage.player';'R1-12-47-1_cap_2','R1-12-47-1_cap_2_outtage.player';'R1-12-47-1_cap_3','R1-12-47-1_cap_3_outtage.player'};
    data.regulators={'R1-12-47-1_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 7319; %Peak in kVa base .85 pf of 29 (For emissions)
    
    data.TOU_prices = [0.069669,0.139338]; % 1st, 2nd tier price
    data.CPP_prices = [0.064396,0.128791,0.643956]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [12,12,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.104504,0.063897]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.101225,0.063897];
    data.TOU_price_player = {'R1_1247_1_t0_TOU.player'};
    data.CPP_price_player = {'R1_1247_1_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R1.player'}; % player that specifies which day is a CPP day (critical_day)
    % 598 residential, 12 commercial, 0 industrial, 8 agricultural
elseif (strcmp(file_to_extract,'R1-12.47-2.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*2.733; 
    data.avg_house = 4500;
    data.avg_commercial = 30000;
    data.EOL_points={'R1-12-47-2_node_163','A',1;
                     'R1-12-47-2_node_292','B',1;
                     'R1-12-47-2_node_248','C',1};
    data.capacitor_outtage={'R1-12-47-2_cap_1','R1-12-47-2_cap_1_outtage.player' };
    data.regulators={'R1-12-47-2_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 2670;
    
    data.TOU_prices = [0.074143,0.148287]; % 1st, 2nd tier price
    data.CPP_prices = [0.068626,0.137246,0.686228]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [12,12,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.111215,0.068203]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.107856,0.068203];
    data.TOU_price_player = {'R1_1247_2_t0_TOU.player'};
    data.CPP_price_player = {'R1_1247_2_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R1.player'}; % player that specifies which day is a CPP day (critical_day)
    % 251 residential, 13 commercial, 0 indusrial, 0 agricultural
elseif (strcmp(file_to_extract,'R1-12.47-3.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*1.255; 
    data.avg_house = 8000;
    data.avg_commercial = 15000;
    data.EOL_points={'R1-12-47-3_node_48','AC',1;
                     'R1-12-47-3_node_38','B',1};
    data.capacitor_outtage={};
    data.regulators={'R1-12-47-3_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 1240;
    
    data.TOU_prices = [0.066207,0.132415]; % 1st, 2nd tier price
    data.CPP_prices = [0.060679,0.121357,0.606787]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [12,12,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.099311,0.060148]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.095370,0.060148];
    data.TOU_price_player = {'R1_1247_3_t0_TOU.player'};
    data.CPP_price_player = {'R1_1247_3_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R1.player'}; % player that specifies which day is a CPP day (critical_day)
    % 1 residential, 21 commercial, 0 indusrial, 0 agricultural
elseif (strcmp(file_to_extract,'R1-12.47-4.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*4.960; 
    data.avg_house = 4000;
    data.avg_commercial = 15000;
    data.EOL_points={'R1-12-47-4_node_300','ABC',1};
    data.capacitor_outtage={'R1-12-47-4_cap_1','R1-12-47-4_cap_1_outtage.player'};
    data.regulators={'R1-12-47-4_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 5117;
    
    data.TOU_prices = [0.071873,0.143746]; % 1st, 2nd tier price
    data.CPP_prices = [0.066437,0.132874,0.664368]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [12,12,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.107810,0.065856]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.104420,0.065856];
    data.TOU_price_player = {'R1_1247_4_t0_TOU.player'};
    data.CPP_price_player = {'R1_1247_4_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R1.player'}; % player that specifies which day is a CPP day (critical_day)
    % 38 residential, 12 commercial, 0 indusrial, 0 agricultural
elseif (strcmp(file_to_extract,'R1-25.00-1.glm')~=0)    
    data.nom_volt = 24900;
    data.feeder_rating = 1.15*2.398; 
    data.avg_house = 6000;
    data.avg_commercial = 25000;
    data.EOL_points={'R1-25-00-1_node_76_2','ABC',1;
                     'R1-25-00-1_node_276','A',2;
                     'R1-25-00-1_node_227','B',2;
                     'R1-25-00-1_node_206','C',2}; %6 Measurements because of voltage regulator
    data.capacitor_outtage={'R1-25-00-1_cap_1','R1-25-00-1_cap_1_outtage.player'};
    data.regulators={'R1-25-00-1_reg_1';'R1-25-00-1_reg_2'};
    data.voltage_regulation = {14136;12000;16000;120;120};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 2339;
    
    data.TOU_prices = [0.061023,0.122046]; % 1st, 2nd tier price
    data.CPP_prices = [0.056094,0.112189,0.560943]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [12,12,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.091534,0.055604]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.088165,0.055604];
    data.TOU_price_player = {'R1_2500_1_t0_TOU.player'};
    data.CPP_price_player = {'R1_2500_1_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R1.player'}; % player that specifies which day is a CPP day (critical_day)
    % 25 residential, 21 commercial, 5 industrial, 64 agricultural
elseif (strcmp(file_to_extract,'R2-12.47-1.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*6.256; 
    data.avg_house = 7000;
    data.avg_commercial = 20000;
    data.EOL_points={'R2-12-47-1_node_5','A',1;
                     'R2-12-47-1_node_17','BC',1};
    data.capacitor_outtage={'R2-12-47-1_cap_1','R2-12-47-1_cap_1_outtage.player'};
    data.regulators={'R2-12-47-1_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 6374;
    
    data.TOU_prices = [0.068507,0.137013]; % 1st, 2nd tier price
    data.CPP_prices = [0.061270,0.122541,0.612703]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.097020,0.060893]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.091585,0.060893];
    data.TOU_price_player = {'R2_1247_1_t0_TOU.player'};
    data.CPP_price_player = {'R2_1247_1_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R2.player'}; % player that specifies which day is a CPP day (critical_day)
    % 91 residential, 80 commercial, 0 industrial, 2 agricultural
elseif (strcmp(file_to_extract,'R2-12.47-2.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*5.747; 
    data.avg_house = 7500;
    data.avg_commercial = 25000;
    data.EOL_points={'R2-12-47-2_node_146_2','ABC',1;
                     'R2-12-47-2_node_240','A',2;
                     'R2-12-47-2_node_103','B',2;
                     'R2-12-47-2_node_242','C',2}; %6 Measurements because of voltage regulator
    data.capacitor_outtage={'R2-12-47-2_cap_1','R2-12-47-2_cap_1_outtage.player';'R2-12-47-2_cap_2','R2-12-47-2_cap_2_outtage.player';'R2-12-47-2_cap_3','R2-12-47-2_cap_3_outtage.player';'R2-12-47-2_cap_4','R2-12-47-2_cap_4_outtage.player'};
    data.regulators={'R2-12-47-2_reg_1';'R2-12-47-2_reg_2'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 5889;
    
    data.TOU_prices = [0.080420,0.160839]; % 1st, 2nd tier price
    data.CPP_prices = [0.071685,0.143370,0.716849]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.113891,0.071243]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.107152,0.071243];
    data.TOU_price_player = {'R2_1247_2_t0_TOU.player'};
    data.CPP_price_player = {'R2_1247_2_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R2.player'}; % player that specifies which day is a CPP day (critical_day)
    % 192 residential, 8 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R2-12.47-3.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*3.435; 
    data.avg_house = 15000;
    data.avg_commercial = 30000;
    data.EOL_points={'R2-12-47-3_node_36','A',1;
                     'R2-12-47-3_node_627','B',1;
                     'R2-12-47-3_node_813','C',1};
    data.capacitor_outtage={'R2-12-47-3_cap_1','R2-12-47-3_cap_1_outtage.player'};
    data.regulators={'R2-12-47-3_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 3424;
    
    data.TOU_prices = [0.072783,0.145566]; % 1st, 2nd tier price
    data.CPP_prices = [0.065530,0.131060,0.655301]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.103076,0.065126]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.097952,0.065126];
    data.TOU_price_player = {'R2_1247_3_t0_TOU.player'};
    data.CPP_price_player = {'R2_1247_3_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R2.player'}; % player that specifies which day is a CPP day (critical_day)
    % 485 residential, 6 commercial, 0 industrial, 5 agricultural
elseif (strcmp(file_to_extract,'R2-25.00-1.glm')~=0)    
    data.nom_volt = 24900;
    data.feeder_rating = 1.15*16.825; 
    data.avg_house = 6000;
    data.avg_commercial = 15000;
    data.EOL_points={'R2-25-00-1_node_288','A',1;
                     'R2-25-00-1_node_286','B',1;
                     'R2-25-00-1_node_211','C',1};
    data.capacitor_outtage={'R2-25-00-1_cap_1','R2-25-00-1_cap_1_outtage.player';'R2-25-00-1_cap_2','R2-25-00-1_cap_2_outtage.player';'R2-25-00-1_cap_3','R2-25-00-1_cap_3_outtage.player';'R2-25-00-1_cap_4','R2-25-00-1_cap_4_outtage.player';'R2-25-00-1_cap_5','R2-25-00-1_cap_5_outtage.player'};
    data.regulators={'R2-25-00-1_reg_1'};
    data.voltage_regulation = {14136;12000;16000;120;120};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 17164;
    
    data.TOU_prices = [0.072782,0.145565]; % 1st, 2nd tier price
    data.CPP_prices = [0.065155,0.130332,0.651659]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.103075,0.064764]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.097408,0.064764];
    data.TOU_price_player = {'R2_2500_1_t0_TOU.player'};
    data.CPP_price_player = {'R2_2500_1_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R2.player'}; % player that specifies which day is a CPP day (critical_day)
    % 202 residential, 45 commercial, 0 industrial, 27 agricultural
elseif (strcmp(file_to_extract,'R2-35.00-1.glm')~=0)    
    data.nom_volt = 34500;
    data.feeder_rating = 1.15*12.638; 
    data.avg_house = 15000;
    data.avg_commercial = 30000;
    data.EOL_points={'R2-35-00-1_node_1030','ABC',1};
    data.capacitor_outtage={'R2-35-00-1_cap_1','R2-35-00-1_cap_1_outtage.player';'R2-35-00-1_cap_2','R2-35-00-1_cap_2_outtage.player';'R2-35-00-1_cap_3','R2-35-00-1_cap_3_outtage.player';'R2-35-00-1_cap_4','R2-35-00-1_cap_4_outtage.player';'R2-35-00-1_cap_5','R2-35-00-1_cap_5_outtage.player';'R2-35-00-1_cap_6','R2-35-00-1_cap_6_outtage.player';'R2-35-00-1_cap_7','R2-35-00-1_cap_7_outtage.player';'R2-35-00-1_cap_8','R2-35-00-1_cap_8_outtage.player';'R2-35-00-1_cap_9','R2-35-00-1_cap_9_outtage.player';'R2-35-00-1_cap_10','R2-35-00-1_cap_10_outtage.player';'R2-35-00-1_cap_11','R2-35-00-1_cap_11_outtage.player';'R2-35-00-1_cap_12','R2-35-00-1_cap_12_outtage.player';'R2-35-00-1_cap_13','R2-35-00-1_cap_13_outtage.player'};
    data.regulators={'R2-35-00-1_reg_1'};
    data.voltage_regulation = {19526;15000;25000;166;166};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 12800;
    
    data.TOU_prices = [0.062754,0.125509]; % 1st, 2nd tier price
    data.CPP_prices = [0.056066,0.112133,0.560665]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.088873,0.055721]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.083806,0.055721];
    data.TOU_price_player = {'R2_3500_1_t0_TOU.player'};
    data.CPP_price_player = {'R2_3500_1_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R2.player'}; % player that specifies which day is a CPP day (critical_day)
    % 163 residential, 5 commercial, 0 industrial, 442 agricultural
elseif (strcmp(file_to_extract,'R3-12.47-1.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*9.366; 
    data.avg_house = 12000;
    data.avg_commercial = 40000;
    data.EOL_points={'R3-12-47-1_node_358','ABC',1};
    data.capacitor_outtage={'R3-12-47-1_cap_1','R3-12-47-1_cap_1_outtage.player'};
    data.regulators={'R3-12-47-1_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 9387;
    
    data.TOU_prices = [0.051515,0.103029]; % 1st, 2nd tier price
    data.CPP_prices = [0.046630,0.093259,0.466297]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [15,9,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.074035,0.046338]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.070598,0.046338];
    data.TOU_price_player = {'R3_1247_1_t0_TOU.player'};
    data.CPP_price_player = {'R3_1247_1_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R3.player'}; % player that specifies which day is a CPP day (critical_day)
    % 408 residential, 59 commercial,0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R3-12.47-2.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*4.462; 
    data.avg_house = 14000;
    data.avg_commercial = 30000;
    data.EOL_points={'R3-12-47-2_node_36','ABC',1};
    data.regulators={'R3-12-47-2_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.capacitor_outtage={};
    data.emissions_peak = 4412;
    
    data.TOU_prices = [0.049997,0.099993]; % 1st, 2nd tier price
    data.CPP_prices = [0.045188,0.090375,0.451876]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [15,9,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.071853,0.044905]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.068414,0.044905];
    data.TOU_price_player = {'R3_1247_2_t0_TOU.player'};
    data.CPP_price_player = {'R3_1247_2_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R3.player'}; % player that specifies which day is a CPP day (critical_day)
    % 0 residential, 57 commercial, 5 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R3-12.47-3.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*8.620; 
    data.avg_house = 7000;
    data.avg_commercial = 15000;
    data.EOL_points={'R3-12-47-3_node_871_2','A',1;
                     'R3-12-47-3_node_871_2','B',1;
                     'R3-12-47-3_node_871_2','C',1;
                     'R3-12-47-3_node_1844','A',2;
                     'R3-12-47-3_node_1845','B',2;
                     'R3-12-47-3_node_206','C',2};
    data.capacitor_outtage={'R3-12-47-3_cap_1','R3-12-47-3_cap_1_outtage.player';'R3-12-47-3_cap_2','R3-12-47-3_cap_2_outtage.player'};
    data.regulators={'R3-12-47-3_reg_1';'R3-12-47-3_reg_2'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 8594;
    
    data.TOU_prices = [0.048945,0.097891]; % 1st, 2nd tier price
    data.CPP_prices = [0.044697,0.089395,0.446974]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [15,9,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.070342,0.044418]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.067672,0.044418];
    data.TOU_price_player = {'R3_1247_3_t0_TOU.player'};
    data.CPP_price_player = {'R3_1247_3_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R3.player'}; % player that specifies which day is a CPP day (critical_day)
    % 1625 residential, 0 commercial, 0 industrial, 107 agricultural
elseif (strcmp(file_to_extract,'R4-12.47-1.glm')~=0)    
    data.nom_volt = 13800;
    data.feeder_rating = 1.15*5.55; 
    data.avg_house = 9000;
    data.avg_commercial = 30000;
    data.EOL_points={'R4-12-47-1_node_192','A',1;
                     'R4-12-47-1_node_198','BC',1};
    data.capacitor_outtage={'R4-12-47-1_cap_1','R4-12-47-1_cap_1_outtage.player';'R4-12-47-1_cap_2','R4-12-47-1_cap_2_outtage.player';'R4-12-47-1_cap_3','R4-12-47-1_cap_3_outtage.player';'R4-12-47-1_cap_4','R4-12-47-1_cap_4_outtage.player'};
    data.regulators={'R4-12-47-1_reg_1'};
    data.voltage_regulation = {7835;5000;10000;65;65};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 4769;
    
    data.TOU_prices = [0.054889,0.109779]; % 1st, 2nd tier price
    data.CPP_prices = [0.049900,0.099801,0.499004]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [14,10,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.080034,0.049566]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.076509,0.049566];
    data.TOU_price_player = {'R4_1247_1_t0_TOU.player'};
    data.CPP_price_player = {'R4_1247_1_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R4.player'}; % player that specifies which day is a CPP day (critical_day)
    % 476 residential, 75 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R4-12.47-2.glm')~=0)    
    data.nom_volt = 12500;
    data.feeder_rating = 1.15*2.249; 
    data.avg_house = 6000;
    data.avg_commercial = 20000;
    data.EOL_points={'R4-12-47-2_node_180','A',1;
                     'R4-12-47-2_node_264','B',1;
                     'R4-12-47-2_node_256','C',1};
    data.capacitor_outtage={};
    data.regulators={'R4-12-47-2_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 2316;
    
    data.TOU_prices = [0.060443,0.120886]; % 1st, 2nd tier price
    data.CPP_prices = [0.054693,0.109386,0.546930]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [14,10,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.088132,0.054326]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.083858,0.054326];
    data.TOU_price_player = {'R4_1247_2_t0_TOU.player'};
    data.CPP_price_player = {'R4_1247_2_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R4.player'}; % player that specifies which day is a CPP day (critical_day)
    % 176 residential, 21 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R4-25.00-1.glm')~=0)    
    data.nom_volt = 24900;
    data.feeder_rating = 1.15*0.934; 
    data.avg_house = 6000;
    data.avg_commercial = 20000;
    data.EOL_points={'R4-25-00-1_node_230','A',1;
                     'R4-25-00-1_node_122','B',1;
                     'R4-25-00-1_node_168','C',1};
    data.capacitor_outtage={};
    data.regulators={'R4-25-00-1_reg_1'};
    data.voltage_regulation = {14136;12000;16000;120;120};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 962;
    
    data.TOU_prices = [0.063358,0.126716]; % 1st, 2nd tier price
    data.CPP_prices = [0.057415,0.114830,0.574149]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [14,10,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.092383,0.057030]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.088031,0.057030];
    data.TOU_price_player = {'R4_2500_1_t0_TOU.player'};
    data.CPP_price_player = {'R4_2500_1_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R4.player'}; % player that specifies which day is a CPP day (critical_day)
    % 140 residential, 1 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-1.glm')~=0)    
    data.nom_volt = 13800;
    data.feeder_rating = 1.15*9.473; 
    data.avg_house = 6500;
    data.avg_commercial = 20000;
    data.EOL_points={'R5-12-47-1_node_1','ABC',1};
    data.capacitor_outtage={'R5-12-47-1_cap_1','R5-12-47-1_cap_1_outtage.player';'R5-12-47-1_cap_2','R5-12-47-1_cap_2_outtage.player';'R5-12-47-1_cap_3','R5-12-47-1_cap_3_outtage.player'};
    data.regulators={'R5-12-47-1_reg_1'};
    data.voltage_regulation = {7835;5000;10000;65;65};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 9734;
    
    data.TOU_prices = [0.060984,0.121969]; % 1st, 2nd tier price
    data.CPP_prices = [0.055972,0.111945,0.559723]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.086367,0.055627]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.083665,0.055627];
    data.TOU_price_player = {'R5_1247_1_t0_TOU.player'};
    data.CPP_price_player = {'R5_1247_1_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R5.player'}; % player that specifies which day is a CPP day (critical_day)
    % 185 residential, 48 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-2.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*4.878; 
    data.avg_house = 4500;
    data.avg_commercial = 15000;
    data.EOL_points={'R5-12-47-2_node_114','A',1;
                     'R5-12-47-2_node_158','B',1;
                     'R5-12-47-2_node_293','C',1};
    data.capacitor_outtage={'R5-12-47-2_cap_1','R5-12-47-2_cap_1_outtage.player'};
    data.regulators={'R5-12-47-2_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 5071;
    
    data.TOU_prices = [0.058294,0.116587]; % 1st, 2nd tier price
    data.CPP_prices = [0.053451,0.106901,0.534505]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.082556,0.053121]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.079869,0.053121];
    data.TOU_price_player = {'R5_1247_2_t0_TOU.player'};
    data.CPP_price_player = {'R5_1247_2_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R5.player'}; % player that specifies which day is a CPP day (critical_day)
    % 138 residential, 46 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-3.glm')~=0)    
    data.nom_volt = 13800;
    data.feeder_rating = 1.15*9.924; 
    data.avg_house = 4000;
    data.avg_commercial = 15000;
    data.EOL_points={'R5-12-47-3_node_294_2','ABC',1;
                     'R5-12-47-3_node_334_2','ABC',1;
                     'R5-12-47-3_node_974_2','ABC',1;
                     'R5-12-47-3_node_465','A',2;
                     'R5-12-47-3_node_68','B',2
                     'R5-12-47-3_node_470','C',2
                     'R5-12-47-3_node_1278','ABC',3;
                     'R5-12-47-3_node_749','ABC',4}; %18 Measurements because of voltage regulator
    data.capacitor_outtage={'R5-12-47-3_cap_1','R5-12-47-3_cap_1_outtage.player';'R5-12-47-3_cap_2','R5-12-47-3_cap_2_outtage.player';'R5-12-47-3_cap_3','R5-12-47-3_cap_3_outtage.player';'R5-12-47-3_cap_4','R5-12-47-3_cap_4_outtage.player';'R5-12-47-3_cap_5','R5-12-47-3_cap_5_outtage.player';'R5-12-47-3_cap_6','R5-12-47-3_cap_6_outtage.player';'R5-12-47-3_cap_7','R5-12-47-3_cap_7_outtage.player';'R5-12-47-3_cap_8','R5-12-47-3_cap_8_outtage.player';'R5-12-47-3_cap_9','R5-12-47-3_cap_9_outtage.player';'R5-12-47-3_cap_10','R5-12-47-3_cap_10_outtage.player';'R5-12-47-3_cap_11','R5-12-47-3_cap_11_outtage.player';'R5-12-47-3_cap_12','R5-12-47-3_cap_12_outtage.player';'R5-12-47-3_cap_13','R5-12-47-3_cap_13_outtage.player'};
    data.regulators={'R5-12-47-3_reg_1';'R5-12-47-3_reg_2';'R5-12-47-3_reg_3';'R5-12-47-3_reg_4'}; % The regulators are not coordinated because of their operation on parallel branches.
    data.voltage_regulation = {7835;5000;10000;65;65};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 10734;
    
    data.TOU_prices = [0.061978,0.123955]; % 1st, 2nd tier price
    data.CPP_prices = [0.056728,0.113457,0.567284]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.087774,0.056379]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.084796,0.056379];
    data.TOU_price_player = {'R5_1247_3_t0_TOU.player'};
    data.CPP_price_player = {'R5_1247_3_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R5.player'}; % player that specifies which day is a CPP day (critical_day)
    % 1196 residential, 182 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-4.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*7.612; 
    data.avg_house = 6000;
    data.avg_commercial = 30000;
    data.EOL_points={'R5-12-47-4_node_555','ABC',1};
    data.capacitor_outtage={'R5-12-47-4_cap_1','R5-12-47-4_cap_1_outtage.player';'R5-12-47-4_cap_2','R5-12-47-4_cap_2_outtage.player';'R5-12-47-4_cap_3','R5-12-47-4_cap_3_outtage.player'};
    data.regulators={'R5-12-47-4_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 7636;
    
    data.TOU_prices = [0.062245,0.124489]; % 1st, 2nd tier price
    data.CPP_prices = [0.057032,0.114063,0.570317]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.088152,0.056680]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.085249,0.056680];
    data.TOU_price_player = {'R5_1247_4_t0_TOU.player'};
    data.CPP_price_player = {'R5_1247_4_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R5.player'}; % player that specifies which day is a CPP day (critical_day)
    % 175 residential, 31 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-5.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*9.125; 
    data.avg_house = 4500;
    data.avg_commercial = 25000;
    data.EOL_points={'R5-12-47-5_node_61','A',1;
                     'R5-12-47-5_node_382','B',1;
                     'R5-12-47-5_node_559','C',1};
    data.capacitor_outtage={'R5-12-47-5_cap_1','R5-12-47-5_cap_1_outtage.player';'R5-12-47-5_cap_2','R5-12-47-5_cap_2_outtage.player';'R5-12-47-5_cap_3','R5-12-47-5_cap_3_outtage.player'};
    data.regulators={'R5-12-47-5_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 9369;
    
    data.TOU_prices = [0.064703,0.129407]; % 1st, 2nd tier price
    data.CPP_prices = [0.059200,0.118399,0.591997]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.091633,0.058835]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.088490,0.058835];
    data.TOU_price_player = {'R5_1247_5_t0_TOU.player'};
    data.CPP_price_player = {'R5_1247_5_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R5.player'}; % player that specifies which day is a CPP day (critical_day)
    % 352 residential, 28 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-25.00-1.glm')~=0)    
    data.nom_volt = 22900;
    data.feeder_rating = 1.15*12.346; 
    data.avg_house = 3000;
    data.avg_commercial = 20000;
    data.EOL_points={'R5-25-00-1_node_469','A',1;
                     'R5-25-00-1_node_501','B',1;
                     'R5-25-00-1_node_785','C',1};
    data.capacitor_outtage={'R5-25-00-1_cap_1','R5-25-00-1_cap_1_outtage.player';'R5-25-00-1_cap_2','R5-25-00-1_cap_2_outtage.player';'R5-25-00-1_cap_3','R5-25-00-1_cap_3_outtage.player';'R5-25-00-1_cap_4','R5-25-00-1_cap_4_outtage.player'};
    data.regulators={'R5-25-00-1_reg_1'};
    data.voltage_regulation = {13000;10000;16000;110;110};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 12691;
    
    data.TOU_prices = [0.066210,0.132419]; % 1st, 2nd tier price
    data.CPP_prices = [0.060569,0.121137,0.605686]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.093767,0.060195]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.090536,0.060195];
    data.TOU_price_player = {'R5_2500_1_t0_TOU.player'};
    data.CPP_price_player = {'R5_2500_1_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R5.player'}; % player that specifies which day is a CPP day (critical_day)
    % 370 residential, 14 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-35.00-1.glm')~=0)
    data.nom_volt = 34500;
    data.feeder_rating = 1.15*12.819; 
    data.avg_house = 6000;
    data.avg_commercial = 25000;
    data.EOL_points={'R5-35-00-1_node_155','A',1;
                     'R5-35-00-1_node_184','B',1;
                     'R5-35-00-1_node_85','C',1};
    data.capacitor_outtage={'R5-35-00-1_cap_1','R5-35-00-1_cap_1_outtage.player'};
    data.regulators={'R5-35-00-1_reg_1'};
    data.voltage_regulation = {19526;15000;25000;166;166};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 12989;
    
    data.TOU_prices = [0.065769,0.131538]; % 1st, 2nd tier price
    data.CPP_prices = [0.060175,0.120349,0.601747]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.093143,0.059804]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.089947,0.059084];
    data.TOU_price_player = {'R5_3500_1_t0_TOU.player'};
    data.CPP_price_player = {'R5_3500_1_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R5.player'}; % player that specifies which day is a CPP day (critical_day)
    % 192 residential, 47 commercial, 0 industrial, 0 agricultural
end

end
    
    