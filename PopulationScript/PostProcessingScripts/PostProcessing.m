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
find_peak_day = 0; % find the peak day and store day/time and value
find_peakiest_peak = 1;
find_peak_15days = 0; % find the 15 peakiest days and store the time series power for each day
find_peak_15wintdays = 0;
find_total_energy_consumption = 0; % sum the annual energy consumption
aggregate_bills = 0;
find_voltages = 0; % get the average and minimum voltages 
find_pf = 0; % min, max, and average

% secondary flag which may cross multiple layers of information
find_monthly_values = 1; % This grabs monthly values for each applicable data point

    
% outer loop for opening each file
for file_ind = 1:no_files
    voltage_ind = 1;
    
    % load the current file into the workspace
    current_file = char(strrep(data_files(file_ind),'.mat',''));
    load(current_file);
    
    % find the indexes for the start and end of each month
    %   we'll just do this once to save time, but this may need to be more
    %   flexible later
    if (find_monthly_values == 1 && file_ind == 1)
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
    
    if (find_total_energy_consumption == 1)
        eval(['temp_var = ' current_file '.transformerpower_power_out_real;']);
        
        sum_temp = sum(temp_var) / 4;
        
        % store the the value into a energy variable
        energy_consumption{file_ind,1} = current_file;
        energy_consumption{file_ind,2} = sum_temp;
        
        clear temp_var;
    end
    
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
            
            volt_mag = sqrt(temp_var1.^2 + temp_var2.^2);
            volt_ang_deg = tan(temp_var1./temp_var2) * 180 / pi;
            %TODO: minimums excluding zeros
            if (strfind(char(field_names(temp_ind(1))),'_A') ~= 0)
                min_A_test = min(volt_mag);
                avg_A_test = mean(volt_mag);
                if ((A_ind == 1 || (min_A_test < min_A)) && min_A_test ~= 0)
                    min_A = min_A_test;
                    avg_A = avg_A_test;
                end
                A_ind = A_ind + 1;
            elseif (strfind(char(field_names(temp_ind(1))),'_B') ~= 0)
                min_B_test = min(volt_mag);
                avg_B_test = mean(volt_mag);
                if ((B_ind == 1 || (min_B_test < min_B)) && min_B_test ~= 0)
                    min_B = min_B_test;
                    avg_B = avg_B_test;
                end
                B_ind = B_ind + 1;
            elseif (strfind(char(field_names(temp_ind(1))),'_C') ~= 0)
                min_C_test = min(volt_mag);
                avg_C_test = mean(volt_mag);
                if ((C_ind == 1 || (min_C_test < min_C)) && min_C_test ~= 0)
                    min_C = min_C_test;
                    avg_C = avg_C_test;
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
        clear min_A min_B min_C avg_A avg_B avg_C str_ind temp_str_ind volt_mag volt_ang_deg temp_var1 temp_var2;
    end
    
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
        clear Temp1 Temp2 Temp3 Temp4 Temp5 Temp6
       
    end
    
    

    % clear out the file we've opened
    eval(['clear ' current_file]);
    disp(['Finished ' current_file]);
end
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
end
if (aggregate_bills == 1)
    write_file = [write_dir 'total_annual_revenue_' tech '.mat'];
    save(write_file,'total_annual_revenue');
end

if (find_voltages == 1)
    write_file = [write_dir 'feeder_voltages_' tech '.mat'];
    save(write_file,'feeder_voltages');
end

if (find_pf == 1)
    write_file = [write_dir 'power_factors_' tech '.mat'];
    save(write_file,'power_factor');
end

disp('All done!');
clear;
