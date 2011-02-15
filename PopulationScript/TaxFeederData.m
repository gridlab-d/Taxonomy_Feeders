function [data] = TaxFeederData(file_to_extract)
% This will contain data particular to each taxonomy feeder

% Secondary, or load side, of transformers
% I think its the same for every feeder, but just in case...
data.nom_volt2 = 480;

if (strcmp(file_to_extract,'GC-12.47-1.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R1-12.47-1.glm')~=0)
    data.nom_volt = 12500;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R1-12.47-2.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R1-12.47-3.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R1-12.47-4.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R1-25.00-1.glm')~=0)    
    data.nom_volt = 24900;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R2-12.47-1.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R2-12.47-2.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R2-12.47-3.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R2-25.00-1.glm')~=0)    
    data.nom_volt = 24900;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R2-35.00-1.glm')~=0)    
    data.nom_volt = 34500;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R3-12.47-1.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R3-12.47-2.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R3-12.47-3.glm')~=0)
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R4-12.47-1.glm')~=0)    
    data.nom_volt = 13800;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R4-12.47-2.glm')~=0)    
    data.nom_volt = 12500;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R4-25.00-1.glm')~=0)    
    data.nom_volt = 24900;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R5-12.47-1.glm')~=0)    
    data.nom_volt = 13800;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R5-12.47-2.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R5-12.47-3.glm')~=0)    
    data.nom_volt = 13800;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R5-12.47-4.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R5-12.47-5.glm')~=0)    
    data.nom_volt = 12470;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R5-25.00-1.glm')~=0)    
    data.nom_volt = 22900;
    data.feeder_rating = 99; % substation rating in MVA
elseif (strcmp(file_to_extract,'R5-35.00-1.glm')~=0)
    data.nom_volt = 34500;
    data.feeder_rating = 99; % substation rating in MVA
end

end
    
    