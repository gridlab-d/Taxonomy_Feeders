% This script is intended to create revenue neutral pricing for TOU/CPP for
% the 2011 GLD Grant Analyses

% create 3/22/2011 by Jason Fuller

clear;
clc;

% declare working directory - all the .mat files should be located here
cd('C:\Users\D3X289\Documents\GLD_Analysis_2011\Gridlabd\Taxonomy_Feeders\ExtractionScript\t0');

% where to write the new data - use a different location, or it gets ugly
write_dir = 'C:\Documents and Settings\d3x289\My Documents\GLD_Analysis_2011\Gridlabd\Taxonomy_Feeders\PostAnalysis\ProcessedData\';

% load the aggregate bills variable
load([write_dir,'total_annual_revenue_t0.mat']);

% find all of the .mat files in the directory
temp = what;
data_files = temp.mat;
[no_files,junk] = size(data_files);

% TOU/CPP rate ratios at one hour intervals for summer and winter
% months that apply TOU winter vs. summer (1 w, 2 s)
TOU_w(1,:) = [1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1];
TOU_s(1,:) = [1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1];
TOU_m(1,:) = [1 1 1 1 2 2 2 2 2 2 1 1];

TOU_w(2,:) = [1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1];
TOU_s(2,:) = [1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 1 1 1 1 1 1];
TOU_m(2,:) = [1 1 1 1 2 2 2 2 2 2 1 1];

TOU_w(3,:) = [1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1];
TOU_s(3,:) = [1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 1 1 1 1 1];
TOU_m(3,:) = [1 1 1 1 2 2 2 2 2 2 1 1];

TOU_w(4,:) = [1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1];
TOU_s(4,:) = [1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 1 1 1 1];
TOU_m(4,:) = [1 1 1 1 2 2 2 2 2 2 1 1];

TOU_w(5,:) = [1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 1 1 1];
TOU_s(5,:) = [1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 1 1 1 1 1 1];
TOU_m(5,:) = [1 1 1 1 2 2 2 2 2 2 1 1];

days_of_month = [31 28 31 30 31 30 31 31 30 31 30 31];
cum_days_of_month = cumsum(days_of_month);

% CPP days and hours for summer/winter by region
% {region,type} - need to be in sequential order
CPP_ratio = 10;

CPP_w{1,1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1];
CPP_w{1,2} = {};

CPP_s{1,1} = [1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1 1 1 1 1];
CPP_s{1,2} = {'2009-07-02';'2009-09-28';'2009-07-03';'2009-09-29';'2009-07-01';'2009-06-16';'2009-08-26';'2009-06-15';'2009-09-30';'2009-10-13';'2009-08-14';'2009-07-24';'2009-09-27';'2009-08-15';'2009-10-31'};

CPP_w{2,1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1];
CPP_w{2,2} = {};

CPP_s{2,1} = [1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1 1 1 1 1];
CPP_s{2,2} = {'2009-07-09';'2009-07-14';'2009-08-04';'2009-06-08';'2009-07-03';'2009-07-13';'2009-07-02';'2009-07-08';'2009-08-03';'2009-06-16';'2009-06-15';'2009-07-28';'2009-07-07';'2009-06-20';'2009-07-17'};

CPP_w{3,1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1];
CPP_w{3,2} = {};

CPP_s{3,1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1 1 1];
CPP_s{3,2} = {'2009-06-08';'2009-07-08';'2009-07-14';'2009-06-09';'2009-07-16';'2009-07-10';'2009-06-30';'2009-06-22';'2009-06-29';'2009-06-25';'2009-06-24';'2009-07-15';'2009-06-26';'2009-07-13';'2009-07-27'};

CPP_w{4,1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1];
CPP_w{4,2} = {};

CPP_s{4,1} = [1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1 1 1 1 1 1];
CPP_s{4,2} = {'2009-08-04';'2009-09-03';'2009-06-26';'2009-09-02';'2009-08-03';'2009-09-04';'2009-08-05';'2009-06-29';'2009-09-07';'2009-07-23';'2009-06-28';'2009-06-30';'2009-07-07';'2009-09-01';'2009-09-05'};

CPP_w{5,1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1];
CPP_w{5,2} = {};

