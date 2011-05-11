% This script is intended to pull the summarized .mat files and parse them
% into useable variable for the 2011 GLD grant analyses

% created 3/21/2011 by Jason Fuller

clear;
clc;

% declare working directory - all the input .mat files should be located here
tech = 't0';
cd(['C:\Users\D3X289\Documents\GLD_Analysis_2011\Gridlabd\Taxonomy_Feeders\ExtractionScript\' tech]); % Jason
%cd(['C:\Users\d3p313\Desktop\Post Processing Script\MAT Files\' tech]); % Kevin

% where to write the new data - use a different location, or it gets ugly
write_dir = 'C:\Users\D3X289\Documents\GLD_Analysis_2011\Gridlabd\Taxonomy_Feeders\PostAnalysis\ProcessedData\'; % Jason
%write_dir = 'C:\Users\d3p313\Desktop\Post Processing Script\MAT Files\Consolodated MAT Files\'; %Kevin

% find all of the .mat files in the directory
temp = what;
data_files = temp.mat;
[no_files,junk] = size(data_files);

% flags for finding certain information - another script will plot
find_peak_day = 0;                  % find the peak day and store day/time and value
find_peakiest_peak = 0;             % finds the absolute peak W and VA
find_peak_15days = 0;               % find the 15 peakiest days and store the time series power for each day
find_peak_15wintdays = 0;           % excludes the summer and finds the 15 peakiest days in winter
find_total_energy_consumption = 0;  % sum the annual energy consumption
aggregate_bills = 0;                % adds all the bills together to determine total revenue for the utility
find_voltages = 1;                  % get the average and minimum of the lowest EOL voltage per phase
    find_all_voltages = 1;          % this will only work if previous flag is set to 1, finds the average and minimum of every recorded voltage
find_pf = 0;                        % min, max, and average
find_emissions = 0;                 % performs emissions calculations - scales the pre-defined percentages to the peak for each month
find_losses = 0;                    % gathers the system losses

% secondary flag which may cross multiple layers of information
find_monthly_values = 1;            % This grabs monthly values for each applicable data point

    
%% outer loop for opening each file
for file_ind = 1:no_files
    voltage_ind = 1;
    
    % load the current file into the workspace
    current_file = char(strrep(data_files(file_ind),'.mat',''));
    load(current_file);
    
    %% find the indexes for the start and end of each month
    %   we'll just do this once to save time, but this may need to be more
    %   flexible later
    if ((find_monthly_values == 1 || find_emissions == 1 ) && file_ind == 1)
        eval(['temp_var = ' current_file '.timestamp;']);
        
        % find all of the first days, then convert to a double matrix
        temp_a = strfind(temp_var,'-01 00:00:00');
        for kkind = 1:length(temp_a)
            if (isempty(cell2mat(temp_a(kkind))) == 1)
                temp_a(kkind) = {0};
            end
        end
        
        temp_b = cell2mat(temp_a);
        
        % get the indices of the first days
        month_ind(:,1) = find(temp_b > 0);
        
        % now get the last day index
        for jjind = 1:12
            month_ind(jjind,2) = month_ind(jjind + 1,1) - 1;
        end
        
        % get rid of the last one, since it's rolling over to a new year
        month_ind(13,:) = [];      
        
        clear temp_var;
    end
    
    %% Peak day and time
    if (find_peak_day == 1)
        % put the needed data into a temporary variable
        eval(['temp_var = ' current_file '.transformerpower_power_out_real;']);
        eval(['temp_var2 = ' current_file '.timestamp;']);
        
        % grab the max power and the index
        [max_power,ind_max_power] = max(temp_var);
        
        % store the two values into a peak day variable
        peak_day{file_ind,1} = current_file;
        peak_day{file_ind,2} = temp_var2(ind_max_power);
        peak_day{file_ind,3} = max_power;
        
        % clean up my workspace a little
        clear temp_var temp_var2;
    end
    % end peak day
    
    %% Absolute system peak
    if (find_peakiest_peak == 1)
        % put the needed data into a temporary variable
        eval(['temp_var_real = ' current_file '.transformerpower_power_out_real;']);
        eval(['temp_var_imag = ' current_file '.transformerpower_power_out_imag;']);
        
        % grab the max power and the index
        temp_VA = sqrt(temp_var_real.^2 + temp_var_imag.^2);
        max_power = max(temp_var_real);
        max_VA = max(temp_VA);
        
        % store the two values into a peak day variable
        peakiest_peakday{file_ind,1} = current_file;
        peakiest_peakday{file_ind,2} = max_power;
        peakiest_peakday{file_ind,3} = max_VA;
        
        if (find_monthly_values == 1)
            for jjind=1:12
                max_power = max(temp_var_real(month_ind(jjind,1):month_ind(jjind,2)));
                max_VA = max((month_ind(jjind,1):month_ind(jjind,2)));
                
                peakiest_peakday_monthly{file_ind,1} = current_file;
                peakiest_peakday_monthly{file_ind,2}{jjind} = max_power;
                peakiest_peakday_monthly{file_ind,3}{jjind} = max_VA;
            end
        end
        
        % clean up my workspace a little
        clear temp_var_real temp_var_imag temp_VA;
    end
    % end peakiest peak
    
    %% Peak days annual (15 of 'em)
    if (find_peak_15days == 1)
        % put the needed data into a temporary variable
        eval(['temp_var = ' current_file '.transformerpower_power_out_real;']);
        eval(['temp_var2 = ' current_file '.timestamp;']);
        
        for day_ind = 1:15
            % grab the max power and the index
            [max_power,ind_max_power] = max(temp_var);

            % find the beginning of that particular day
            current_day = temp_var2(ind_max_power);
            min_test_ind = ind_max_power - 24*4; % start the indexing a day before the max
            max_test_ind = min_test_ind + 24*2*4; % finish 2 days later
            if (min_test_ind <= 0)
                max_test_ind = 24*2*4;
                min_test_ind = 1;
            elseif (max_test_ind > length(temp_var))
                max_test_ind = length(temp_var);
                min_test_ind = max_test_ind - 24*2*4;
            end
            for test_ind = min_test_ind:max_test_ind
                % when we find it, save the data and break the loop
                if (strncmp(current_day,temp_var2(test_ind),10) ~= 0)
                    current_ind = test_ind:(test_ind + 24*4 - 1);
                    temp1 = temp_var( current_ind );
                    temp2 = temp_var2( current_ind );
                    
                    temp_var(current_ind) = [];
                    temp_var2(current_ind) = [];
                    break;
                end
            end
            
            % store the time series values into a peak 15 day structure
            eval(['peak_15days.' current_file '_power(:,' num2str(day_ind) ') = temp1;']);
            eval(['peak_15days.' current_file '_ts(:,' num2str(day_ind) ') = temp2;']);
        end
        
        % clean up my workspace a little
        clear temp_var temp_var2;
    end
    % end 15 peak
    
    %% Peak winter days (15 of 'em)
    if (find_peak_15wintdays == 1)
        % put the needed data into a temporary variable
        eval(['temp_var = ' current_file '.transformerpower_power_out_real;']);
        eval(['temp_var2 = ' current_file '.timestamp;']);
        
        %TODO: this was only temporary, should probably do it better
        temp_var(11517:29180) = [];
        temp_var2(11517:29180) = [];
        
        for day_ind = 1:15
            % grab the max power and the index
            [max_power,ind_max_power] = max(temp_var);

            % find the beginning of that particular day
            current_day = temp_var2(ind_max_power);
            min_test_ind = ind_max_power - 24*4; % start the indexing a day before the max
            if (min_test_ind < 1)
                min_test_ind = 1;
            end
            max_test_ind = min_test_ind + 24*2*4; % finish 2 days later
            if (max_test_ind > length(temp_var2) )
                max_test_ind = length(temp_var2);
            end
            for test_ind = min_test_ind:max_test_ind
                % when we find it, save the data and break the loop
                if (strncmp(current_day,temp_var2(test_ind),10) ~= 0)
                    current_ind = test_ind:(test_ind + 24*4 - 1);
                    temp1 = temp_var( current_ind );
                    temp2 = temp_var2( current_ind );
                    
                    temp_var(current_ind) = [];
                    temp_var2(current_ind) = [];
                    break;
                end
            end
            
            % store the time series values into a peak 15 day structure
            eval(['peak_15wintdays.' current_file '_power(:,' num2str(day_ind) ') = temp1;']);
            eval(['peak_15wintdays.' current_file '_ts(:,' num2str(day_ind) ') = temp2;']);
        end
        
        % clean up my workspace a little
        clear temp_var temp_var2;
    end
    % end peak 15 winter
    
    %% Energy consumption
    if (find_total_energy_consumption == 1)
        eval(['temp_var = ' current_file '.transformerpower_power_out_real;']);
        
        sum_temp = sum(temp_var) / 4;
        
        % store the the value into a energy variable
        energy_consumption{file_ind,1} = current_file;
        energy_consumption{file_ind,2} = sum_temp;
        
        if (find_monthly_values == 1)
            for mind=1:12
                temp_monthly_cons(mind) = sum(temp_var(month_ind(mind,1):month_ind(mind,2))) / 4;
            end
            
            monthly_energy_consumption{file_ind,1} = current_file;
            monthly_energy_consumption{file_ind,2} = temp_monthly_cons;
        end
        
        clear temp_var;
    end
    % end energy consumption
    
    %% Bill Aggregation
    if (aggregate_bills == 1)
        % get all of the field names
        eval(['field_names = fieldnames(' current_file ');']);
        
        % check to see which type of bills we have
        comm3 = 0;
        comm1 = 0;
        res = 0;
        for a_ind = 1:length(field_names)
            if (strfind(char(field_names(a_ind)),'comm3_bill') ~= 0)
                comm3 = 1;
            elseif (strfind(char(field_names(a_ind)),'comm1_bill') ~= 0)
                comm1 = 1;
            elseif (strfind(char(field_names(a_ind)),'res_bill') ~= 0)
                res = 1;
            end
        end
        
        if (comm3 == 1)
            eval(['temp_var3p = ' current_file '.bills_comm3_bill;']);
            [a3p,b3p]=size(temp_var3p);
        else
            temp_var3p = 0;
            a3p = 0;
            b3p = 0;
        end
        
        if (comm1 == 1)
            eval(['temp_var1p = ' current_file '.bills_comm1_bill;']);
            [a1p,b1p]=size(temp_var1p);
        else
            temp_var1p = 0;
            a1p = 0;
            b1p = 0;
        end
        
        if (res == 1)
            eval(['temp_varsp = ' current_file '.bills_res_bill;']);
            [asp,bsp]=size(temp_varsp);
        else
            temp_varsp = 0;
            asp = 0;
            bsp = 0;
        end
        
        % sum the bills
        total_annual_revenue{file_ind,1} = current_file;
        temp_total_ann_rev = sum(sum(temp_var3p)) + sum(sum(temp_var1p)) + sum(sum(temp_varsp));
        
        % now take out the "fee" ($25 for commercial, $10 residential)       
        total_annual_revenue{file_ind,2} = temp_total_ann_rev - 25*(a3p*b3p + a1p*b1p) - 10*asp*bsp;
    end
    % end annual revenue
    
    %% EOL Voltages
    if (find_voltages == 1)
        eval(['field_names = fieldnames(' current_file ');']);
        
        for iind = 1:length(field_names)
            if (strfind(char(field_names(iind)),'EOL') ~=0)
                %eval(['temp_var = ' current_file '.' field_names(iind)]);
                temp_f = strrep(field_names(iind),'_real','');
                temp_f = strrep(temp_f,'_imag','');
                temp_str_ind = strfind(field_names,char(temp_f));
                for kkind = 1:length(temp_str_ind)
                    if (isempty(cell2mat(temp_str_ind(kkind))) == 1)
                        temp_str_ind(kkind) = {0};
                    end
                end
                str_ind(:,voltage_ind) = cell2mat(temp_str_ind);
                voltage_ind = voltage_ind + 1;             
            end
        end
        
        % brute force method of deleting repeats
        for kind = 2:(voltage_ind - 1)
            jkind = (voltage_ind - 1) + 2 - kind;
            for mnind = 1:(jkind-1)
                if (isequal(str_ind(:,jkind),str_ind(:,mnind)))
                    str_ind(:,mnind) = [];
                end
            end
        end
        
        [ak,bk] = size(str_ind);
        A_ind = 1;
        B_ind = 1;
        C_ind = 1;
        
        for kind = 1:bk
            temp_ind = find(str_ind(:,kind),2);
            eval(['temp_var1 = ' current_file '.' char(field_names(temp_ind(1))) ';']);
            eval(['temp_var2 = ' current_file '.' char(field_names(temp_ind(2))) ';']);
            
            my_name = strrep(char(field_names(temp_ind(1))),'_real','');
            my_name(1:9)=''; %strip off the EOLVolt1
            my_name_min = [my_name '_min'];
            my_name_avg = [my_name '_avg'];
            
            volt_mag = sqrt(temp_var1.^2 + temp_var2.^2);
            volt_ang_deg = tan(temp_var1./temp_var2) * 180 / pi;
            
            if (strfind(char(field_names(temp_ind(1))),'_A') ~= 0)
                min_A_test = min(volt_mag);
                avg_A_test = mean(volt_mag);
                
                if ((A_ind == 1 || (min_A_test < min_A)) && min_A_test ~= 0)
                    min_A = min_A_test;
                    avg_A = avg_A_test;
                end
                
                if (find_all_voltages == 1)
                    all_voltages(A_ind,1) = min_A_test;
                    all_voltages(A_ind,4) = avg_A_test;
                    node_names{A_ind,1} = my_name_min;
                    node_names{A_ind,4} = my_name_avg;
                end
                A_ind = A_ind + 1;
            elseif (strfind(char(field_names(temp_ind(1))),'_B') ~= 0)
                min_B_test = min(volt_mag);
                avg_B_test = mean(volt_mag);
                if ((B_ind == 1 || (min_B_test < min_B)) && min_B_test ~= 0)
                    min_B = min_B_test;
                    avg_B = avg_B_test;
                end
                if (find_all_voltages == 1)
                    all_voltages(B_ind,2) = min_B_test;
                    all_voltages(B_ind,5) = avg_B_test;
                    node_names{B_ind,2} = my_name_min;
                    node_names{B_ind,5} = my_name_avg;
                end
                B_ind = B_ind + 1;
            elseif (strfind(char(field_names(temp_ind(1))),'_C') ~= 0)
                min_C_test = min(volt_mag);
                avg_C_test = mean(volt_mag);
                if ((C_ind == 1 || (min_C_test < min_C)) && min_C_test ~= 0)
                    min_C = min_C_test;
                    avg_C = avg_C_test;
                end
                
                if (find_all_voltages == 1)
                    all_voltages(C_ind,3) = min_C_test;
                    all_voltages(C_ind,6) = avg_C_test;
                    node_names{C_ind,3} = my_name_min;
                    node_names{C_ind,6} = my_name_avg;
                end
                C_ind = C_ind + 1;
            end
        end
        feeder_voltages{file_ind,1} = current_file;
        feeder_voltages{file_ind,2} = min_A;
        feeder_voltages{file_ind,3} = min_B;
        feeder_voltages{file_ind,4} = min_C;
        feeder_voltages{file_ind,5} = avg_A;
        feeder_voltages{file_ind,6} = avg_B;
        feeder_voltages{file_ind,7} = avg_C;
        if (find_all_voltages == 1)
            all_feeder_voltages{file_ind,1} = current_file;
            all_feeder_voltages{file_ind,2} = node_names;
            all_feeder_voltages{file_ind,3} = all_voltages;
        end
        clear min_A min_B min_C avg_A avg_B avg_C str_ind temp_str_ind volt_mag volt_ang_deg temp_var1 temp_var2 all_voltages node_names;
    end
    % end EOL voltages
    
    %% Power Factor
    if (find_pf ==1)
        
        
        % power_factor_temp is a cell of power factor values
        % each feeder has phase a,b,c, and total
        
        % phase a
        eval(['Temp1 = ' current_file '.reg1_power_in_A_real;']);
        eval(['Temp2 = ' current_file '.reg1_power_in_A_imag;']);
        power_factor_temp{1,file_ind}(:,1)=cos(atan(Temp2./Temp1));

        % phase b
        eval(['Temp3 = ' current_file '.reg1_power_in_B_real;']);
        eval(['Temp4 = ' current_file '.reg1_power_in_B_imag;']);
        power_factor_temp{1,file_ind}(:,2)=cos(atan(Temp4./Temp3));

        % phase c
        eval(['Temp5 = ' current_file '.reg1_power_in_C_real;']);
        eval(['Temp6 = ' current_file '.reg1_power_in_C_imag;']);
        power_factor_temp{1,file_ind}(:,3)=cos(atan(Temp6./Temp5));
                      
        power_factor_temp{1,file_ind}(:,4)=cos(atan((Temp2+Temp4+Temp6)./(Temp1+Temp3+Temp5)));
        
        % power_factor gives the min, mean, and max value for each feeder
        % by phase and total.
   
        power_factor{file_ind,1} = current_file;
        
       
        % phase a
        power_factor{file_ind,2} = min(power_factor_temp{1,file_ind}(:,1)); 
        power_factor{file_ind,3} = mean(power_factor_temp{1,file_ind}(:,1));
        power_factor{file_ind,4} = max(power_factor_temp{1,file_ind}(:,1));
        
        % phase b
        power_factor{file_ind,5} = min(power_factor_temp{1,file_ind}(:,2));
        power_factor{file_ind,6} = mean(power_factor_temp{1,file_ind}(:,2));
        power_factor{file_ind,7} = max(power_factor_temp{1,file_ind}(:,2));
       
        % phase c
        power_factor{file_ind,8} = min(power_factor_temp{1,file_ind}(:,3));
        power_factor{file_ind,9} = mean(power_factor_temp{1,file_ind}(:,3));
        power_factor{file_ind,10} = max(power_factor_temp{1,file_ind}(:,3));
        
        % total
        power_factor{file_ind,11} = min(power_factor_temp{1,file_ind}(:,4));
        power_factor{file_ind,12} = mean(power_factor_temp{1,file_ind}(:,4));
        power_factor{file_ind,13} = max(power_factor_temp{1,file_ind}(:,4));
        
        if (find_monthly_values == 1)
            monthly_power_factor{file_ind,1} = current_file;
            
            for mind = 1:12
                % phase a
                if (~isempty(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),1)));
                    monthly_power_factor{file_ind,2}(mind) = min(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),1)); 
                    monthly_power_factor{file_ind,3}(mind) = mean(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),1));
                    monthly_power_factor{file_ind,4}(mind) = max(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),1));
                end

                % phase b
                if (~isempty(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),2)));
                    monthly_power_factor{file_ind,5}(mind) = min(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),2));
                    monthly_power_factor{file_ind,6}(mind) = mean(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),2));
                    monthly_power_factor{file_ind,7}(mind) = max(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),2));
                end

                % phase c
                if (~isempty(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),3)));
                    monthly_power_factor{file_ind,8}(mind) = min(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),3));
                    monthly_power_factor{file_ind,9}(mind) = mean(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),3));
                    monthly_power_factor{file_ind,10}(mind) = max(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),3));
                end

                % total
                if (~isempty(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),4)));
                    monthly_power_factor{file_ind,11}(mind) = min(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),4));
                    monthly_power_factor{file_ind,12}(mind) = mean(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),4));
                    monthly_power_factor{file_ind,13}(mind) = max(power_factor_temp{1,file_ind}(month_ind(mind,1):month_ind(mind,2),4)); 
                end
            end            
        end
        
        
        clear Temp1 Temp2 Temp3 Temp4 Temp5 Temp6
       
    end
    % end power factor
    
    %% Emissions
    if (find_emissions == 1)
        eval(['temp_var = ' current_file '.emissions_Total_energy_out;']);
        
        if (strfind(char(current_file),'GC') ~= 0)
            token = strrep(char(current_file),['GC_1247_1_' tech '_r'],'');
            region = str2num(strrep(token,'_ts',''));
        else
            token = strtok(char(current_file),'_');
            region = str2num(strrep(token,'R',''));
        end

        % get all the right penetration data for the particular region
        % and scale to the maxE for the month
        if (region == 1)
            dtmp = [9.86	8.68	11.47	13.08	10.63	9.73	10.68	8.93	10.09	8.50	9.83	10.41;  %Nuc
                    0.01	0.08	0.18	0.23	0.25	0.24	0.25	0.24	0.21	0.15	0.09	0.04;   %Sol
                    0.58	0.78	0.77	0.72	0.73	0.73	0.67	0.65	0.72	0.82	0.81	0.73;   %Bio
                    2.37	1.86	4.39	4.57	4.63	5.44	4.07	4.66	3.55	3.64	3.17	1.44;   %Wind
                    43.43	37.29	38.84	49.88	56.78	58.39	36.88	29.63	26.32	31.09	36.02	36.29;  %Hydro
                    34.61	41.60	34.96	25.60	22.89	21.10	41.38	48.31	51.24	45.88	42.02	42.13;  %NG
                    5.44	5.77	5.42	2.14	0.45	0.86	2.88	4.09	4.38	5.97	4.00	5.14;   %Coal
                    3.29	3.49	3.51	3.35	3.29	3.10	2.84	3.09	3.11	3.54	3.63	3.35;   %Geo
                    0.43	0.45	0.45	0.43	0.35	0.41	0.36	0.38	0.39	0.40	0.44	0.47];  %Petro
            conv = [0           0       0;      %Nuc
                    0           0       0;      %Sol
                    2521.35     0       1.0344; %Bio
                    0           0       0;      %Wind
                    0           0       0;      %Hydro
                    955.3728    .00816  .0612;  %NG
                    2139.9837   1.041   .6246;  %Coal
                    2522.4      4.204   0;      %Geo
                    2476.43     1.1     0.44];  %Petro
        elseif (region == 2)
            dtmp = [26.47	26.90	27.74	25.27	28.52	27.95	26.33	24.75	27.04	25.09	25.63	25.42;  %Nuc
                    0.00	0.00	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.00	0.00;   %Sol
                    0.64	0.72	0.82	0.90	0.92	0.84	0.82	0.76	0.83	0.85	0.89	0.75;   %Bio
                    2.23	2.71	2.90	3.34	2.79	1.70	1.41	1.60	1.73	2.82	3.22	2.99;   %Wind
                    49.62	49.36	46.70	46.31	44.39	45.54	47.18	46.33	46.05	49.04	49.05	50.69;  %Coal
                    12.31	13.49	14.19	14.67	13.43	14.47	16.33	19.87	17.97	15.73	14.51	13.22;  %NG
                    6.11	5.99	6.92	9.11	9.51	9.05	7.42	6.08	5.98	6.13	6.34	6.43;   %Hydro
                    0.07	0.07	0.08	0.08	0.08	0.07	0.07	0.07	0.08	0.07	0.08	0.08;   %Geo
                    2.55	0.74	0.64	0.32	0.34	0.37	0.43	0.60	0.33	0.27	0.28	0.43];  %Petro
            conv = [0           0       0;      %Nuc
                    0           0       0;      %Sol
                    2521.35     0       1.0344; %Bio
                    0           0       0;      %Wind
                    2139.9837   1.041   .6246;  %Coal
                    955.3728    .00816  .0612;  %NG
                    0           0       0;      %Hydro              
                    2522.4      4.204   0;      %Geo
                    2476.43     1.1     0.44];  %Petro
        elseif (region == 3)
            dtmp = [9.82	8.88	10.24	11.60	10.83	9.72	8.65	8.50	7.13	8.62	9.63	9.38;   %Nuc
                    0.01	0.05	0.13	0.16	0.17	0.13	0.13	0.14	0.13	0.10	0.06	0.03;   %Sol
                    0.22	0.28	0.29	0.29	0.25	0.25	0.23	0.21	0.25	0.27	0.29	0.26;   %Bio
                    2.13	3.08	3.26	3.77	2.80	2.45	2.05	2.20	2.34	3.55	3.02	2.77;   %Wind
                    50.18	43.95	41.77	42.34	43.59	41.52	40.24	41.42	43.70	47.90	49.94	46.58;  %Coal
                    32.79	37.12	37.34	33.17	33.92	37.88	41.67	41.48	40.32	33.07	31.29	34.43;  %NG
                    2.89	4.75	4.95	6.72	6.68	6.40	5.58	4.59	4.47	4.74	3.76	4.60;   %Hydro
                    1.63	1.62	1.70	1.67	1.53	1.40	1.25	1.26	1.42	1.52	1.79	1.70;   %Geo
                    0.32	0.26	0.32	0.28	0.24	0.25	0.20	0.20	0.22	0.24	0.22	0.24];  %Petro
            conv = [0           0       0;      %Nuc
                    0           0       0;      %Sol
                    2521.35     0       1.0344; %Bio
                    0           0       0;      %Wind
                    2139.9837   1.041   .6246;  %Coal
                    955.3728    .00816  .0612;  %NG
                    0           0       0;      %Hydro              
                    2522.4      4.204   0;      %Geo
                    2476.43     1.1     0.44];  %Petro
        elseif (region == 4)
            dtmp = [23.16	23.97	23.95	24.40	24.92	22.45	23.15	21.91	23.58	24.33	23.99	22.77;  %Nuc
                    0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00;   %Sol
                    0.21	0.19	0.21	0.25	0.21	0.18	0.18	0.18	0.21	0.22	0.22	0.18;   %Bio
                    0.69	0.88	1.03	1.16	0.78	0.64	0.53	0.60	0.59	1.13	1.18	1.04;   %Wind
                    61.55	60.14	57.45	58.24	57.41	56.92	56.89	57.14	56.06	58.36	58.48	59.96;  %Coal
                    9.98	11.44	12.86	11.25	11.38	16.04	16.75	17.49	16.14	10.51	9.83	10.19;  %NG
                    3.37	2.67	3.71	4.21	4.73	3.32	2.05	2.20	3.09	5.09	5.96	5.51;   %Hydro
                    0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00;   %Geo
                    1.04	0.71	0.80	0.49	0.56	0.45	0.45	0.48	0.36	0.36	0.34	0.36];  %Petro
            conv = [0           0       0;      %Nuc
                    0           0       0;      %Sol
                    2521.35     0       1.0344; %Bio
                    0           0       0;      %Wind
                    2139.9837   1.041   .6246;  %Coal
                    955.3728    .00816  .0612;  %NG
                    0           0       0;      %Hydro              
                    2522.4      4.204   0;      %Geo
                    2476.43     1.1     0.44];  %Petro
        elseif (region == 5)
            dtmp = [18.26	18.55	18.53	17.36	14.67	13.53	13.74	13.85	13.65	12.70	14.94	16.41;  %Nuc
                    0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00;   %Sol
                    0.46	0.45	0.48	0.46	0.30	0.31	0.31	0.33	0.34	0.39	0.46	0.46;   %Bio
                    2.14	2.60	2.70	2.95	1.91	1.74	1.44	1.48	1.43	2.52	2.63	2.26;   %Wind
                    38.80	41.01	45.26	44.78	47.26	51.29	51.75	51.68	51.03	47.55	43.83	41.73;  %NG
                    37.30	34.53	29.66	30.82	32.04	30.37	30.38	30.17	30.72	33.46	35.06	35.97;  %Coal
                    1.42	0.86	1.57	1.51	1.61	0.78	0.58	0.63	0.99	1.75	2.12	2.35;   %Hydro
                    0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00;   %Geo
                    1.62	2.00	1.79	2.12	2.20	1.96	1.80	1.86	1.84	1.62	0.95	0.82];  %Petro
            conv = [0           0       0;      %Nuc
                    0           0       0;      %Sol
                    2521.35     0       1.0344; %Bio
                    0           0       0;      %Wind
                    955.3728    .00816  .0612;  %NG
                    2139.9837   1.041   .6246;  %Coal
                    0           0       0;      %Hydro 
                    2522.4      4.204   0;      %Geo
                    2476.43     1.1     0.44];  %Petro
        else
            error('Invalid region chosen');
        end
            
        % wrap through each month
        for jjind=1:12
            % get the max energy value for the month
            maxE = max(temp_var(month_ind(jjind,1):month_ind(jjind,2))) / 1000 / 4;

            perc_pen = dtmp(:,jjind);
            pen_scaled = perc_pen/100*maxE;
            
            % zero some temporary accumulators
            acc_CO2 = 0;
            acc_SO2 = 0;
            acc_NOx = 0;
            
            % wrap through each time step in the month and calc emissions
            for ts_ind=month_ind(jjind,1):month_ind(jjind,2)
                % temporary accumulator E value, convert to MWh
                temp_E = temp_var(ts_ind) / 1000 / 4;
                
                disp_ind = 1;
                while (temp_E > 0)
                    % we exceeded the original base power, so dump all of
                    % the excess into the last dispatched (usually petro)
                    if (disp_ind > 9)
                        acc_CO2 = acc_CO2 + temp_E * conv(9,1);
                        acc_SO2 = acc_SO2 + temp_E * conv(9,2);
                        acc_NOx = acc_NOx + temp_E * conv(9,3);
                        temp_E = 0;
                    % this is the last stop, so zero out temp E
                    elseif (temp_E - pen_scaled(disp_ind) < 0)
                        acc_CO2 = acc_CO2 + temp_E * conv(disp_ind,1);
                        acc_SO2 = acc_SO2 + temp_E * conv(disp_ind,2);
                        acc_NOx = acc_NOx + temp_E * conv(disp_ind,3);
                        temp_E = 0;
                    else
                        acc_CO2 = acc_CO2 + pen_scaled(disp_ind) * conv(disp_ind,1);
                        acc_SO2 = acc_SO2 + pen_scaled(disp_ind) * conv(disp_ind,2);
                        acc_NOx = acc_NOx + pen_scaled(disp_ind) * conv(disp_ind,3);
                        temp_E = temp_E - pen_scaled(disp_ind);               
                    end
                    disp_ind = disp_ind + 1;
                end %end while tempE > 0 loop
            end %end day loop
            
            emissions_totals_monthly{file_ind,1} = current_file;
            emissions_totals_monthly{file_ind,2}{jjind} = acc_CO2;
            emissions_totals_monthly{file_ind,3}{jjind} = acc_SO2;
            emissions_totals_monthly{file_ind,4}{jjind} = acc_NOx;
            
        end %end month loop
        
        emissions_totals{file_ind,1} = current_file;
        emissions_totals{file_ind,2}{jjind} = sum(cell2mat(emissions_totals_monthly{file_ind,2}));
        emissions_totals{file_ind,3}{jjind} = sum(cell2mat(emissions_totals_monthly{file_ind,3}));
        emissions_totals{file_ind,4}{jjind} = sum(cell2mat(emissions_totals_monthly{file_ind,4}));
        
        clear temp_var dtmp conv;
    end
    % end emissions
    %% Losses
    if (find_losses == 1)
        eval(['field_names = fieldnames(' current_file ');']);
