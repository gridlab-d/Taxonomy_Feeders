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
    data.avg_house = 9000;
    
    % Determines sizing of commercial loads (bigger = less houses)
    data.avg_commercial = 30000;
    
    % End-of-line measurements for each feeder
    data.EOL_points={'7';'7';'7'};
    
    % Peak power of the feeder in kVA
    data.emissions_peak = 15*1000;
    % 0 residential, 0 commercial, 3 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R1-12.47-1.glm')~=0)
    data.nom_volt = 12500;
    data.feeder_rating = 1.15*7.15; % Peak in MW (Only transformer sizing)
    data.avg_house = 12000;%6000;
    data.avg_commercial = 50000;
    data.EOL_points={'533';'311';'302'};
    data.emissions_peak = 15000; %Peak in kVa base .85 pf of 29 (For emissions)
    % 598 residential, 12 commercial, 0 industrial, 8 agricultural
elseif (strcmp(file_to_extract,'R1-12.47-2.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*2.83; 
    data.avg_house = 9000;%4500;
    data.avg_commercial = 50000;
    data.EOL_points={'163';'292';'248'};
    data.emissions_peak = 15*1000;
    % 251 residential, 13 commercial, 0 indusrial, 0 agricultural
elseif (strcmp(file_to_extract,'R1-12.47-3.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*1.35; 
    data.avg_house = 20000;%12000;
    data.avg_commercial = 50000;
    data.EOL_points={'48';'38';'48'};
    data.emissions_peak = 15*1000;
    % 1 residential, 21 commercial, 0 indusrial, 0 agricultural
elseif (strcmp(file_to_extract,'R1-12.47-4.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*5.3; 
    data.avg_house = 12000;%6000;
    data.avg_commercial = 50000;
    data.EOL_points={'300';'300';'300'};
    data.emissions_peak = 15*1000;
    % 38 residential, 12 commercial, 0 indusrial, 0 agricultural
elseif (strcmp(file_to_extract,'R1-25.00-1.glm')~=0)    
    data.nom_volt = 24900;
    data.feeder_rating = 1.15*2.1; 
    data.avg_house = 18000;%9000;
    data.avg_commercial = 50000;
    data.EOL_points={'76_2';'76_2';'76_2';'276';'227';'206'}; %6 Measurements because of voltage regulator
    data.emissions_peak = 15*1000;
    % 25 residential, 21 commercial, 5 industrial, 64 agricultural
elseif (strcmp(file_to_extract,'R2-12.47-1.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*6.05; 
    data.avg_house = 18000;%9000;
    data.avg_commercial = 50000;
    data.EOL_points={'5';'17';'17'};
    data.emissions_peak = 15*1000;
    % 91 residential, 80 commercial, 0 industrial, 2 agricultural
elseif (strcmp(file_to_extract,'R2-12.47-2.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*6.1; 
    data.avg_house = 18000;%9000;
    data.avg_commercial = 50000;
    data.EOL_points={'146_2';'146_2';'146_2';'240';'103';'242'}; %6 Measurements because of voltage regulator
    data.emissions_peak = 15*1000;
    % 192 residential, 8 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R2-12.47-3.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*1.4; 
    data.avg_house = 20000;%15000;
    data.avg_commercial = 50000;
    data.EOL_points={'36';'627';'813'};
    data.emissions_peak = 15*1000;
    % 485 residential, 6 commercial, 0 industrial, 5 agricultural
elseif (strcmp(file_to_extract,'R2-25.00-1.glm')~=0)    
    data.nom_volt = 24900;
    data.feeder_rating = 1.15*17; 
    data.avg_house = 20000;%10000;
    data.avg_commercial = 50000;
    data.EOL_points={'288';'286';'211'};
    data.emissions_peak = 15*1000;
    % 202 residential, 45 commercial, 0 industrial, 27 agricultural
elseif (strcmp(file_to_extract,'R2-35.00-1.glm')~=0)    
    data.nom_volt = 34500;
    data.feeder_rating = 1.15*8.9; 
    data.avg_house = 20000;
    data.avg_commercial = 50000;
    data.EOL_points={'1030';'1030';'1030'};
    data.emissions_peak = 15*1000;
    % 163 residential, 5 commercial, 0 industrial, 442 agricultural
elseif (strcmp(file_to_extract,'R3-12.47-1.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*8.4; 
    data.avg_house = 18000;%9000;
    data.avg_commercial = 50000;
    data.EOL_points={'358';'385';'358'};
    data.emissions_peak = 15*1000;
    % 408 residential, 59 commercial,0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R3-12.47-2.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*4.3; 
    data.avg_house = 18000;%14000;
    data.avg_commercial = 100000;
    data.EOL_points={'36';'36';'36'};
    data.emissions_peak = 15*1000;
    % 0 residential, 57 commercial, 5 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R3-12.47-3.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*7.8; 
    data.avg_house = 18000;%14000;
    data.avg_commercial = 50000;
    data.EOL_points={'1844';'1845';'206'};
    data.emissions_peak = 15*1000;
    % 1625 residential, 0 commercial, 0 industrial, 107 agricultural
elseif (strcmp(file_to_extract,'R4-12.47-1.glm')~=0)    
    data.nom_volt = 13800;
    data.feeder_rating = 1.15*5.55; 
    data.avg_house = 18000;%9000;
    data.avg_commercial = 50000;
    data.EOL_points={'192';'198';'198'};
    data.emissions_peak = 15*1000;
    % 476 residential, 75 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R4-12.47-2.glm')~=0)    
    data.nom_volt = 12500;
    data.feeder_rating = 1.15*2.2; 
    data.avg_house = 18000;%9000;
    data.avg_commercial = 50000;
    data.EOL_points={'180';'264';'256'};
    data.emissions_peak = 15*1000;
    % 176 residential, 21 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R4-25.00-1.glm')~=0)    
    data.nom_volt = 24900;
    data.feeder_rating = 1.15*0.95; 
    data.avg_house = 18000;%9000;
    data.avg_commercial = 50000;
    data.EOL_points={'230';'122';'168'};
    data.emissions_peak = 15*1000;
    % 140 residential, 1 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-1.glm')~=0)    
    data.nom_volt = 13800;
    data.feeder_rating = 1.15*9.4; 
    data.avg_house = 18000;%9000;
    data.avg_commercial = 50000;
    data.EOL_points={'1';'1';'1'};
    data.emissions_peak = 15*1000;
    % 185 residential, 48 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-2.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*4.5; 
    data.avg_house = 18000;%9000;
    data.avg_commercial = 50000;
    data.EOL_points={'114';'158';'293'};
    data.emissions_peak = 15*1000;
    % 138 residential, 46 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-3.glm')~=0)    
    data.nom_volt = 13800;
    data.feeder_rating = 1.15*9.2; 
    data.avg_house = 20000;%13000;
    data.avg_commercial = 50000;
    data.EOL_points={'294_2';'294_2';'294_2';'334_2';'334_2';'334_2';'974_2';'974_2';'974_2';...
        '465';'465';'465';'1278';'1278';'1278';'749';'749';'749'}; %18 Measurements because of voltage regulator
    data.emissions_peak = 15*1000;
    % 1196 residential, 182 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-4.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*7.7; 
    data.avg_house = 12000;%6000;
    data.avg_commercial = 50000;
    data.EOL_points={'555';'555';'555'};
    data.emissions_peak = 15*1000;
    % 175 residential, 31 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-12.47-5.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 1.15*8.7; 
    data.avg_house = 6000;
    data.avg_commercial = 50000;
    data.EOL_points={'61';'382';'559'};
    data.emissions_peak = 15*1000;
    % 352 residential, 28 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-25.00-1.glm')~=0)    
    data.nom_volt = 22900;
    data.feeder_rating = 1.15*12; 
    data.avg_house = 9000;%4500;
    data.avg_commercial = 50000;
    data.EOL_points={'469';'501';'785'};
    data.emissions_peak = 15*1000;
    % 370 residential, 14 commercial, 0 industrial, 0 agricultural
elseif (strcmp(file_to_extract,'R5-35.00-1.glm')~=0)
    data.nom_volt = 34500;
    data.feeder_rating = 1.15*12; 
    data.avg_house = 14000;%7000;
    data.avg_commercial = 50000;
    data.EOL_points={'155';'184';'85'};
    data.emissions_peak = 15*1000;
    % 192 residential, 47 commercial, 0 industrial, 0 agricultural
end

end
    
    