CPP_s{5,1} = [1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1 1 1 1 1 1];
CPP_s{5,2} = {'2009-08-21';'2009-08-18';'2009-08-27';'2009-09-01';'2009-06-26';'2009-07-24';'2009-08-12';'2009-06-12';'2009-06-28';'2009-06-27';'2009-07-22';'2009-08-20';'2009-07-05';'2009-05-24';'2009-08-26'};

% go through each feeder and balance it out
for file_ind=1:no_files
    % load the current file into the workspace
    current_file = char(strrep(data_files(file_ind),'.mat',''));
    load(current_file);
    
    disp(['Opening file ' current_file]);
    
    % This should really come from energy consumption, but since it wasn't
    % measured that way, we'll have to make approximations that power ~=
    % energy
    eval(['power_var = ' current_file '.transformerpower_power_out_real;']);
    eval(['time_var = ' current_file '.timestamp;']);
    
    % convert to kW since energy pricing is in kWh and divide by 4 to
    % convert to kWh from kW
    power_var = power_var / 1000 / 4;
    
    % Find what region we're looking at
    if (strfind(current_file,'GC') ~= 0)
        region = str2num(strrep(current_file,'GC_1247_1_t0_r',''));
    else
        token = strtok(current_file,'_');
        region = str2num(strrep(token,'R',''));
    end
    
    % create a TOU vector by first expanding to 15 minute intervals
    for jj = 1:96
        TOU_day_w(jj,1) = TOU_w(region,ceil(jj/4));
        TOU_day_s(jj,1) = TOU_s(region,ceil(jj/4));
    end
    
    TOU_vector = [];
    my_length = floor(length(time_var) / 4 / 24);
    for ii = 1:my_length % go an extra day, cuz our data does too
        if (ii == 366)
            TOU_vector = [TOU_vector; TOU_day_w];
        else
            first_test = find(ii <= cum_days_of_month);
            month = first_test(1);

            if (TOU_m(region,month) == 1) %winter
                TOU_vector = [TOU_vector; TOU_day_w];
            else
                TOU_vector = [TOU_vector; TOU_day_s];
            end
        end
    end
    
    CPP_vector = TOU_vector;
    
    % identify each of the CPP days by index
    time_ind_w = [];
    time_ind_s = [];
    [no_times_w,junk] = size(CPP_w{region,2});
    [no_times_s,junk] = size(CPP_s{region,2});
    for jind=1:no_times_w
        temp_time = strmatch(CPP_w{region,2}{jind},time_var);
        time_ind_w = [time_ind_w temp_time];
    end
    for jind=1:no_times_s
        temp_time = strmatch(CPP_s{region,2}{jind},time_var);
        time_ind_s = [time_ind_s temp_time];
    end

    % make a common CPP day
    test_day_w = CPP_w{region,1};
    test_day_s = CPP_s{region,1};

    for jj = 1:96
        CPP_day_w(jj,1) = test_day_w(ceil(jj/4));
        CPP_day_s(jj,1) = test_day_s(ceil(jj/4));
    end

    % replace the TOU schedule with the CPP schedule
    for ii = 1:no_times_w
        CPP_vector(time_ind_w(:,ii)) = CPP_day_w;
    end
    for ii = 1:no_times_s
        CPP_vector(time_ind_s(:,ii)) = CPP_day_s;
    end
    
    % all regions use DST, so subtract/add hour at right location
    total_length = length(TOU_vector);
    temp_TOU(1:66*24*4) = TOU_vector(1:1584*4);
    temp_CPP(1:66*24*4) = CPP_vector(1:1584*4);

    temp_TOU( (66*24*4 + 1):(304*24*4) ) = TOU_vector( (66*24*4 + 5):(304*24*4 + 4) );
    temp_CPP( (66*24*4 + 1):(304*24*4) ) = CPP_vector( (66*24*4 + 5):(304*24*4 + 4) );

    temp_TOU( (304*24*4 + 1):(304*24*4 + 4) ) = [1 1 1 1]';
    temp_CPP( (304*24*4 + 1):(304*24*4 + 4) ) = [1 1 1 1]';

    temp_TOU( (304*24*4 + 5):total_length ) = TOU_vector( (304*24*4 + 5):total_length ); 
    temp_CPP( (304*24*4 + 5):total_length ) = CPP_vector( (304*24*4 + 5):total_length );

    TOU_vector = temp_TOU';
    CPP_vector = temp_CPP';
    clear temp_TOU temp_CPP;

    
    % get the total revenue of the normalized prices
    total_predicted_revenue_TOU = sum(TOU_vector.*power_var);
    total_predicted_revenue_CPP = sum(CPP_vector.*power_var);
    
    % get the index number of the feeder and the revenue for it
    index_number = strmatch(current_file,total_annual_revenue(:,1));
    total_actual_revenue = cell2mat(total_annual_revenue(index_number,2));
    
    % use the price ratio to calculate the new calibrated price
    price_ratio_TOU = total_actual_revenue / total_predicted_revenue_TOU;
    price_ratio_CPP = total_actual_revenue / total_predicted_revenue_CPP;
    final_TOU_vector = price_ratio_TOU * TOU_vector;
    final_CPP_vector = price_ratio_CPP * CPP_vector;
    
    % set up the player files to be printed
    fn_TOU = [write_dir current_file '_TOU.player'];
    fn_CPP = [write_dir current_file '_CPP.player'];
    
    TOU_write = fopen(fn_TOU,'w');
    CPP_write = fopen(fn_CPP,'w');
    
    disp(['Printing tape files for ' current_file]);
    
    fprintf(TOU_write,'# mean = %f, std = %f\n',mean(final_TOU_vector),std(final_TOU_vector));
        total_val = sum(TOU_s(region,:));
        second_tier_hours = total_val - 24;
        first_tier_hours = 24 - second_tier_hours;
    fprintf(TOU_write,'# TOU tier 1: %f $/kWh for %d hours/day\n',min(final_TOU_vector),first_tier_hours);
    fprintf(TOU_write,'# TOU tier 2: %f $/kWh for %d hours/day\n',max(final_TOU_vector),second_tier_hours);
    
    fprintf(CPP_write,'# mean = %f, std = %f\n',mean(final_CPP_vector),std(final_CPP_vector));
        CPP_min = min(final_CPP_vector);

    fprintf(CPP_write,'# TOU tier 1: %f $/kWh for %d hours/day\n',CPP_min,first_tier_hours);
        temp_CPP = final_CPP_vector;
        temp_ind = find(temp_CPP <= CPP_min);
        temp_CPP(temp_ind) = [];
        CPP_mid = min(temp_CPP);
        
        total_val = sum(test_day_s);
        CPP_tier_hours = (total_val - 24) / (10 - 1);
    fprintf(CPP_write,'# TOU tier 2: %f $/kWh for %d hours/day\n',CPP_mid,second_tier_hours);
    fprintf(CPP_write,'# CPP tier 3: %f $/kWh for %d hours/day\n',max(final_CPP_vector),CPP_tier_hours);
    
    for time_ind = 1:length(time_var)
        fprintf(TOU_write,'%s,%f\n',char(time_var(time_ind)),final_TOU_vector(time_ind));
        fprintf(CPP_write,'%s,%f\n',char(time_var(time_ind)),final_CPP_vector(time_ind));
    end
    
    % store some of the key data in an array for later usage
    CPP_array{file_ind,1} = current_file;    
        my_fnc(1,:) = [min(final_TOU_vector),max(final_TOU_vector),0];
        my_fnc(2,:) = [CPP_min,CPP_mid,max(final_CPP_vector)];
        my_fnc(3,:) = [first_tier_hours,second_tier_hours,CPP_tier_hours];
        my_fnc(4,:) = [mean(final_TOU_vector),std(final_TOU_vector),0];
        my_fnc(5,:) = [mean(final_CPP_vector),std(final_TOU_vector),0]; % Not a typo, we'll use the TOU std for both CPP and TOU
    CPP_array{file_ind,2} = my_fnc;    
    
    fclose('all');
    eval(['clear ' current_file]);
    clear power_var time_var TOU_vector CPP_vector final_TOU_vector final_CPP_vector temp_CPP my_fnc;
end

save('CPP_array.mat','CPP_array');

clear;