%         OHLind = 1;
%         UGLind = 1;
%         TPLind = 1;
%         TFRind = 1;
        % Find all of the loss related fields
        for iind = 1:length(field_names)
            if (strfind(char(field_names(iind)),'losses') ~=0)
                % find each of the types
                if (strfind(char(field_names(iind)),'OHL') ~=0)
                    var1 = 1;
                elseif (strfind(char(field_names(iind)),'UGL') ~=0)
                    var1 = 2;
                elseif (strfind(char(field_names(iind)),'TFR') ~=0)
                    var1 = 3;  
                elseif (strfind(char(field_names(iind)),'TPL') ~=0)
                    var1 = 4;
                elseif (strfind(char(field_names(iind)),'transformer') ~=0)
                    var1 = 5;
                else
                    error('did not match any losses to a type');
                end
                
                % peal off the imaginary ones
                if (strfind(char(field_names(iind)),'A_real') ~=0)
                    var2 = 1;
                elseif (strfind(char(field_names(iind)),'B_real') ~=0)
                    var2 = 2;
                elseif (strfind(char(field_names(iind)),'C_real') ~=0)
                    var2 = 3;
                else
                    var2 = 0;
                end
                
                if (var2 ~= 0)
                    eval(['temp_var{' num2str(var1) ',' num2str(var2) '} = ' current_file '.' char(field_names(iind)) ';']);
                end
            end
        end
        
        % sum up the phases into a single variable
        for jjind = 1:5
            temp_var_annual(jjind) = sum(temp_var{jjind,1}) + sum(temp_var{jjind,2}) + sum(temp_var{jjind,3});
        end
        
        temp_var_annual(6) = sum(temp_var_annual(1:5));
        
        annual_losses{file_ind,1} = current_file;
        annual_losses{file_ind,2} = {'Overhead Lines';'Underground Lines';'Secondary Transformers';'Triplex Lines';'Substation';'Total'};
        annual_losses{file_ind,3} = temp_var_annual'/4;
        
        if (find_monthly_values == 1)
            for mind = 1:12
                my_ind = month_ind(mind,1):month_ind(mind,2);
                % sum up the phases
                for jjind = 1:5
                    if ( isempty(temp_var{jjind,1}) )
                        temp_var_monthly(jjind,mind) = 0;
                    else
                        temp_var_monthly(jjind,mind) = sum(temp_var{jjind,1}(my_ind)) + sum(temp_var{jjind,2}(my_ind)) + sum(temp_var{jjind,3}(my_ind));
                    end
                end
                
                temp_var_monthly(6,mind) = sum(temp_var_monthly(1:5,mind));
            end                 
        end
        
        
        
        monthly_losses{file_ind,1} = current_file;
        monthly_losses{file_ind,2} = {'Overhead Lines';'Underground Lines';'Secondary Transformers';'Triplex Lines';'Substation';'Total'};
        monthly_losses{file_ind,3} = temp_var_monthly/4;
        
        clear temp_var temp_var_annual temp_var_monthly;
    end
    
    % end losses
    
    % clear out the file we've opened
    eval(['clear ' current_file]);
    disp(['Finished ' current_file]);
