% This script is intended to compare results for the CVR study for the 2011
% ARRA Grant Analysis

% create 4/02/2011 by Jason Fuller


clear;
clc;

% Set the default text sizing
set_defaults();

% where to write the new data
%write_dir = 'C:\Users\D3X289\Documents\GLD_Analysis_2011\Gridlabd\Taxonomy_Feeders\PostAnalysis\ProcessedData\'; %Jason
write_dir = 'C:\Users\d3p313\Desktop\Post Processing Script\MAT Files\Consolodated MAT Files\'; %Kevin

% flags for types of plots
plot_energy = 0;
plot_peak_power = 0;
plot_EOL = 0;
plot_pf = 0;
plot_losses = 1;
plot_emissions = 0;

% secondary flags for sub-plots
plot_monthly_peak = 1;
plot_monthly_energy = 1;
plot_monthly_losses = 0;
plot_monthly_emissions = 1;
monthly_labels = {'Jan';'Feb';'Mar';'April';'May';'June';'July';'Aug';'Sept';'Oct';'Nov';'Dec'};

% load the energy consumption variable and save to a temp (since they have
% the same name)
%% Energy
if (plot_energy == 1)
    load([write_dir,'total_energy_consumption_t0.mat']);
    data_t0 = energy_consumption;
    load([write_dir,'total_energy_consumption_t1.mat']);
    data_t1 = energy_consumption;
    
    clear energy_consumption;
    
    data_labels = strrep(data_t0(:,1),'_t0','');
    data_labels = strrep(data_labels,'_','-');
    energy_data(:,1) = cell2mat(data_t0(:,2));
    energy_data(:,2) = cell2mat(data_t1(:,2));
    
    energy_reduction = energy_data(:,2) - energy_data(:,1);
    percent_energy_reduction = 100 .* energy_reduction ./ energy_data(:,1);
    
    % Total Energy Consuption
    fname = 'Annual Energy Consumption';
    set_figure_size(fname);
    hold on;
    bar(energy_data / 1000000,'barwidth',0.9);
    ylabel('Energy Consumption (MWh)');
    set_figure_graphics(data_labels,fname,1,'none',2,'northeastoutside');
    legend('Base Case','w/CVR')
    hold off;
    close(fname);
    
    % Change in Energy Consumption (MWh)
    fname = 'Change in Annual Energy Consuption (MWh)';
    set_figure_size(fname);
    hold on;
    bar(energy_reduction / 1000000);
    ylabel('Change in Energy Consumption (MWh)');
    set_figure_graphics(data_labels,fname,1,'none',0,'northeastoutside');
    hold off;
    close(fname);
    
    % Change in Energy Consumption (%)
    fname = 'Change in Annual Energy Consuption (%)';
    set_figure_size(fname);
    hold on;
    bar(percent_energy_reduction);
    ylabel('Change in Energy Consumption (%)');
    set_figure_graphics(data_labels,fname,2,'none',0,'northeastoutside');
    hold off;
    close(fname);
    
    % Plot the monthly energy
    clear data_t0 data_t1;
    
    if (plot_monthly_energy == 1)
        load([write_dir,'monthly_energy_consumption_t0.mat']);
        data_t0 = monthly_energy_consumption;
        load([write_dir,'monthly_energy_consumption_t1.mat']);
        data_t1 = monthly_energy_consumption;
        
        clear monthly_energy_consumption;
        
        [no_feeders cells] = size(data_t0);
        
        % forms an array of by feeder (rows) by month (cols) by tech (2 different variables)
        
        for kkind=1:no_feeders % by feeder
            clear peak_power_data peak_va_data;
            for jjind=1:12 % by month
                monthly_energy_data(jjind,1)=data_t0{kkind,2}(jjind); % Base Case
                monthly_energy_data(jjind,2)=data_t1{kkind,2}(jjind); % CVR
            end

            
            % Energy Consuption (MWh)
            fname = ['Monthly Energy MWh ' char(data_labels(kkind))];
            set_figure_size(fname);
            hold on;
            bar(monthly_energy_data / 1000000,'barwidth',0.9);
            ylabel('Energy Consumption (MWh)');
            my_legend = {'Base';'CVR'};
            set_figure_graphics(monthly_labels,fname,1,my_legend,0,'northeastoutside');
            hold off;
            close(fname);
            
        end
        
    end
