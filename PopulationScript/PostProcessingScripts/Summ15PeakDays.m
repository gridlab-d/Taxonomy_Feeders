% This script is intended to pull the peak_15days file, compare each region
% and roughly determine the peak 15 days for each region

% created 3/21/2011 by Jason Fuller

clear;
clc;

% Location of peak_15day file - this will be the read and write directory
cd('C:\Users\D3X289\Documents\GLD_Analysis_2011\Gridlabd\Taxonomy_Feeders\PostAnalysis\ProcessedData\');
file_name = 'peak_15days';
load([file_name '_t0.mat']);

eval(['field_names = fieldnames(' file_name ');']);

% initiliaze the indices for each region
r_ind = [1 1 1 1 1];

regional_ts = {'' '' '' '' ''};

for field_ind = 1:length(field_names)
    % only grab the timesteps 
    if (strfind(char(field_names(field_ind)),'_ts') ~= 0)       
        eval(['ts_var = ' char(file_name) '.' char(field_names(field_ind)) ';']);
   
        % Find what region we're looking at
        if (strfind(char(field_names(field_ind)),'GC') ~= 0)
            token = strrep(char(field_names(field_ind)),'GC_1247_1_t0_r','');
            region = str2num(strrep(token,'_ts',''));
        else
            token = strtok(char(field_names(field_ind)),'_');
            region = str2num(strrep(token,'R',''));
        end
      
        for ts_ind = 1:15
            test_var1 = char(regional_ts{:,region});
            test_var2 = strmatch(ts_var{1,ts_ind},test_var1);
            if (isempty(test_var2))
                regional_ts{r_ind(region),region} = ts_var{1,ts_ind};
                total_seen(r_ind(region),region) = 1;
                r_ind(region) = r_ind(region) + 1;                
            else
                total_seen(test_var2,region) = total_seen(test_var2,region) + 1;
            end
        end       
    end   
end


%%
% annual peak dates
CPP{1,1} = {'2009-07-02';'2009-09-28';'2009-07-03';'2009-09-29';'2009-07-01';'2009-06-16';'2009-08-26';'2009-06-15';'2009-09-30';'2009-10-13';'2009-08-14';'2009-07-24';'2009-09-27';'2009-08-15';'2009-10-31'};
CPP{2,1} = {'2009-07-09';'2009-07-14';'2009-08-04';'2009-06-08';'2009-07-03';'2009-07-13';'2009-07-02';'2009-07-08';'2009-08-03';'2009-06-16';'2009-06-15';'2009-07-28';'2009-07-07';'2009-06-20';'2009-07-17'};
CPP{3,1} = {'2009-06-08';'2009-07-08';'2009-07-14';'2009-06-09';'2009-07-16';'2009-07-10';'2009-06-30';'2009-06-22';'2009-06-29';'2009-06-25';'2009-06-24';'2009-07-15';'2009-06-26';'2009-07-13';'2009-07-27'};
CPP{4,1} = {'2009-08-04';'2009-09-03';'2009-06-26';'2009-09-02';'2009-08-03';'2009-09-04';'2009-08-05';'2009-06-29';'2009-09-07';'2009-07-23';'2009-06-28';'2009-06-30';'2009-07-07';'2009-09-01';'2009-09-05'};
CPP{5,1} = {'2009-08-21';'2009-08-18';'2009-08-27';'2009-09-01';'2009-06-26';'2009-07-24';'2009-08-12';'2009-06-12';'2009-06-28';'2009-06-27';'2009-07-22';'2009-08-20';'2009-07-05';'2009-05-24';'2009-08-26'};

% winter peak dates
% CPP{1,1} = {'2009-04-29';'2009-04-14';'2009-04-28';'2009-04-13';'2009-02-17';'2009-02-18';'2009-04-16';'2009-04-07';'2009-02-16';'2009-03-20';'2009-02-13';'2009-11-04';'2009-03-25';'2009-03-30';'2009-11-11'};
% CPP{2,1} = {'2009-11-02';'2009-04-07';'2009-03-31';'2009-04-28';'2009-04-09';'2009-04-01';'2009-04-03';'2009-04-27';'2009-04-29';'2009-04-24';'2009-04-23';'2009-04-10';'2009-04-22';'2009-11-12';'2009-04-06'};
% CPP{3,1} = {'2009-04-14';'2009-04-01';'2009-04-15';'2009-04-28';'2009-04-24';'2009-04-27';'2009-03-17';'2009-04-16';'2009-04-02';'2009-03-18';'2009-04-29';'2009-11-13';'2009-04-17';'2009-04-06';'2009-04-08'};
% CPP{4,1} = {'2009-04-24';'2009-04-30';'2009-04-23';'2009-04-27';'2009-04-29';'2009-11-03';'2009-04-22';'2009-03-30';'2009-04-20';'2009-11-02';'2009-04-01';'2009-04-16';'2009-02-23';'2009-04-09';'2009-04-21'};
% CPP{5,1} = {'2009-04-16';'2009-04-02';'2009-04-09';'2009-04-01';'2009-04-03';'2009-04-24';'2009-11-30';'2009-11-06';'2009-03-13';'2009-03-04';'2009-04-13';'2009-04-23';'2009-04-14';'2009-02-25';'2009-01-06'};
total_power = zeros(24*4,5);

for field_ind = 1:length(field_names)
    % only grab the timesteps
    if (strfind(char(field_names(field_ind)),'GC') ~= 0)
        
    elseif (strfind(char(field_names(field_ind)),'_ts') ~= 0)       
        eval(['ts_var = ' char(file_name) '.' char(field_names(field_ind)) ';']);
   
        % Find what region we're looking at
        if (strfind(char(field_names(field_ind)),'GC') ~= 0)
            token = strrep(char(field_names(field_ind)),'GC_1247_1_t0_r','');
            region = str2num(strrep(token,'_ts',''));
        else
            token = strtok(char(field_names(field_ind)),'_');
            region = str2num(strrep(token,'R',''));
        end
      
        for ts_ind = 1:15
            test_var0 = strtok(ts_var{1,ts_ind},' ');
            test_var1 = char(CPP{region,1});
            test_var2 = strmatch(test_var0,test_var1);
            if (isempty(test_var2))
                % do nothing             
            else
                eval(['power_var = ' char(file_name) '.' char(field_names(field_ind-1)) ';']);
                total_power(:,region) = total_power(:,region) + power_var(:,test_var2);
            end
        end       
    end   
end

plot(total_power(1:96,1:5));