end

%% Final clean-up and writing of output files
disp(['Writing output files']);

if (find_peak_day == 1)
    write_file = [write_dir 'peak_day_' tech '.mat'];
    save(write_file,'peak_day')
end
if (find_peakiest_peak == 1)
    write_file = [write_dir 'peakiest_peak_' tech '.mat'];
    save(write_file,'peakiest_peakday')
    if (find_monthly_values == 1)
        write_file = [write_dir 'peakiest_peak_monthly_' tech '.mat'];
        save(write_file,'peakiest_peakday_monthly');
    end
end
if (find_peak_15days == 1)
    write_file = [write_dir 'peak_15days_ ' tech '.mat'];
    save(write_file,'peak_15days')
end
if (find_peak_15wintdays == 1)
    write_file = [write_dir 'peak_15wintdays_' tech '.mat'];
    save(write_file,'peak_15wintdays')
end
if (find_total_energy_consumption == 1)
    write_file = [write_dir 'total_energy_consumption_' tech '.mat'];
    save(write_file,'energy_consumption');
    if (find_monthly_values == 1)
        write_file = [write_dir 'monthly_energy_consumption_' tech '.mat'];
        save(write_file,'monthly_energy_consumption');
    end
end
if (aggregate_bills == 1)
    write_file = [write_dir 'total_annual_revenue_' tech '.mat'];
    save(write_file,'total_annual_revenue');
end

if (find_voltages == 1)
    write_file = [write_dir 'feeder_voltages_' tech '.mat'];
    save(write_file,'feeder_voltages');
    if (find_all_voltages == 1)
        write_file = [write_dir 'all_feeder_voltages_' tech '.mat'];
        save(write_file,'all_feeder_voltages');
    end
end 

if (find_pf == 1)
    write_file = [write_dir 'power_factors_' tech '.mat'];
    save(write_file,'power_factor');
    if (find_monthly_values == 1)
        write_file = [write_dir 'monthly_power_factors_' tech '.mat'];
        save(write_file,'monthly_power_factor');
    end
end 

if (find_emissions == 1)
    write_file = [write_dir 'emissions_' tech '.mat'];
    save(write_file,'emissions_totals')
    if (find_monthly_values == 1)
        write_file = [write_dir 'emissions_monthly_' tech '.mat'];
        save(write_file,'emissions_totals_monthly');
    end
end

if (find_losses == 1)
    write_file = [write_dir 'annual_losses_' tech '.mat'];
    save(write_file,'annual_losses')
    if (find_monthly_values == 1)
        write_file = [write_dir 'monthly_losses_' tech '.mat'];
        save(write_file,'monthly_losses');
    end
end
disp('All done!');
clear;



