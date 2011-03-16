function [data] = TaxFeederData(file_to_extract)
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
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15000; %Peak in kVa base .85 pf of 29 (For emissions)
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
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
    data.regulators={'R2-12-47-2_reg_1';'R2-12.47-2_reg_2'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
    % 202 residential, 45 commercial, 0 industrial, 27 agricultural
elseif (strcmp(file_to_extract,'R2-35.00-1.glm')~=0)    
    data.nom_volt = 34500;
    data.feeder_rating = 1.15*12.638; 
    data.avg_house = 15000;
    data.avg_commercial = 30000;
    data.EOL_points={'R2-35-00-1_node_1030','ABC',1};
    data.capacitor_outtage={'R2-35-00-1_cap_1','R2-35-00-1_cap_1_outtage.player';'R2-35-00-1_cap_2','R2-35-00-1_cap_2_outtage.player';'R2-35-00-1_cap_3','R2-35-00-1_cap_3_outtage.player';'R2-35-00-1_cap_4','R2-35-00-1_cap_4_outtage.player';'R2-35-00-1_cap_5','R2-35-00-1_cap_5_outtage.player';'R2-35-00-1_cap_6','R2-35-00-1_cap_6_outtage.player';'R2-35-00-1_cap_7','R2-35-00-1_cap_7_outtage.player';'R2-35-00-1_cap_8','R2-35-00-1_cap_8_outtage.player';'R2-35-00-1_cap_9','R2-35-00-1_cap_9_outtage.player';'R2-35-00-1_cap_10','R2-35-00-1_cap_10_outtage.player';'R2-35-00-1_cap_11','R2-35-00-1_cap_11_outtage.player';'R2-35-00-1_cap_12','R2-35-00-1_cap_12_outtage.player';'R2-35-00-1_cap_13','R2-35-00-1_cap_13_outtage.player'};
    data.regulators={'R2-35-00-1_reg_1'};
    data.voltage_regulation = {19871;15000;25000;166;166};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
    % 0 residential, 57 commercial, 5 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R3-12.47-3.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*8.620; 
    data.avg_house = 7000;
    data.avg_commercial = 15000;
    data.EOL_points={'R3-12-47-3_node_1844','A',1;
                     'R3-12-47-3_node_1845','B',1;
                     'R3-12-47-3_node_206','C',1};
    data.capacitor_outtage={'R3-12-47-3_cap_1','R3-12-47-3_cap_1_outtage.player';'R3-12-47-3_cap_2','R3-12-47-3_cap_2_outtage.player'};
    data.regulators={'R3-12-47-3_reg_1';'R3-12-47-3_reg_2'};
    data.voltage_regulation = {7080;5000;9000;60;60};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
                     'R5-12-47-3_node_460','C',2
                     'R5-12-47-3_node_1278','ABC',3;
                     'R5-12-47-3_node_749','ABC',4}; %18 Measurements because of voltage regulator
    data.capacitor_outtage={'R5-12-47-3_cap_1','R5-12-47-3_cap_1_outtage.player';'R5-12-47-3_cap_2','R5-12-47-3_cap_2_outtage.player';'R5-12-47-3_cap_3','R5-12-47-3_cap_3_outtage.player';'R5-12-47-3_cap_4','R5-12-47-3_cap_4_outtage.player';'R5-12-47-3_cap_5','R5-12-47-3_cap_5_outtage.player';'R5-12-47-3_cap_6','R5-12-47-3_cap_6_outtage.player';'R5-12-47-3_cap_7','R5-12-47-3_cap_7_outtage.player';'R5-12-47-3_cap_8','R5-12-47-3_cap_8_outtage.player';'R5-12-47-3_cap_9','R5-12-47-3_cap_9_outtage.player';'R5-12-47-3_cap_10','R5-12-47-3_cap_10_outtage.player';'R5-12-47-3_cap_11','R5-12-47-3_cap_11_outtage.player';'R5-12-47-3_cap_12','R5-12-47-3_cap_12_outtage.player';'R5-12-47-3_cap_13','R5-12-47-3_cap_13_outtage.player'};
    data.regulators={'R5-12-47-3_reg_1';'R5-12-47-3_reg_2';'R5-12-47-3_reg_3';'R5-12-47-3_reg_4'};
    data.voltage_regulation = {7835;5000;10000;65;65};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
    data.emissions_peak = 15*1000;
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
    data.voltage_regulation = {13200;16000;10000;110;110};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 15*1000;
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
    data.voltage_regulation = {19871;15000;25000;166;166};% desired;min;max;high deadband;low deadband
    data.emissions_peak = 15*1000;
    % 192 residential, 47 commercial, 0 industrial, 0 agricultural
end

end
    
    