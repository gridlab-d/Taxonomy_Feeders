function [data] = TaxFeederData(file_to_extract)
% This will contain data particular to each taxonomy feeder

% Secondary, or load side, of transformers
% I think its the same for every feeder, but just in case...
data.nom_volt2 = 480;

if (strcmp(file_to_extract,'GC-12.47-1.glm')~=0)
    % Nominal Voltage of the trunk of the feeder
    data.nom_volt = 12470;
    
    % substation rating in MVA - add'l 15% gives rated kW & pf = 0.87
    data.feeder_rating = 1.15*5.2; 
            
    % Determines how many houses to populate (bigger avg_house = less houses)
    data.avg_house = 8000;
    
    % Determines sizing of commercial loads (bigger = less houses)
    data.avg_commercial = 14000;
    
    % End-of-line measurements for each feeder
    % name of node, phases to measure
    data.EOL_points={'GC-12-47-1_node_7','ABC'};
    
    % Capacitor outtage information for each feeder
    % Name of capacitor , player file name
    data.capacitor_outtage={'GC-12-47-1_cap_1','capacitor_outtage1.player'};
        
    % Peak power of the feeder in kVA
    data.emissions_peak = 15*1000;
    % 0 residential, 0 commercial, 3 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R1-12.47-1.glm')~=0)
    data.nom_volt = 12500;
    data.feeder_rating = 1.15*7.15; % Peak in MW (Only transformer sizing)
    data.avg_house = 4000;
    data.avg_commercial = 20000;
    data.EOL_points={'R1-12-47-1_node_533','A';
                     'R1-12-47-1_node_311','B';
                     'R1-12-47-1_node_302','C'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15000; %Peak in kVa base .85 pf of 29 (For emissions)
    % 598 residential, 12 commercial, 0 industrial, 8 agricultural
elseif (strcmp(file_to_extract,'R1-12.47-2.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*2.83; 
    data.avg_house = 4500;
    data.avg_commercial = 30000;
    data.EOL_points={'R1-12-47-2_node_163','A';
                     'R1-12-47-2_node_292','B';
                     'R1-12-47-2_node_248','C'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 251 residential, 13 commercial, 0 indusrial, 0 agricultural
elseif (strcmp(file_to_extract,'R1-12.47-3.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*1.35; 
    data.avg_house = 8000;
    data.avg_commercial = 20000;
    data.EOL_points={'R1-12-47-3_node_48','AC';
                     'R1-12-47-3_node_38','B'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 1 residential, 21 commercial, 0 indusrial, 0 agricultural
elseif (strcmp(file_to_extract,'R1-12.47-4.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*5.3; 
    data.avg_house = 4000;
    data.avg_commercial = 15000;
    data.EOL_points={'R1-12-47-4_node_300','ABC'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 38 residential, 12 commercial, 0 indusrial, 0 agricultural
elseif (strcmp(file_to_extract,'R1-25.00-1.glm')~=0)    
    data.nom_volt = 24900;
    data.feeder_rating = 1.15*2.1; 
    data.avg_house = 9000;
    data.avg_commercial = 30000;
    data.EOL_points={'R1-25-00-1_node_76_2','ABC';
                     'R1-25-00-1_node_276','A';
                     'R1-25-00-1_node_227','B';
                     'R1-25-00-1_node_206','C'}; %6 Measurements because of voltage regulator
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 25 residential, 21 commercial, 5 industrial, 64 agricultural
elseif (strcmp(file_to_extract,'R2-12.47-1.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*6.05; 
    data.avg_house = 7000;
    data.avg_commercial = 20000;
    data.EOL_points={'R2-12-47-1_node_5','A';
                     'R2-12-47-1_node_17','BC'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 91 residential, 80 commercial, 0 industrial, 2 agricultural
elseif (strcmp(file_to_extract,'R2-12.47-2.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*6.1; 
    data.avg_house = 7500;
    data.avg_commercial = 25000;
    data.EOL_points={'R2-12-47-2_node_146_2','ABC';
                     'R2-12-47-2_node_240','A';
                     'R2-12-47-2_node_103','B';
                     'R2-12-47-2_node_242','C'}; %6 Measurements because of voltage regulator
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 192 residential, 8 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R2-12.47-3.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*1.4; 
    data.avg_house = 15000;
    data.avg_commercial = 30000;
    data.EOL_points={'R2-12-47-3_node_36','A';
                     'R2-12-47-3_node_627','B';
                     'R2-12-47-3_node_813','C'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 485 residential, 6 commercial, 0 industrial, 5 agricultural
elseif (strcmp(file_to_extract,'R2-25.00-1.glm')~=0)    
    data.nom_volt = 24900;
    data.feeder_rating = 1.15*17; 
    data.avg_house = 6000;
    data.avg_commercial = 15000;
    data.EOL_points={'R2-25-00-1_node_288','A';
                     'R2-25-00-1_node_286','B';
                     'R2-25-00-1_node_211','C'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 202 residential, 45 commercial, 0 industrial, 27 agricultural
elseif (strcmp(file_to_extract,'R2-35.00-1.glm')~=0)    
    data.nom_volt = 34500;
    data.feeder_rating = 1.15*8.9; 
    data.avg_house = 25000;
    data.avg_commercial = 45000;
    data.EOL_points={'R2-35-00-1_node_1030','ABC'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 163 residential, 5 commercial, 0 industrial, 442 agricultural
elseif (strcmp(file_to_extract,'R3-12.47-1.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*8.4; 
    data.avg_house = 12000;
    data.avg_commercial = 40000;
    data.EOL_points={'R3-12-47-1_node_358','ABC'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 408 residential, 59 commercial,0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R3-12.47-2.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*4.3; 
    data.avg_house = 14000;
    data.avg_commercial = 30000;
    data.EOL_points={'R3-12-47-2_node_36','ABC'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 0 residential, 57 commercial, 5 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R3-12.47-3.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*7.8; 
    data.avg_house = 12000;
    data.avg_commercial = 25000;
    data.EOL_points={'R3-12-47-3_node_1844','A';
                     'R3-12-47-3_node_1845','B';
                     'R3-12-47-3_node_206','C'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 1625 residential, 0 commercial, 0 industrial, 107 agricultural
elseif (strcmp(file_to_extract,'R4-12.47-1.glm')~=0)    
    data.nom_volt = 13800;
    data.feeder_rating = 1.15*5.55; 
    data.avg_house = 6000;
    data.avg_commercial = 20000;
    data.EOL_points={'R4-12-47-1_node_192','A';
                     'R4-12-47-1_node_198','BC'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 476 residential, 75 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R4-12.47-2.glm')~=0)    
    data.nom_volt = 12500;
    data.feeder_rating = 1.15*2.2; 
    data.avg_house = 6000;
    data.avg_commercial = 20000;
    data.EOL_points={'R4-12-47-2_node_180','A';
                     'R4-12-47-2_node_264','B';
                     'R4-12-47-2_node_256','C'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 176 residential, 21 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R4-25.00-1.glm')~=0)    
    data.nom_volt = 24900;
    data.feeder_rating = 1.15*0.95; 
    data.avg_house = 6000;
    data.avg_commercial = 20000;
    data.EOL_points={'R4-25-00-1_node_230','A';
                     'R4-25-00-1_node_122','B';
                     'R4-25-00-1_node_168','C'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 140 residential, 1 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-1.glm')~=0)    
    data.nom_volt = 13800;
    data.feeder_rating = 1.15*9.4; 
    data.avg_house = 6500;
    data.avg_commercial = 20000;
    data.EOL_points={'R5-12-47-1_node_1','ABC'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 185 residential, 48 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-2.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*4.5; 
    data.avg_house = 7000;
    data.avg_commercial = 25000;
    data.EOL_points={'R5-12-47-2_node_114','A';
                     'R5-12-47-2_node_158','B';
                     'R5-12-47-2_node_293','C'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 138 residential, 46 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-3.glm')~=0)    
    data.nom_volt = 13800;
    data.feeder_rating = 1.15*9.2; 
    data.avg_house = 4000;
    data.avg_commercial = 15000;
    data.EOL_points={'R5-12-47-3_node_294_2','ABC';
                     'R5-12-47-3_node_334_2','ABC';
                     'R5-12-47-3_node_974_2','ABC';
                     'R5-12-47-3_node_465','ABC';
                     'R5-12-47-3_node_1278','ABC';
                     'R5-12-47-3_node_749','ABC'}; %18 Measurements because of voltage regulator
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 1196 residential, 182 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-4.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*7.7; 
    data.avg_house = 6000;
    data.avg_commercial = 30000;
    data.EOL_points={'R5-12-47-4_node_555','ABC'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 175 residential, 31 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-5.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*8.7; 
    data.avg_house = 4500;
    data.avg_commercial = 25000;
    data.EOL_points={'R5-12-47-5_node_61','A';
                     'R5-12-47-5_node_382','B';
                     'R5-12-47-5_node_559','C'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 352 residential, 28 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-25.00-1.glm')~=0)    
    data.nom_volt = 22900;
    data.feeder_rating = 1.15*12; 
    data.avg_house = 3000;
    data.avg_commercial = 20000;
    data.EOL_points={'R5-25-00-1_node_469','A';
                     'R5-25-00-1_node_501','B';
                     'R5-25-00-1_node_785','C'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 370 residential, 14 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-35.00-1.glm')~=0)
    data.nom_volt = 34500;
    data.feeder_rating = 1.15*12; 
    data.avg_house = 6000;
    data.avg_commercial = 25000;
    data.EOL_points={'R5-35-00-1_node_155','A';
                     'R5-35-00-1_node_184','B';
                     'R5-35-00-1_node_85','C'};
    data.capacitor_outtage={ };
    data.emissions_peak = 15*1000;
    % 192 residential, 47 commercial, 0 industrial, 0 agricultural
end

end
    
    