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
    reg_TOU_prices = [0.0679464937745325,0.135892987549065;
                      0.0703506939871951,0.140701387974390;
                      0.0515595729094486,0.103119145818897;
                      0.0560918102741459,0.112183620548292;
                      0.0571388828426579,0.114277765685316];
    reg_CPP_prices = [0.0625639941313420,0.125127988262684,0.625639941313420;
                      0.0629717969806013,0.125943593961203,0.629717969806013;
                      0.0465359171662684,0.0930718343325367,0.465359171662684;
                      0.0506986982511458,0.101397396502292,0.506986982511458;
                      0.0525808245538562,0.105161649107712,0.525808245538562];
    reg_TOU_hours = [12,12,6;
                     16,8,6;
                     15,9,6;
                     14,10,6;
                     16,8,6];
    reg_TOU_stats = [0.101919740661791,0.0339737303511208;
                     0.0996314473133507,0.0346784230959517;
                     0.0740992769135382,0.0255757281833252;
                     0.0817877852904681,0.0279476806438846;
                     0.0809207311660888,0.0281658394842305];
    reg_CPP_stats = [0.0983331629072295,0.0339737303511208;
                     0.0941279251314418,0.0346784230959517;
                     0.0704555057370235,0.0255757281833252;
                     0.0777333866172869,0.0279476806438846;
                     0.0785958818752267,0.0281658394842305];             
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
    
    data.TOU_prices = [0.0763727525667170,0.152745505133434]; % 1st, 2nd tier price
    data.CPP_prices = [0.0706647954267086,0.141329590853417,0.706647954267086]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [12,12,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.114559128850046,0.0381869197030888]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.111065364943163,0.0381869197030888];
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
    
    data.TOU_prices = [0.0741445061731195,0.148289012346239]; % 1st, 2nd tier price
    data.CPP_prices = [0.0687117461333822,0.137423492266764,0.687117461333822]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [12,12,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.111216759259623,0.0370727806515196]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.107995715746578,0.0370727806515196];
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
    
    data.TOU_prices = [0.0661741245743447,0.132348249148689]; % 1st, 2nd tier price
    data.CPP_prices = [0.0606465277786443,0.121293055557289,0.606465277786443]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [12,12,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0992611868615855,0.0330875331399860]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0953194401766627,0.0330875331399860];
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
    
    data.TOU_prices = [0.0718787416409219,0.143757483281844]; % 1st, 2nd tier price
    data.CPP_prices = [0.0665234113265357,0.133046822653071,0.665234113265357]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [12,12,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.107818112461318,0.0359398822636768]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.104556263293950,0.0359398822636768];
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
    
    data.TOU_prices = [0.0609619919578902,0.121923983915780]; % 1st, 2nd tier price
    data.CPP_prices = [0.0560306702580464,0.112061340516093,0.560306702580464]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [12,12,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0914429879367894,0.0304814297455434]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0880645985408123,0.0304814297455434];
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
    
    data.TOU_prices = [0.0684432069484743,0.136886413896949]; % 1st, 2nd tier price
    data.CPP_prices = [0.0612285745614413,0.122457149122883,0.612285745614413]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0969300426274234,0.0337381531592989]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0915222203998253,0.0337381531592989];
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
    
    data.TOU_prices = [0.0803695797422817,0.160739159484563]; % 1st, 2nd tier price
    data.CPP_prices = [0.0716841380186692,0.143368276037338,0.716841380186692]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.113820306465538,0.0396170973217869]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.107150811951885,0.0396170973217869];
    data.TOU_price_player = {'R2_1247_2_t0_TOU.player'};
    data.CPP_price_player = {'R2_1247_2_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R2.player'}; % player that specifies which day is a CPP day (critical_day)
    % 192 residential, 8 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R2-12.47-3.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*3.435; 
    data.avg_house = 5000;
    data.avg_commercial = 30000;
    data.EOL_points={'R2-12-47-3_node_36','A',1;
                     'R2-12-47-3_node_627','B',1;
                     'R2-12-47-3_node_813','C',1};
    data.capacitor_outtage={'R2-12-47-3_cap_1','R2-12-47-3_cap_1_outtage.player'};
    data.regulators={'R2-12-47-3_reg_1'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 3424;
    
    data.TOU_prices = [0.0728417314105072,0.145683462821014]; % 1st, 2nd tier price
    data.CPP_prices = [0.0657130218877896,0.131426043775579,0.657130218877896]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.103159282644206,0.0359063463020671]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0982254072617355,0.0359063463020671];
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
    
    data.TOU_prices = [0.0727171707292849,0.145434341458570]; % 1st, 2nd tier price
    data.CPP_prices = [0.0651246353369309,0.130249270673862,0.651246353369309]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.102982878400784,0.0358449457989571]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0973459086946885,0.0358449457989571];
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
    
    data.TOU_prices = [0.0627307302459911,0.125461460491982]; % 1st, 2nd tier price
    data.CPP_prices = [0.0560400739353941,0.112080147870788,0.560400739353941]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0888399686088443,0.0309222650310128]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0837666405706118,0.0309222650310128];
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
    
    data.TOU_prices = [0.0511170713581922,0.102234142716384]; % 1st, 2nd tier price
    data.CPP_prices = [0.0461945160363975,0.0923890320727950,0.461945160363975]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [15,9,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0734633320612581,0.0253562287042416]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0699386234936254,0.0253562287042416];
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
    
    data.TOU_prices = [0.0496496510357668,0.0992993020715336]; % 1st, 2nd tier price
    data.CPP_prices = [0.0448002313223362,0.0896004626446724,0.448002313223362]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [15,9,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0713544165158740,0.0246283261794586]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0678276726270469,0.0246283261794586];
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
    
    data.TOU_prices = [0.0485992871590750,0.0971985743181499]; % 1st, 2nd tier price
    data.CPP_prices = [0.0443831246851801,0.0887662493703603,0.443831246851801]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [15,9,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0698448771739418,0.0241073012855796]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0671961720387704,0.0241073012855796];
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
    
    data.TOU_prices = [0.0546937208081850,0.109387441616370]; % 1st, 2nd tier price
    data.CPP_prices = [0.0497054060420871,0.0994108120841742,0.497054060420871]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [14,10,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0797492231456491,0.0272510841583174]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0762104290271472,0.0272510841583174];
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
    
    data.TOU_prices = [0.0602135664223527,0.120427132844705]; % 1st, 2nd tier price
    data.CPP_prices = [0.0544261785494540,0.108852357098908,0.544261785494540]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [14,10,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0877977412041490,0.0300013409547237]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0834485169289365,0.0300013409547237];
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
    
    data.TOU_prices = [0.0628885829866714,0.125777165973343]; % 1st, 2nd tier price
    data.CPP_prices = [0.0569281789290860,0.113856357858172,0.569281789290860]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [14,10,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0916981979614388,0.0313341649140678]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0872846896421996,0.0313341649140678];
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
    
    data.TOU_prices = [0.0608951452300210,0.121790290460042]; % 1st, 2nd tier price
    data.CPP_prices = [0.0558855758101448,0.111771151620290,0.558855758101448]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0862403923794757,0.0300174382239981]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0835357024575468,0.0300174382239981];
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
    
    data.TOU_prices = [0.0581946715460628,0.116389343092126]; % 1st, 2nd tier price
    data.CPP_prices = [0.0533605474352869,0.106721094870574,0.533605474352869]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0824159510511166,0.0286862762458536]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0797613829491006,0.0286862762458536];
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
    
    data.TOU_prices = [0.0618789495634350,0.123757899126870]; % 1st, 2nd tier price
    data.CPP_prices = [0.0566050052756434,0.113210010551287,0.566050052756434]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0876336671867751,0.0305023912640237]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0846110791518379,0.0305023912640237];
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
    
    data.TOU_prices = [0.0621197890538884,0.124239578107777]; % 1st, 2nd tier price
    data.CPP_prices = [0.0569147582220864,0.113829516444173,0.569147582220864]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0879747467930396,0.0306211098334448]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0850740864589801,0.0306211098334448];
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
    
    data.TOU_prices = [0.0646365152337579,0.129273030467516]; % 1st, 2nd tier price
    data.CPP_prices = [0.0591186052986096,0.118237210597219,0.591186052986096]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0915389628310749,0.0318616959646743]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0883683159802598,0.0318616959646743];
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
    
    data.TOU_prices = [0.0661289459655998,0.132257891931200]; % 1st, 2nd tier price
    data.CPP_prices = [0.0604596399250690,0.120919279850138,0.604596399250690]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0936525600878457,0.0325973695085529]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0903728451976838,0.0325973695085529];
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
    
    data.TOU_prices = [0.0656876272407574,0.131375254481515]; % 1st, 2nd tier price
    data.CPP_prices = [0.0600624783259463,0.120124956651893,0.600624783259463]; % 1st, 2nd, and CPP tier prices
    data.TOU_hours = [16,8,6]; % hours at each tier (first 2 need to sum to 24)
    data.TOU_stats = [0.0930275595258182,0.0323798274120505]; % mean and stdev to be set in stub auction
    data.CPP_stats = [0.0897791826525565,0.0323798274120505];
    data.TOU_price_player = {'R5_3500_1_t0_TOU.player'};
    data.CPP_price_player = {'R5_3500_1_t0_CPP.player'};
    data.CPP_flag = {'CPP_days_R5.player'}; % player that specifies which day is a CPP day (critical_day)
    % 192 residential, 47 commercial, 0 industrial, 0 agricultural
end

end
    
    