end % End of energy plots
%% Peak power
if (plot_peak_power == 1)
    load([write_dir,'peakiest_peak_t0.mat']);
    data_t0 = peakiest_peakday;
    load([write_dir,'peakiest_peak_t1.mat']);
    data_t1 = peakiest_peakday;
    
    clear peakiest_peakday;
    
    data_labels = strrep(data_t0(:,1),'_t0','');
    data_labels = strrep(data_labels,'_','-');
    peak_power_data(:,1) = cell2mat(data_t0(:,2));
    peak_power_data(:,2) = cell2mat(data_t1(:,2));
    peak_va_data(:,1) = cell2mat(data_t0(:,3));
    peak_va_data(:,2) = cell2mat(data_t1(:,3));
    
    delta_peak_power = 100 * (peak_power_data(:,2) - peak_power_data(:,1)) ./ peak_power_data(:,1);
    delta_peak_va = 100 * (peak_va_data(:,2) - peak_va_data(:,1)) ./ peak_va_data(:,1);
    
    % Peak Demand (kW)
    fname = 'Peak Demand kW';
    set_figure_size(fname);
    hold on;
    bar(peak_power_data / 1000,'barwidth',0.9);
    ylabel('Peak Load (kW)');
    my_legend = {'Base Case';'w/CVR'};
    set_figure_graphics(data_labels,fname,1,my_legend,1,'northeastoutside');
    hold off;
    close(fname);
    
  
    % Change in Peak Demand (kW)
    fname = 'Change in Peak Demand kW';
    set_figure_size(fname);
    hold on;
    bar((peak_power_data(:,2)-peak_power_data(:,1))/1000);
    ylabel('Change in Peak Load (kW)');
    set_figure_graphics(data_labels,fname,1,'none',0,'northeastoutside');
    hold off;
    close(fname);
    
    % Change in Peak Demand (%)
    fname = 'Change in Peak Demand %';
    set_figure_size(fname);
    hold on;
    bar(delta_peak_power);
    ylabel('Change in Peak Load (%)');
    set_figure_graphics(data_labels,fname,2,'none',1.25,'northeastoutside');
    hold off;
    close(fname);
    
    % Plot the monthly peak demand
    clear data_t0 data_t1;
    
    if (plot_monthly_peak == 1)
        load([write_dir,'peakiest_peak_monthly_t0.mat']);
        data_t0 = peakiest_peakday_monthly;
        load([write_dir,'peakiest_peak_monthly_t1.mat']);
        data_t1 = peakiest_peakday_monthly;
        
        clear peakiest_peakday_monthly;
        
        [no_feeders cells] = size(data_t0);
        
        % forms an array of by feeder (rows) by month (cols) by tech (2
        % different variables
        
        for kkind=1:no_feeders % by feeder
            clear peak_power_data peak_va_data;
            for jjind=1:12 % by month
                peak_power_data(jjind,1) = data_t0{kkind,2}{jjind};
                peak_power_data(jjind,2) = data_t1{kkind,2}{jjind};
                peak_va_data(jjind,1) = data_t0{kkind,2}{jjind};
                peak_va_data(jjind,2) = data_t1{kkind,2}{jjind};
            end
            
            delta_peak_power = 100 * (peak_power_data(:,2) - peak_power_data(:,1)) ./ peak_power_data(:,1);
            delta_peak_va = 100 * (peak_va_data(:,2) - peak_va_data(:,1)) ./ peak_va_data(:,1);
            
            % Peak Demand (MW)
            fname = ['Peak Demand kW ' char(data_labels(kkind))];
            set_figure_size(fname);
            hold on;
            bar(peak_power_data / 1000,'barwidth',0.9);
            ylabel('Peak Load (kW)');
            %title('Peak Demand by Feeder');
            my_legend = {'Base Case';'w/CVR'};
            set_figure_graphics(monthly_labels,fname,1,my_legend,0,'northeastoutside');
            hold off;
            close(fname);
            
        end
      
    end
   
end % End of peak power plots
%% EOL Voltages
if (plot_EOL == 1)
    nominal_voltage_name = {'R1_1247_1_t0';'R1_1247_2_t0';'R1_1247_3_t0';'R1_1247_4_t0';'R1_2500_1_t0';...
        'R2_1247_1_t0';'R2_1247_2_t0';'R2_1247_3_t0';'R2_2500_1_t0';'R2_3500_1_t0';...
        'R3_1247_1_t0';'R3_1247_2_t0';'R3_1247_3_t0';'R4_1247_1_t0';'R4_1247_2_t0';...
        'R4_2500_1_t0';'R5_1247_1_t0';'R5_1247_2_t0';'R5_1247_3_t0';'R5_1247_4_t0';...
        'R5_1247_5_t0';'R5_2500_1_t0';'R5_3500_1_t0';...
        'GC_1247_1_t0_r1';'GC_1247_1_t0_r2';'GC_1247_1_t0_r3';'GC_1247_1_t0_r4';'GC_1247_1_t0_r5'};
    nominal_voltage = [12500;12470;12470;12470;24900;...
        12470;12470;12470;24900;34500;...
        12470;12470;12470;13800;12500;...
        24900;13800;12470;13800;12470;...
        12470;22900;34500;...
        12470;12470;12470;12470;12470] / sqrt(3);
    
    load([write_dir,'feeder_voltages_t0.mat']);
    data_t0 = feeder_voltages;
    load([write_dir,'feeder_voltages_t1.mat']);
    data_t1 = feeder_voltages;
    
    load([write_dir,'all_feeder_voltages_t0.mat']);
    data_t0_all = all_feeder_voltages;
    load([write_dir,'all_feeder_voltages_t1.mat']);
    data_t1_all = all_feeder_voltages;
    
    
    clear feeder_voltages;
    
    [a,b] = size(data_t0);
    for jind = 1:a
        temp_ind = strfind(nominal_voltage_name,char(data_t0(jind,1)));
        for kkind = 1:length(temp_ind)
            if (isempty(cell2mat(temp_ind(kkind))) == 1)
                temp_ind(kkind) = {0};
            end
        end
        temp_ind2 = cell2mat(temp_ind);
        temp_ind3 = find(temp_ind2,1);
        
        temp_data0 = 120*cell2mat(data_t0(jind,2:7)) / nominal_voltage(temp_ind3);
        voltage_data0(jind,:) = temp_data0;
        temp_data1 = 120*cell2mat(data_t1(jind,2:7)) / nominal_voltage(temp_ind3);
        voltage_data1(jind,:) = temp_data1;
    end
    
    data_labels = strrep(data_t0(:,1),'_t0','');
    data_labels = strrep(data_labels,'_','-');
    
    my_legend = {'phase a';'phase b';'phase c'};
    


% All EOL voltage information
[a,b] = size(data_t0_all);
for jind = 1:a
    
    temp_ind = strfind(nominal_voltage_name,char(data_t0(jind,1)));
    for kkind = 1:length(temp_ind)
        if (isempty(cell2mat(temp_ind(kkind))) == 1)
            temp_ind(kkind) = {0};
        end
    end
    temp_ind2 = cell2mat(temp_ind);
    temp_ind3 = find(temp_ind2,1);
        temp_data0_all = 120*cell2mat(data_t0_all(jind,3:3)) / nominal_voltage(temp_ind3);

        temp_data1_all = 120*cell2mat(data_t1_all(jind,3:3)) / nominal_voltage(temp_ind3);
        
        [c,d] = size(temp_data0_all);
        if c==1 % 1 EOL measurement
            voltage_data0_all(jind,1:6) = temp_data0_all(1,1:6);
            voltage_data1_all(jind,1:6) = temp_data1_all(1,1:6);
        elseif c==2 % 2 EOL measurement
            
            voltage_data0_all(jind,1:6) = temp_data0_all(1,1:6);
            voltage_data0_all(jind,7:12) = temp_data0_all(2,1:6);
            voltage_data1_all(jind,1:6) = temp_data1_all(1,1:6);
            voltage_data1_all(jind,7:12) = temp_data1_all(2,1:6);
            
        elseif c==6 % 2 EOL measurement
            
            voltage_data0_all(jind,1:6) = temp_data0_all(1,1:6);
            voltage_data0_all(jind,7:12) = temp_data0_all(2,1:6);
            voltage_data0_all(jind,13:18) = temp_data0_all(3,1:6);
            voltage_data0_all(jind,19:24) = temp_data0_all(4,1:6);
            voltage_data0_all(jind,25:30) = temp_data0_all(5,1:6);
            voltage_data0_all(jind,31:36) = temp_data0_all(6,1:6);
            
            
            voltage_data1_all(jind,1:6) = temp_data1_all(1,1:6);
            voltage_data1_all(jind,7:12) = temp_data1_all(2,1:6);
            voltage_data1_all(jind,13:18) = temp_data1_all(3,1:6);
            voltage_data1_all(jind,19:24) = temp_data1_all(4,1:6);
            voltage_data1_all(jind,25:30) = temp_data1_all(5,1:6);
            voltage_data1_all(jind,31:36) = temp_data1_all(6,1:6);
        else      
        end 
    end
% High Level EOL Plots

    % Minimum EOL Voltage Without CVR
    fname = 'Minimum EOL Voltage Without CVR';
    set_figure_size(fname);
    hold on;
    bar(voltage_data0_all(:,1:3),'barwidth',0.9);
    ylabel('Voltage (V)');
    %title('Minimum EOL Voltage Without CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    
    % Average EOL Voltage Without CVR
    fname = 'Average EOL Voltage Without CVR';
    set_figure_size(fname);
    hold on;
    bar(voltage_data0_all(:,4:6),'barwidth',0.9);
    ylabel('Voltage (V)');
    %title('Average EOL Voltage Without CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    
    % Minimum EOL Voltage With CVR
    fname = 'Minimum EOL Voltage With CVR';
    set_figure_size(fname);
    hold on;
    bar(voltage_data1_all(:,1:3),'barwidth',0.9);
    ylabel('Voltage (V)');
    %title('Minimum EOL Voltage With CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    
    % Average EOL Voltage With CVR
    fname = 'Average EOL Voltage With CVR';
    set_figure_size(fname);
    hold on;
    bar(voltage_data1_all(:,4:6),'barwidth',0.9);
    ylabel('Voltage (V)');
    %title('Average EOL Voltage With CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    
    % Plots for R1-25.00-1, R2-12.47-2, R3-12.47-3, abd R5-12.47-3 (multiple regulators)
    data_labels1={'EOL1-Amin','EOL1-Bmin','EOL1-Cmin','EOL1-Aavg','EOL1-Bavg','EOL1-Cavg'};
    data_labels2= {'EOL1-Amin','EOL1-Bmin','EOL1-Cmin','EOL1-Aavg','EOL1-Bavg','EOL1-Cavg','EOL2-Amin','EOL2-Bmin','EOL2-Cmin','EOL2-Aavg','EOL2-Bavg','EOL2-Cavg'};
    data_labels3= {'EOL1-Amin','EOL1-Bmin','EOL1-Cmin','EOL1-Aavg','EOL1-Bavg','EOL1-Cavg','EOL2-Amin','EOL2-Bmin','EOL2-Cmin','EOL2-Aavg','EOL2-Bavg','EOL2-Cavg','EOL3-Amin','EOL3-Bmin','EOL3-Cmin','EOL3-Aavg','EOL3-Bavg','EOL3-Cavg','EOL4-Amin','EOL4-Bmin','EOL4-Cmin','EOL4-Aavg','EOL4-Bavg','EOL1-Cavg','EOL5-Amin','EOL5-Bmin','EOL5-Cmin','EOL5-Aavg','EOL5-Bavg','EOL5-Cavg','EOL6-Amin','EOL6-Bmin','EOL6-Cmin','EOL6-Aavg','EOL6-Bavg','EOL1-Cavg'};
    my_legend = {'Base';'CVR'};
    
    % R1-25.00-1 EOL measurements
    fname = 'EOL for R1-2500-1';
    EOL_10(:,1)=(voltage_data0_all(10,:));
    EOL_10(:,2)=(voltage_data1_all(10,:));
    set_figure_size(fname);
    hold on;
    bar(EOL_10,'barwidth',0.9);
    ylabel('Voltage (V)');
    %title('Minimum EOL Voltage Without CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels2,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    
    % R2-12.47-2 EOL measurements
    fname = 'EOL for R2-1247-2';
    EOL_12(:,1)=(voltage_data0_all(12,:));
    EOL_12(:,2)=(voltage_data1_all(12,:));
    set_figure_size(fname);
    hold on;
    bar(EOL_12,'barwidth',0.9);
    ylabel('Voltage (V)');
    %title('Minimum EOL Voltage Without CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels2,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    
    % R4-12.47-2 EOL measurements
    fname = 'EOL for R4-1247-2';
    EOL_20(:,1)=(voltage_data0_all(20,:));
    EOL_20(:,2)=(voltage_data1_all(20,:));
    set_figure_size(fname);
    hold on;
    bar(EOL_20,'barwidth',0.9);
    ylabel('Voltage (V)');
    %title('Minimum EOL Voltage Without CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels1,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname); 
    
   
    % R5-12.47-3 EOL measurements
    fname = 'EOL for R5-1247-3';
    EOL_24(:,1)=(voltage_data0_all(24,:));
    EOL_24(:,2)=(voltage_data1_all(24,:));
    set_figure_size(fname);
    hold on;
    bar(EOL_24,'barwidth',0.9);
    ylabel('Voltage (V)');
    %title('Minimum EOL Voltage Without CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels3,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    

    
    
end % End of EOL plots
%% Power Factor
if plot_pf ==1
    % Load the data
    load([write_dir,'power_factors_t0.mat']);
    data_t0=power_factor;
    load([write_dir,'power_factors_t1.mat']);
    data_t1=power_factor;
    clear power_factor
    data_labels = strrep(data_t0(:,1),'_t0','');
    data_labels = strrep(data_labels,'_','-');
    energy_data(:,1) = cell2mat(data_t0(:,2));
    energy_data(:,2) = cell2mat(data_t1(:,2));
    
%     % Minimum power factor (Base Case)
%     
%     fname = 'Minimum Power Factor Base Case';
%     set_figure_size(fname);
%     hold on;
%     
%     pf(:,1)=cell2mat(data_t0(1:28,2:2)); % min phase a
%     pf(:,2)=cell2mat(data_t0(1:28,5:5)); % min phase b
%     pf(:,3)=cell2mat(data_t0(1:28,8:8)); % min phase c
%     pf(:,4)=cell2mat(data_t0(1:28,11:11)); % min phase a, b, and c
%     
%     bar(pf,'barwidth',0.9,'barwidth',0.9);
%     ylabel('Power Factor');
%     ylim([.5 1.0]);
%     my_legend = {'phase a';'phase b';'phase c';'total'};
%     set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
%     
%     hold off;
%     close(fname);
%     % Minimum power factor (CVR)
%     
%     fname = 'Minimum Power Factor CVR';
%     set_figure_size(fname);
%     hold on;
%     
%     pf(:,1)=cell2mat(data_t1(1:28,2:2)); % min phase a
%     pf(:,2)=cell2mat(data_t1(1:28,5:5)); % min phase b
%     pf(:,3)=cell2mat(data_t1(1:28,8:8)); % min phase c
%     pf(:,4)=cell2mat(data_t1(1:28,11:11)); % min phase a, b, and c
%     
%     bar(pf,'barwidth',0.9,'barwidth',0.9);
%     ylabel('Power Factor');
%     ylim([.5 1.0]);
%     my_legend = {'phase a';'phase b';'phase c';'total'};
%     set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
%     
%     hold off;
%     close (fname);
%     % Average power factor (Base Case)
%     
%     fname = 'Average Power Factor Base Case';
%     set_figure_size(fname);
%     hold on;
%     
%     pf(:,1)=cell2mat(data_t0(1:28,3:3)); % min phase a
%     pf(:,2)=cell2mat(data_t0(1:28,6:6)); % min phase b
%     pf(:,3)=cell2mat(data_t0(1:28,9:9)); % min phase c
%     pf(:,4)=cell2mat(data_t0(1:28,12:12)); % min phase a, b, and c
%     
%     bar(pf,'barwidth',0.9,'barwidth',0.9);
%     ylabel('Power Factor');
%     ylim([.5 1.0]);
%     my_legend = {'phase a';'phase b';'phase c';'total'};
%     set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
%     
%     hold off;
%     
%     close (fname);
%     % Average power factor (CVR)
%     fname = 'Average Power Factor CVR';
%     set_figure_size(fname);
%     hold on;
%     
%     pf(:,1)=cell2mat(data_t1(1:28,3:3)); % min phase a
%     pf(:,2)=cell2mat(data_t1(1:28,6:6)); % min phase b
%     pf(:,3)=cell2mat(data_t1(1:28,9:9)); % min phase c
%     pf(:,4)=cell2mat(data_t1(1:28,12:12)); % min phase a, b, and c
%     
%     bar(pf,'barwidth',0.9,'barwidth',0.9);
%     ylabel('Power Factor');
%     ylim([.5 1.0]);
%     my_legend = {'phase a';'phase b';'phase c';'total'};
%     set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
%     
%     hold off;
%     close (fname);
%     % Maximum power factor (Base Case)
%     fname = 'Maximum Power Factor Base Case';
%     set_figure_size(fname);
%     hold on;
%     
%     pf(:,1)=cell2mat(data_t0(1:28,4:4)); % min phase a
%     pf(:,2)=cell2mat(data_t0(1:28,7:7)); % min phase b
%     pf(:,3)=cell2mat(data_t0(1:28,10:10)); % min phase c
%     pf(:,4)=cell2mat(data_t0(1:28,13:13)); % min phase a, b, and c
%     
%     bar(pf,'barwidth',0.9,'barwidth',0.9);
%     ylabel('Power Factor');
%     ylim([.5 1.0]);
%     my_legend = {'phase a';'phase b';'phase c';'total'};
%     set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
%     
%     hold off;
%     close (fname);
%     % Maximum power factor (CVR)
%     fname = 'Maximum Power Factor CVR';
%     set_figure_size(fname);
%     hold on;
%     
%     pf(:,1)=cell2mat(data_t1(1:28,4:4)); % min phase a
%     pf(:,2)=cell2mat(data_t1(1:28,7:7)); % min phase b
%     pf(:,3)=cell2mat(data_t1(1:28,10:10)); % min phase c
%     pf(:,4)=cell2mat(data_t1(1:28,13:13)); % min phase a, b, and c
%     
%     bar(pf,'barwidth',0.9,'barwidth',0.9);
%     ylabel('Power Factor');
%     ylim([.5 1.0]);
%     my_legend = {'phase a';'phase b';'phase c';'total'};
%     set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
%     
%     hold off;
%     close(fname)
    
    % Compare Minimum power factor
    fname = 'Compare Minimum Power Factor Comparison';
    set_figure_size(fname);
    hold on;
    clear pf
    pf(:,1)=cell2mat(data_t0(1:28,11:11)); % min phase a, b, and c
    pf(:,2)=cell2mat(data_t1(1:28,11:11)); % min phase a, b, and c
    
    bar(pf,'barwidth',0.9,'barwidth',0.9);
    ylabel('Power Factor');
    ylim([.5 1.0]);
    my_legend = {'Base';'CVR'};
    set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    
    % Compare Average power factor
    fname = 'Compare Average Power Factor Comparison';
    set_figure_size(fname);
    hold on;
    clear pf
    pf(:,1)=cell2mat(data_t0(1:28,12:12)); % min phase a, b, and c
    pf(:,2)=cell2mat(data_t1(1:28,12:12)); % min phase a, b, and c
    
    bar(pf,'barwidth',0.9,'barwidth',0.9);
    ylabel('Power Factor');
    ylim([.9 1.0]);
    my_legend = {'Base';'CVR'};
    set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    
    % Compare Maximum power factor
    fname = 'Compare Maximum Power Factor Comparison';
    set_figure_size(fname);
    hold on;
    clear pf
    pf(:,1)=cell2mat(data_t0(1:28,13:13)); % min phase a, b, and c
    pf(:,2)=cell2mat(data_t1(1:28,13:13)); % min phase a, b, and c
    
    bar(pf,'barwidth',0.9,'barwidth',0.9);
    ylabel('Power Factor');
    ylim([.9 1.0]);
    my_legend = {'Base';'CVR'};
    set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    
end % End of power factor plots
%% Losses

if (plot_losses == 1)
    load([write_dir,'annual_losses_t0.mat']);
    data_t0 = annual_losses;
    load([write_dir,'annual_losses_t1.mat']);
    data_t1 = annual_losses;
    [no_feeders cells] = size(data_t0);
    clear anual_losses;
    
    data_labels = strrep(data_t0(:,1),'_t0','');
    data_labels = strrep(data_labels,'_','-');
for i=1:no_feeders
    loss_data(1,i) = data_t0{i,3}(6,1);
    loss_data(2,i) = data_t1{i,3}(6,1);
end

    
    % Total Losses
    my_legend = {'Base';'CVR'};
    fname = 'Annual Losses';
    set_figure_size(fname);
    hold on;
    bar(loss_data' / 1000000,'barwidth',0.9);
    ylabel('Energy Consumption (MWh)');
    set_figure_graphics(data_labels,fname,1,my_legend,0,'northeastoutside');
    
    hold off;
    close(fname);
    

    if (plot_monthly_losses == 1)
        
        load([write_dir,'monthly_losses_t0.mat']);
        data_t0 = monthly_losses;
        load([write_dir,'monthly_losses_t1.mat']);
        data_t1 = monthly_losses;
        
        clear monthly_losses;
        data_labels = strrep(data_t0(:,1),'_t0','');
        data_labels = strrep(data_labels,'_','-');
        
        %break
        % forms an array of by feeder (rows) by month (cols) by tech (2 different variables)
        
        for kkind=1:no_feeders % by feeder
            for jjind=1:12 % by month
                monthly_losses(jjind,1)=data_t0{kkind,3}(1,jjind); % Base Case OH
                monthly_losses(jjind,2)=data_t1{kkind,3}(1,jjind); % Base Case OH
                monthly_losses(jjind,3)=data_t0{kkind,3}(2,jjind); % Base Case UG
                monthly_losses(jjind,4)=data_t1{kkind,3}(2,jjind); % Base Case UG
                monthly_losses(jjind,5)=data_t0{kkind,3}(3,jjind); % Base Case XFMR
                monthly_losses(jjind,6)=data_t1{kkind,3}(3,jjind); % Base Case XFMR
                monthly_losses(jjind,7)=data_t0{kkind,3}(4,jjind); % Base Case Triplex
                monthly_losses(jjind,8)=data_t1{kkind,3}(4,jjind); % Base Case Triplex
            end
            
            
            % Energy Consuption (MWh)
            fname = ['Monthly Losses MWh ' char(data_labels(kkind))];
            set_figure_size(fname);
            hold on;
            bar(monthly_losses / 1000000,'barwidth',0.9);
            ylabel('Monthly Losses (MWh)');
            %title('Peak Demand by Feeder');
            my_legend = {'Overhead-Base';'Overhead-CVR';'Underground-Base';'Underground-CVR';'Transformer-Base';'Transformer-CVR';'Triplex-Base';'Triplex-CVR'};
            set_figure_graphics(monthly_labels,fname,1,my_legend,0,'northeastoutside');
            hold off;
            close(fname);
            
        end
        
    end

end % End of losses plots
%% Emissions
if (plot_emissions == 1)
    if (plot_monthly_emissions == 1)
        
        load([write_dir,'emissions_t0.mat']);
        data_t0 = emissions_totals;
        load([write_dir,'emissions_t1.mat']);
        data_t1 = emissions_totals;
        clear emissions_totals
    end
end% End of emissions plots
%clear;