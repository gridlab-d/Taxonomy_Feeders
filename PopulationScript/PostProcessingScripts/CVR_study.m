% This script is intended to compare results for the CVR study for the 2011
% ARRA Grant Analysis

% create 4/02/2011 by Jason Fuller


clear all;
clc;
format short g
% Set the default text sizing
set_defaults();

% where to write the new data
%write_dir = 'C:\Users\D3X289\Documents\GLD_Analysis_2011\Gridlabd\Taxonomy_Feeders\PostAnalysis\ProcessedData\'; %Jason
write_dir = 'C:\Users\d3p313\Desktop\Post Processing Script\MAT Files\Consolodated MAT Files\'; %Kevin

% flags for types of plots
plot_energy = 1;
plot_peak_power = 0;
plot_EOL = 0;
plot_pf = 0;
plot_losses = 0;
plot_emissions = 0;

% Flag for impact matrix
generate_impact_matrix = 0;

% secondary flags for sub-plots
plot_monthly_peak = 0;
plot_monthly_energy = 0;
plot_monthly_losses = 0;
plot_monthly_emissions = 0;
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
    fname = 't1_Comparison of annual energy consumption by feeder (MWh)';
    set_figure_size(fname);
    hold on;
    bar(energy_data / 1000000,'barwidth',0.9);
    ylabel('Energy Consumption (MWh)');
    my_legend={'Base','VVO'};
    set_figure_graphics(data_labels,fname,1,my_legend,2,'northeastoutside');
    hold off;
    close(fname);
    
    % Change in Energy Consumption (MWh)
    fname = 't1_Change in annual energy consumption by feeder (MWh)';
    set_figure_size(fname);
    hold on;
    bar(energy_reduction / 1000000);
    ylabel('Change in Energy Consumption (MWh)');
    set_figure_graphics(data_labels,fname,1,'none',0,'northeastoutside');
    hold off;
    close(fname);
    
    % Change in Energy Consumption (%)
    fname = 't1_Change in annual energy consumption by feeder (%)';
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
            fname = ['t1_Comparison of energy consumption by month for ' char(data_labels(kkind))];
            set_figure_size(fname);
            hold on;
            bar(monthly_energy_data / 1000000,'barwidth',0.9);
            ylabel('Energy Consumption (MWh)');
            my_legend = {'Base';'VVO'};
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
    fname = 't1_Compassion of peak demand by feeder';
    set_figure_size(fname);
    hold on;
    bar(peak_power_data / 1000,'barwidth',0.9);
    ylabel('Peak Load (kW)');
    my_legend = {'Base Case';'VVO'};
    set_figure_graphics(data_labels,fname,1,my_legend,1,'northeastoutside');
    hold off;
    close(fname);
    
    clear peak_va_data
  
    % Change in Peak Demand (kW)
    fname = 't1_Change in peak demand by feeder (kW)';
    set_figure_size(fname);
    hold on;
    bar((peak_power_data(:,2)-peak_power_data(:,1))/1000);
    ylabel('Change in Peak Load (kW)');
    set_figure_graphics(data_labels,fname,1,'none',0,'northeastoutside');
    hold off;
    close(fname);
    
    % Change in Peak Demand (%)
    fname = 't1_Change in peak demand by feeder (%)';
    set_figure_size(fname);
    hold on;
    bar(delta_peak_power);
    ylabel('Change in Peak Load (%)');
    set_figure_graphics(data_labels,fname,0,'none',.75,'northeastoutside');
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
            
            % Monthly Peak Demand (MW)
            fname = ['t1_Comparison of peak demand by month for ' char(data_labels(kkind))];
            set_figure_size(fname);
            hold on;
            bar(peak_power_data / 1000,'barwidth',0.9);
            ylabel('Peak Load (kW)');
            my_legend = {'Base Case';'VVO'};
            set_figure_graphics(monthly_labels,fname,1,my_legend,0,'northeastoutside');
            hold off;
            close(fname);
            
        end
      
    end
   clear peak_power_data peak_va_data
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
    fname = 't1_Minimum EOL voltage without CVR';
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
    fname = 't1_Average EOL voltage without CVR';
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
    fname = 't1_Minimum EOL voltage with CVR';
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
    fname = 't1_Average EOL voltage with CVR';
    set_figure_size(fname);
    hold on;
    bar(voltage_data1_all(:,4:6),'barwidth',0.9);
    ylabel('Voltage (V)');
    %title('Average EOL Voltage With CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    
%     % Plots for R1-25.00-1, R2-12.47-2, R3-12.47-3, abd R5-12.47-3 (multiple regulators)
%     data_labels1={'EOL1-Amin','EOL1-Bmin','EOL1-Cmin','EOL1-Aavg','EOL1-Bavg','EOL1-Cavg'};
%     data_labels2= {'EOL1-Amin','EOL1-Bmin','EOL1-Cmin','EOL1-Aavg','EOL1-Bavg','EOL1-Cavg','EOL2-Amin','EOL2-Bmin','EOL2-Cmin','EOL2-Aavg','EOL2-Bavg','EOL2-Cavg'};
%     data_labels3= {'EOL1-Amin','EOL1-Bmin','EOL1-Cmin','EOL1-Aavg','EOL1-Bavg','EOL1-Cavg','EOL2-Amin','EOL2-Bmin','EOL2-Cmin','EOL2-Aavg','EOL2-Bavg','EOL2-Cavg','EOL3-Amin','EOL3-Bmin','EOL3-Cmin','EOL3-Aavg','EOL3-Bavg','EOL3-Cavg','EOL4-Amin','EOL4-Bmin','EOL4-Cmin','EOL4-Aavg','EOL4-Bavg','EOL1-Cavg','EOL5-Amin','EOL5-Bmin','EOL5-Cmin','EOL5-Aavg','EOL5-Bavg','EOL5-Cavg','EOL6-Amin','EOL6-Bmin','EOL6-Cmin','EOL6-Aavg','EOL6-Bavg','EOL1-Cavg'};
%     my_legend = {'Base';'VVO'};
%     
%     % R1-25.00-1 EOL measurements
%     fname = 't1_EOL for R1-2500-1';
%     EOL_10(:,1)=(voltage_data0_all(10,:));
%     EOL_10(:,2)=(voltage_data1_all(10,:));
%     set_figure_size(fname);
%     hold on;
%     bar(EOL_10,'barwidth',0.9);
%     ylabel('Voltage (V)');
%     %title('Minimum EOL Voltage Without CVR');
%     ylim([110 130]);
%     set_figure_graphics(data_labels2,fname,0,my_legend,0,'northeastoutside');
%     hold off;
%     close(fname);
%     
%     % R2-12.47-2 EOL measurements
%     fname = 't1_EOL for R2-1247-2';
%     EOL_12(:,1)=(voltage_data0_all(12,:));
%     EOL_12(:,2)=(voltage_data1_all(12,:));
%     set_figure_size(fname);
%     hold on;
%     bar(EOL_12,'barwidth',0.9);
%     ylabel('Voltage (V)');
%     %title('Minimum EOL Voltage Without CVR');
%     ylim([110 130]);
%     set_figure_graphics(data_labels2,fname,0,my_legend,0,'northeastoutside');
%     hold off;
%     close(fname);
%     
%     % R4-12.47-2 EOL measurements
%     fname = 't1_EOL for R4-1247-2';
%     EOL_20(:,1)=(voltage_data0_all(20,:));
%     EOL_20(:,2)=(voltage_data1_all(20,:));
%     set_figure_size(fname);
%     hold on;
%     bar(EOL_20,'barwidth',0.9);
%     ylabel('Voltage (V)');
%     %title('Minimum EOL Voltage Without CVR');
%     ylim([110 130]);
%     set_figure_graphics(data_labels1,fname,0,my_legend,0,'northeastoutside');
%     hold off;
%     close(fname); 
%     
%    
%     % R5-12.47-3 EOL measurements
%     fname = 't1_EOL for R5-1247-3';
%     EOL_24(:,1)=(voltage_data0_all(24,:));
%     EOL_24(:,2)=(voltage_data1_all(24,:));
%     set_figure_size(fname);
%     hold on;
%     bar(EOL_24,'barwidth',0.9);
%     ylabel('Voltage (V)');
%     %title('Minimum EOL Voltage Without CVR');
%     ylim([110 130]);
%     set_figure_graphics(data_labels3,fname,0,my_legend,0,'northeastoutside');
%     hold off;
%     close(fname);
  
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
    
   
    % Compare Minimum power factor
    fname = 't1_Comparison of minimum annual power factor';
    set_figure_size(fname);
    hold on;
    clear pf
    pf(:,1)=cell2mat(data_t0(1:28,11:11)); % min phase a, b, and c
    pf(:,2)=cell2mat(data_t1(1:28,11:11)); % min phase a, b, and c
    
    bar(pf,'barwidth',0.9,'barwidth',0.9);
    ylabel('Power Factor');

    ylim([-1.0 1.0]);
    my_legend = {'Base';'VVO'};

    set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    % Compare Average power factor
    fname = 't1_Comparison of average annual power factor ';
    set_figure_size(fname);
    hold on;
    clear pf
    pf(:,1)=cell2mat(data_t0(1:28,12:12)); % min phase a, b, and c
    pf(:,2)=cell2mat(data_t1(1:28,12:12)); % min phase a, b, and c
    
    bar(pf,'barwidth',0.9,'barwidth',0.9);
    ylabel('Power Factor');
    ylim([.9 1.0]);
    my_legend = {'Base';'VVO'};
    set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    
%     % Compare Maximum power factor
%     fname = 't1_Compare Maximum Power Factor Comparison';
%     set_figure_size(fname);
%     hold on;
%     clear pf
%     pf(:,1)=cell2mat(data_t0(1:28,13:13)); % min phase a, b, and c
%     pf(:,2)=cell2mat(data_t1(1:28,13:13)); % min phase a, b, and c
%     
%     bar(pf,'barwidth',0.9,'barwidth',0.9);
%     ylabel('Power Factor');
%     ylim([.9 1.0]);
%     my_legend = {'Base';'VVO'};
%     set_figure_graphics(data_labels,fname,0,my_legend,0,'northeastoutside');
%     hold off;
%     close(fname);
    
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
        loss_data(i,1) = data_t0{i,3}(6,1);
        loss_data(i,2) = data_t1{i,3}(6,1);
    end

    loss_reduction= loss_data(:,2)-loss_data(:,1);
    percent_loss_reduction=100.*(loss_reduction/loss_data(i,1));

    
    % Total Losses
    my_legend = {'Base';'VVO'};
    fname = 't1_Comparison of total annual losses by feeder';
    set_figure_size(fname);
    hold on;
    bar(loss_data / 1000000,'barwidth',0.9);
    ylabel('Losses (MWh)');
    set_figure_graphics(data_labels,fname,1,my_legend,0,'northeastoutside');
    hold off;
    close(fname);
    
        
    % Change in Annual Losses (MWh)
    fname = 't1_Change in total annual losses by feeder (MWh)';
    set_figure_size(fname);
    hold on;
    bar(loss_reduction / 1000000,'barwidth',0.9);
    ylabel('Change in Losses (MWh)');
    set_figure_graphics(data_labels,fname,1,'none',0,'northeastoutside');
    hold off;
    close(fname);
%     
    % Change in Annual Losses (%)
    fname = 't1_Change in total annual losses by feeder (%)';
    set_figure_size(fname);
    hold on;
    bar(percent_loss_reduction,'barwidth',0.9);
    ylabel('Change in Losses (%)');
    set_figure_graphics(data_labels,fname,2,'none',1,'northeastoutside');
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
            fname = ['t1_Comparison of losses by month for ' char(data_labels(kkind))];
            set_figure_size(fname);
            hold on;
            bar(monthly_losses / 1000000,'barwidth',0.9);
            ylabel('Monthly Losses (MWh)');
            %title('Peak Demand by Feeder');
            my_legend = {'OHL-Base';'OHL-VVO';'UGL-Base';'UGL-VVO';'TFR-Base';'TFR-VVO';'TPL-Base';'TPL-VVO'};
            set_figure_graphics(monthly_labels,fname,1,my_legend,0,'northeastoutside');
            hold off;
            close(fname);
            
        end
        
    end

end % End of losses plots
%% Emissions
if (plot_emissions == 1)
    load([write_dir,'emissions_t0.mat']);
    data_t0 = emissions_totals;
    load([write_dir,'emissions_t1.mat']);
    data_t1 = emissions_totals;
    clear emissions_totals
    
    data_labels = strrep(data_t0(:,1),'_t0','');
    data_labels = strrep(data_labels,'_','-');
    
    emissions_data(:,1)=cell2mat(data_t0(:,2));
    emissions_data(:,2)=cell2mat(data_t1(:,2));
    percent_emissions_change=100*(emissions_data(:,2)-emissions_data(:,1))./emissions_data(:,2);
    
    
    % Total annual CO2 emissions
    fname = 't1_Comparison of total annual CO2 emission by feeder';
    set_figure_size(fname);
    hold on;
    bar(emissions_data,'barwidth',0.9);
    ylabel('CO2 Emissions (tons)');
    my_legend = {'Base';'VVO'};
    set_figure_graphics(data_labels,fname,1,my_legend,1,'northeastoutside');
    
    hold off;
    close(fname);
    
    % Change annual CO2 emissions (tons)
    fname = 't1_Change in total annual CO2 emissions by feeder (tons)';
    set_figure_size(fname);
    hold on;
    bar(emissions_data(:,2)-emissions_data(:,1));
    ylabel('Change in CO2 Emissions (tons)');
    set_figure_graphics(data_labels,fname,0,'none',0,'northeastoutside');
    hold off;
    close(fname);
%     
    % Change annual CO2 emissions (%)
    fname = 't1_Change in total annual CO2 emissions by feeder (%)';
    set_figure_size(fname);
    hold on;
    bar(percent_emissions_change);
    ylabel('Change in CO2 Emissions (%)');
    set_figure_graphics(data_labels,fname,2,'none',1,'northeastoutside');
    hold off;
    close(fname);
    
    
    
    if (plot_monthly_emissions == 1)
        
        load([write_dir,'emissions_monthly_t0.mat']);
        data_t0 = emissions_totals_monthly;
        load([write_dir,'emissions_monthly_t1.mat']);
        data_t1 = emissions_totals_monthly;
        clear emissions_totals
        [no_feeders cells] = size(data_t0);
        
        for kkind=1:no_feeders % by feeder
            for jjind=1:12 % by month
                monthly_emissions_data(jjind,1)=cell2mat(data_t0{kkind,2}(jjind)); % C02Base Case
                %                 monthly_emissions_data(jjind,3)=cell2mat(data_t0{kkind,3}(jjind)); % SOX Base Case
                %                 monthly_emissions_data(jjind,5)=cell2mat(data_t0{kkind,4}(jjind)); % NOX Base Case
                %                 monthly_emissions_data(jjind,7)=cell2mat(data_t0{kkind,5}(jjind)); % PM-10 Base Case
                
                
                monthly_emissions_data(jjind,2)=cell2mat(data_t1{kkind,2}(jjind)); % co2 cvr
                %                 monthly_emissions_data(jjind,4)=cell2mat(data_t0{kkind,3}(jjind)); % sox cvr
                %                 monthly_emissions_data(jjind,6)=cell2mat(data_t0{kkind,4}(jjind)); % nox cvr
                %                 monthly_emissions_data(jjind,8)=cell2mat(data_t0{kkind,5}(jjind)); % pm-10cvr
            end
            
            % energy consuption (mwh)
            
            fname = ['t1_Comparison of CO2 emissions by month for ' char(data_labels(kkind))];
            set_figure_size(fname);
            hold on;
            bar(monthly_emissions_data,'barwidth',0.9);
            ylabel('CO2 Emissions (tons)');
            my_legend = {'Base';'VVO'};
            set_figure_graphics(monthly_labels,fname,1,my_legend,0,'northeastoutside');
            hold off;
            close(fname);
        end
        
    end
end% End of emissions plots

%% Impact Matrix
% The index numbers are set by the indicies of 'impact_matrix' are specific for CVR

if ( generate_impact_matrix == 1)
    
    
    % Index 1 & 2 (Hourly & Monthly end use customer electricty usage)
    load([write_dir,'total_energy_consumption_t0.mat']);
    data_t0 = energy_consumption;
    load([write_dir,'total_energy_consumption_t1.mat']);
    data_t1 = energy_consumption;

    load([write_dir,'annual_losses_t0.mat']);
    data_t0_2 = annual_losses;
    load([write_dir,'annual_losses_t1.mat']);
    data_t1_2 = annual_losses;
    [no_feeders cells] = size(data_t0);
    clear  energy_consumption anual_losses;

    energy_data(:,1) = cell2mat(data_t0(:,2)); % t0 real power
    energy_data(:,2) = cell2mat(data_t1(:,2)); % t1 real power
    
    for i=1:length(data_t0)
        temp=cell2mat(data_t0_2(i,3)); % t0 losses
        temp2=cell2mat(data_t1_2(i,3)); % t1 losses
        energy_data(i,3)= temp(6,1);
        energy_data(i,4)= temp2(6,1);
        % t1 losses
    end
    
    hourly_customer_usage_t0(:,1)=(energy_data(:,1)-energy_data(:,3))/8760000; % Change in average hourly customer (kWh)
    monthly_customer_usage_t0(:,1)=(energy_data(:,1)-energy_data(:,3))/12000000; % Change in average monthly customer (MWh)
   
    hourly_customer_usage_t1(:,1)=(energy_data(:,2)-energy_data(:,4))/8760000; % Change in average hourly customer (kWh)
    monthly_customer_usage_t1(:,1)=(energy_data(:,2)-energy_data(:,4))/12000000; % Change in average monthly customer (MWh)
  
    matrix_index_t0=1;
    matrix_index_t1=1;
    impact_matrix_R1_t0(matrix_index_t0,1)=hourly_customer_usage_t0(1,1);
    impact_matrix_R1_t0(matrix_index_t0,2:6)=hourly_customer_usage_t0(6:10,1)';
    impact_matrix_R2_t0(matrix_index_t0,1)=hourly_customer_usage_t0(2,1);
    impact_matrix_R2_t0(matrix_index_t0,2:6)=hourly_customer_usage_t0(11:15,1)';
    impact_matrix_R3_t0(matrix_index_t0,1)=hourly_customer_usage_t0(3,1);
    impact_matrix_R3_t0(matrix_index_t0,2:4)=hourly_customer_usage_t0(16:18,1)';
    impact_matrix_R4_t0(matrix_index_t0,1)=hourly_customer_usage_t0(4,1);
    impact_matrix_R4_t0(matrix_index_t0,2:4)=hourly_customer_usage_t0(19:21,1)';
    impact_matrix_R5_t0(matrix_index_t0,1)=hourly_customer_usage_t0(5,1);
    impact_matrix_R5_t0(matrix_index_t0,2:8)=hourly_customer_usage_t0(22:28,1)';
    

    
    impact_matrix_R1_t1(matrix_index_t1,1)=hourly_customer_usage_t1(1,1);
    impact_matrix_R1_t1(matrix_index_t1,2:6)=hourly_customer_usage_t1(6:10,1)';
    impact_matrix_R2_t1(matrix_index_t1,1)=hourly_customer_usage_t1(2,1);
    impact_matrix_R2_t1(matrix_index_t1,2:6)=hourly_customer_usage_t1(11:15,1)';
    impact_matrix_R3_t1(matrix_index_t1,1)=hourly_customer_usage_t1(3,1);
    impact_matrix_R3_t1(matrix_index_t1,2:4)=hourly_customer_usage_t1(16:18,1)';
    impact_matrix_R4_t1(matrix_index_t1,1)=hourly_customer_usage_t1(4,1);
    impact_matrix_R4_t1(matrix_index_t1,2:4)=hourly_customer_usage_t1(19:21,1)';
    impact_matrix_R5_t1(matrix_index_t1,1)=hourly_customer_usage_t1(5,1);
    impact_matrix_R5_t1(matrix_index_t1,2:8)=hourly_customer_usage_t1(22:28,1)';
    
    matrix_index_t0=2;
    matrix_index_t1=2;
    impact_matrix_R1_t0(matrix_index_t0,1)=monthly_customer_usage_t0(1,1);
    impact_matrix_R1_t0(matrix_index_t0,2:6)=monthly_customer_usage_t0(6:10,1)';
    impact_matrix_R2_t0(matrix_index_t0,1)=monthly_customer_usage_t0(2,1);
    impact_matrix_R2_t0(matrix_index_t0,2:6)=monthly_customer_usage_t0(11:15,1)';
    impact_matrix_R3_t0(matrix_index_t0,1)=monthly_customer_usage_t0(3,1);
    impact_matrix_R3_t0(matrix_index_t0,2:4)=monthly_customer_usage_t0(16:18,1)';
    impact_matrix_R4_t0(matrix_index_t0,1)=monthly_customer_usage_t0(4,1);
    impact_matrix_R4_t0(matrix_index_t0,2:4)=monthly_customer_usage_t0(19:21,1)';
    impact_matrix_R5_t0(matrix_index_t0,1)=monthly_customer_usage_t0(5,1);
    impact_matrix_R5_t0(matrix_index_t0,2:8)=monthly_customer_usage_t0(22:28,1)';
    
    impact_matrix_R1_t1(matrix_index_t1,1)=monthly_customer_usage_t1(1,1);
    impact_matrix_R1_t1(matrix_index_t1,2:6)=monthly_customer_usage_t1(6:10,1)';
    impact_matrix_R2_t1(matrix_index_t1,1)=monthly_customer_usage_t1(2,1);
    impact_matrix_R2_t1(matrix_index_t1,2:6)=monthly_customer_usage_t1(11:15,1)';
    impact_matrix_R3_t1(matrix_index_t1,1)=monthly_customer_usage_t1(3,1);
    impact_matrix_R3_t1(matrix_index_t1,2:4)=monthly_customer_usage_t1(16:18,1)';
    impact_matrix_R4_t1(matrix_index_t1,1)=monthly_customer_usage_t1(4,1);
    impact_matrix_R4_t1(matrix_index_t1,2:4)=monthly_customer_usage_t1(19:21,1)';
    impact_matrix_R5_t1(matrix_index_t1,1)=monthly_customer_usage_t1(5,1);
    impact_matrix_R5_t1(matrix_index_t1,2:8)=monthly_customer_usage_t1(22:28,1)';

  
    clear data_t0 data_t1 data_t0_2 data_t1_2 hourly_customer_usage_t0 hourly_customer_usage_t1 monthly_customer_usage_t0 monthly_customer_usage_t1 temp temp2
    
    % Index 3 % 4(Peak generation % percentages and peak load)
    load([write_dir,'peakiest_peak_t0.mat']);
    data_t0 = peakiest_peakday;
    load([write_dir,'peakiest_peak_t1.mat']);
    data_t1 = peakiest_peakday;

    clear peakiest_peakday ;

    data_labels = strrep(data_t0(:,1),'_t0','');
    data_labels = strrep(data_labels,'_','-');
    peak_power_data(:,1) = cell2mat(data_t0(:,2));
    peak_power_data(:,2) = cell2mat(data_t1(:,2));
    peak_va_data(:,1) = cell2mat(data_t0(:,3));
    peak_va_data(:,2) = cell2mat(data_t1(:,3));
    
    peak_power_t0=peak_power_data(:,1)/1000; % Peak total demand for t0
    peak_power_t1=peak_power_data(:,2)/1000; % Peak total demand for t1
       
    matrix_index_t0=3;
    matrix_index_t1=3;
    impact_matrix_R1_t0(matrix_index_t0,1)=peak_power_t0(1,1);
    impact_matrix_R1_t0(matrix_index_t0,2:6)=peak_power_t0(6:10,1)';
    impact_matrix_R2_t0(matrix_index_t0,1)=peak_power_t0(2,1);
    impact_matrix_R2_t0(matrix_index_t0,2:6)=peak_power_t0(11:15,1)';
    impact_matrix_R3_t0(matrix_index_t0,1)=peak_power_t0(3,1);
    impact_matrix_R3_t0(matrix_index_t0,2:4)=peak_power_t0(16:18,1)';
    impact_matrix_R4_t0(matrix_index_t0,1)=peak_power_t0(4,1);
    impact_matrix_R4_t0(matrix_index_t0,2:4)=peak_power_t0(19:21,1)';
    impact_matrix_R5_t0(matrix_index_t0,1)=peak_power_t0(5,1);
    impact_matrix_R5_t0(matrix_index_t0,2:8)=peak_power_t0(22:28,1)';
    
    impact_matrix_R1_t1(matrix_index_t1,1)=peak_power_t1(1,1);
    impact_matrix_R1_t1(matrix_index_t1,2:6)=peak_power_t1(6:10,1)';
    impact_matrix_R2_t1(matrix_index_t1,1)=peak_power_t1(2,1);
    impact_matrix_R2_t1(matrix_index_t1,2:6)=peak_power_t1(11:15,1)';
    impact_matrix_R3_t1(matrix_index_t1,1)=peak_power_t1(3,1);
    impact_matrix_R3_t1(matrix_index_t1,2:4)=peak_power_t1(16:18,1)';
    impact_matrix_R4_t1(matrix_index_t1,1)=peak_power_t1(4,1);
    impact_matrix_R4_t1(matrix_index_t1,2:4)=peak_power_t1(19:21,1)';
    impact_matrix_R5_t1(matrix_index_t1,1)=peak_power_t1(5,1);
    impact_matrix_R5_t1(matrix_index_t1,2:8)=peak_power_t1(22:28,1)';
    
    % Generator percentages
    load([write_dir,'emissions_t0.mat']);
    data_t0_2 = emissions_totals;
    load([write_dir,'emissions_t1.mat']);
    data_t1_2 = emissions_totals;
    
    clear emissions_totals ;
    
    for i=1:length(data_labels)
        temp1(i,:)=cell2mat(data_t0_2(i,6)); % t0 percent generation for each feeder
        temp2(i,:)=cell2mat(data_t1_2(i,6)); % t1 percent generation for each feeder
    end
    
    % Seperate emissions by region
    Temp_R1(:,1)=temp1(1,:)';
    Temp_R1(:,2:6)=temp1(6:10,:)';
    Temp_R2(:,1)=temp1(2,:)';
    Temp_R2(:,2:6)=temp1(11:15,:)';
    Temp_R3(:,1)=temp1(3,:)';
    Temp_R3(:,2:4)=temp1(16:18,:)';
    Temp_R4(:,1)=temp1(4,:)';
    Temp_R4(:,2:4)=temp1(19:21,:)';
    Temp_R5(:,1)=temp1(5,:)';
    Temp_R5(:,2:8)=temp1(22:28,:)';
    
    Temp_R6(:,1)=temp2(1,:)';
    Temp_R6(:,2:6)=temp2(6:10,:)';
    Temp_R7(:,1)=temp2(2,:)';
    Temp_R7(:,2:6)=temp2(11:15,:)';
    Temp_R8(:,1)=temp2(3,:)';
    Temp_R8(:,2:4)=temp2(16:18,:)';
    Temp_R9(:,1)=temp2(4,:)';
    Temp_R9(:,2:4)=temp2(19:21,:)';
    Temp_R10(:,1)=temp2(5,:)';
    Temp_R10(:,2:8)=temp2(22:28,:)';
    
    
    % Switch some of the coulmns around to fit the final report format
    % Tech 0
    Temp_swap(1,:)=Temp_R1(5,:);
    Temp_R1(5,:)=Temp_R1(7,:);
    Temp_R1(7,:)=Temp_R1(6,:);
    Temp_R1(6,:)=Temp_swap(1,:);
    clear Temp_swap
    
    Temp_swap(1,:)=Temp_R2(6,:);
    Temp_R2(6,:)=Temp_R2(7,:);
    Temp_R2(7,:)=Temp_swap(1,:);
    clear Temp_swap
    Temp_swap(1,:)=Temp_R3(6,:);
    Temp_R3(6,:)=Temp_R3(7,:);
    Temp_R3(7,:)=Temp_swap(1,:);
    clear Temp_swap
    Temp_swap(1,:)=Temp_R4(6,:);
    Temp_R4(6,:)=Temp_R4(7,:);
    Temp_R4(7,:)=Temp_swap(1,:);
    clear Temp_swap
    Temp_swap(1,:)=Temp_R5(5,:);
    Temp_R5(5,:)=Temp_R5(6,:);
    Temp_R5(6,:)=Temp_R5(7,:);
    Temp_R5(7,:)=Temp_swap(1,:);
    clear Temp_swap
    % Tech 1
    Temp_swap(1,:)=Temp_R6(5,:);
    Temp_R6(5,:)=Temp_R6(7,:);
    Temp_R6(7,:)=Temp_R6(6,:);
    Temp_R6(6,:)=Temp_swap(1,:);
    clear Temp_swap
     
    Temp_swap(1,:)=Temp_R7(6,:);
    Temp_R7(6,:)=Temp_R7(7,:);
    Temp_R7(7,:)=Temp_swap(1,:);
    clear Temp_swap
    Temp_swap(1,:)=Temp_R8(6,:);
    Temp_R8(6,:)=Temp_R8(7,:);
    Temp_R8(7,:)=Temp_swap(1,:);
    clear Temp_swap
    Temp_swap(1,:)=Temp_R9(6,:);
    Temp_R9(6,:)=Temp_R9(7,:);
    Temp_R9(7,:)=Temp_swap(1,:);
    clear Temp_swap
    Temp_swap(1,:)=Temp_R10(5,:);
    Temp_R10(5,:)=Temp_R10(6,:);
    Temp_R10(6,:)=Temp_R10(7,:);
    Temp_R10(7,:)=Temp_swap(1,:);
    clear Temp_swap
    
    matrix_index_start_t0=4;
    matrix_index_stop_t0=12;
    impact_matrix_R1_t0(matrix_index_start_t0:matrix_index_stop_t0,1:6)=Temp_R1;
    impact_matrix_R2_t0(matrix_index_start_t0:matrix_index_stop_t0,1:6)=Temp_R2;
    impact_matrix_R3_t0(matrix_index_start_t0:matrix_index_stop_t0,1:4)=Temp_R3;
    impact_matrix_R4_t0(matrix_index_start_t0:matrix_index_stop_t0,1:4)=Temp_R4;
    impact_matrix_R5_t0(matrix_index_start_t0:matrix_index_stop_t0,1:8)=Temp_R5;
    
    
    matrix_index_start_t1=4;
    matrix_index_stop_t1=12;
    impact_matrix_R1_t1(matrix_index_start_t1:matrix_index_stop_t1,1:6)=Temp_R6;
    impact_matrix_R2_t1(matrix_index_start_t1:matrix_index_stop_t1,1:6)=Temp_R7;
    impact_matrix_R3_t1(matrix_index_start_t1:matrix_index_stop_t1,1:4)=Temp_R8;
    impact_matrix_R4_t1(matrix_index_start_t1:matrix_index_stop_t1,1:4)=Temp_R9;
    impact_matrix_R5_t1(matrix_index_start_t1:matrix_index_stop_t1,1:8)=Temp_R10;

    clear temp1 temp2 Temp_R1 Temp_R2 Temp_R3 Temp_R4 Temp_R5 Temp_R6 Temp_R7 Temp_R8 Temp_R9 Temp_R10 matrix_index_start matrix_index_stop
    
    % Fill in zero values for distributed solar and wind
    matrix_index_start_t0=13;
    matrix_index_stop_t0=14;
    for i=matrix_index_start_t0:matrix_index_stop_t0
        matrix_index=i;
        impact_matrix_R1_t0(matrix_index,1)=0;
        impact_matrix_R1_t0(matrix_index,2:6)=0;
        impact_matrix_R2_t0(matrix_index,1)=0;
        impact_matrix_R2_t0(matrix_index,2:6)=0;
        impact_matrix_R3_t0(matrix_index,1)=0;
        impact_matrix_R3_t0(matrix_index,2:4)=0;
        impact_matrix_R4_t0(matrix_index,1)=0;
        impact_matrix_R4_t0(matrix_index,2:4)=0;
        impact_matrix_R5_t0(matrix_index,1)=0;
        impact_matrix_R5_t0(matrix_index,2:8)=0;
        
        
    end
    
    matrix_index_start_t1=13;
    matrix_index_stop_t1=14;
    for i=matrix_index_start_t1:matrix_index_stop_t1
        matrix_index=i;
        impact_matrix_R1_t1(matrix_index,1)=0;
        impact_matrix_R1_t1(matrix_index,2:6)=0;
        impact_matrix_R2_t1(matrix_index,1)=0;
        impact_matrix_R2_t1(matrix_index,2:6)=0;
        impact_matrix_R3_t1(matrix_index,1)=0;
        impact_matrix_R3_t1(matrix_index,2:4)=0;
        impact_matrix_R4_t1(matrix_index,1)=0;
        impact_matrix_R4_t1(matrix_index,2:4)=0;
        impact_matrix_R5_t1(matrix_index,1)=0;
        impact_matrix_R5_t1(matrix_index,2:8)=0;
        
    end

 
    peak_demand_t0=(cell2mat(data_t0(:,2))-cell2mat(data_t0(:,4)))/1000; % Peak end use demand for t0
    peak_demand_t1=(cell2mat(data_t1(:,2))-cell2mat(data_t0(:,4)))/1000; % Peak end use demand for t1
    % Convert to kW
    
    matrix_index_t0=15;
    impact_matrix_R1_t0(matrix_index_t0,1)=peak_demand_t0(1,1);
    impact_matrix_R1_t0(matrix_index_t0,2:6)=peak_demand_t0(6:10,1)';
    impact_matrix_R2_t0(matrix_index_t0,1)=peak_demand_t0(2,1);
    impact_matrix_R2_t0(matrix_index_t0,2:6)=peak_demand_t0(11:15,1)';
    impact_matrix_R3_t0(matrix_index_t0,1)=peak_demand_t0(3,1);
    impact_matrix_R3_t0(matrix_index_t0,2:4)=peak_demand_t0(16:18,1)';
    impact_matrix_R4_t0(matrix_index_t0,1)=peak_demand_t0(4,1);
    impact_matrix_R4_t0(matrix_index_t0,2:4)=peak_demand_t0(19:21,1)';
    impact_matrix_R5_t0(matrix_index_t0,1)=peak_demand_t0(5,1);
    impact_matrix_R5_t0(matrix_index_t0,2:8)=peak_demand_t0(22:28,1)';
   
    matrix_index_t1=15;
    impact_matrix_R1_t1(matrix_index_t1,1)=peak_demand_t1(1,1);
    impact_matrix_R1_t1(matrix_index_t1,2:6)=peak_demand_t1(6:10,1)';
    impact_matrix_R2_t1(matrix_index_t1,1)=peak_demand_t1(2,1);
    impact_matrix_R2_t1(matrix_index_t1,2:6)=peak_demand_t1(11:15,1)';
    impact_matrix_R3_t1(matrix_index_t1,1)=peak_demand_t1(3,1);
    impact_matrix_R3_t1(matrix_index_t1,2:4)=peak_demand_t1(16:18,1)';
    impact_matrix_R4_t1(matrix_index_t1,1)=peak_demand_t1(4,1);
    impact_matrix_R4_t1(matrix_index_t1,2:4)=peak_demand_t1(19:21,1)';
    impact_matrix_R5_t1(matrix_index_t1,1)=peak_demand_t1(5,1);
    impact_matrix_R5_t1(matrix_index_t1,2:8)=peak_demand_t1(22:28,1)';

    % Controllable load is 0% for CVR
    matrix_index_t0=16;
    impact_matrix_R1_t0(matrix_index_t0,1)=0;
    impact_matrix_R1_t0(matrix_index_t0,2:6)=0';
    impact_matrix_R2_t0(matrix_index_t0,1)=0;
    impact_matrix_R2_t0(matrix_index_t0,2:6)=0;
    impact_matrix_R3_t0(matrix_index_t0,1)=0;
    impact_matrix_R3_t0(matrix_index_t0,2:4)=0;
    impact_matrix_R4_t0(matrix_index_t0,1)=0;
    impact_matrix_R4_t0(matrix_index_t0,2:4)=0;
    impact_matrix_R5_t0(matrix_index_t0,1)=0;
    impact_matrix_R5_t0(matrix_index_t0,2:8)=0;
    
    matrix_index_t1=16;
    impact_matrix_R1_t1(matrix_index_t1,1)=0;
    impact_matrix_R1_t1(matrix_index_t1,2:6)=0;
    impact_matrix_R2_t1(matrix_index_t1,1)=0;
    impact_matrix_R2_t1(matrix_index_t1,2:6)=0;
    impact_matrix_R3_t1(matrix_index_t1,1)=0;
    impact_matrix_R3_t1(matrix_index_t1,2:4)=0;
    impact_matrix_R4_t1(matrix_index_t1,1)=0;
    impact_matrix_R4_t1(matrix_index_t1,2:4)=0;
    impact_matrix_R5_t1(matrix_index_t1,1)=0;
    impact_matrix_R5_t1(matrix_index_t1,2:8)=0;
    
    clear data_t0 data_t1 data_t0 data_t1 peak_demand_t0 peak_demand_t1 peak_power_t0 peak_power_t1 peak_va_data peak_power_data
    
    % Index 7 (Annual Electricty production) % Index 21 (Distribution Feeder Load)
    load([write_dir,'total_energy_consumption_t0.mat']);
    data_t0 = energy_consumption;
    load([write_dir,'total_energy_consumption_t1.mat']);
    data_t1 = energy_consumption;
    
    clear energy_consumption;
    
    data_labels = strrep(data_t0(:,1),'_t0','');
    data_labels = strrep(data_labels,'_','-');
    energy_data(:,1) = cell2mat(data_t0(:,2)); % t0 real power
    energy_data(:,2) = cell2mat(data_t1(:,2)); % t1 real power
    energy_data(:,3) = cell2mat(data_t0(:,3)); % t0 reactive power
    energy_data(:,4) = cell2mat(data_t1(:,3)); % t1 reactive power

    energy_consuption_t0=energy_data(:,1)/1000000;
    energy_consuption_t1=energy_data(:,2)/1000000;
    
    matrix_index_t0=17;
    impact_matrix_R1_t0(matrix_index_t0,1)=energy_consuption_t0(1,1); %GC
    impact_matrix_R1_t0(matrix_index_t0,2:6)=energy_consuption_t0(6:10,1)';
    impact_matrix_R2_t0(matrix_index_t0,1)=energy_consuption_t0(2,1); %GC
    impact_matrix_R2_t0(matrix_index_t0,2:6)=energy_consuption_t0(11:15,1)';
    impact_matrix_R3_t0(matrix_index_t0,1)=energy_consuption_t0(3,1); %GC
    impact_matrix_R3_t0(matrix_index_t0,2:4)=energy_consuption_t0(16:18,1)';
    impact_matrix_R4_t0(matrix_index_t0,1)=energy_consuption_t0(4,1); %GC
    impact_matrix_R4_t0(matrix_index_t0,2:4)=energy_consuption_t0(19:21,1)';
    impact_matrix_R5_t0(matrix_index_t0,1)=energy_consuption_t0(5,1); %GC
    impact_matrix_R5_t0(matrix_index_t0,2:8)=energy_consuption_t0(22:28,1)';
    
    matrix_index_t1=17;
    impact_matrix_R1_t1(matrix_index_t1,1)=energy_consuption_t1(1,1); %GC
    impact_matrix_R1_t1(matrix_index_t1,2:6)=energy_consuption_t1(6:10,1)';
    impact_matrix_R2_t1(matrix_index_t1,1)=energy_consuption_t1(2,1); %GC
    impact_matrix_R2_t1(matrix_index_t1,2:6)=energy_consuption_t1(11:15,1)';
    impact_matrix_R3_t1(matrix_index_t1,1)=energy_consuption_t1(3,1); %GC
    impact_matrix_R3_t1(matrix_index_t1,2:4)=energy_consuption_t1(16:18,1)';
    impact_matrix_R4_t1(matrix_index_t1,1)=energy_consuption_t1(4,1); %GC
    impact_matrix_R4_t1(matrix_index_t1,2:4)=energy_consuption_t1(19:21,1)';
    impact_matrix_R5_t1(matrix_index_t1,1)=energy_consuption_t1(5,1); %GC
    impact_matrix_R5_t1(matrix_index_t1,2:8)=energy_consuption_t1(22:28,1)';
    
    % Average hourly feeder loading (Index 21)
    energy_average_hourly_t0=energy_data(:,1)/8760000; % real power (kWH)
    energy_average_hourly_t1=energy_data(:,2)/8760000; % real power (kWH)
    
    energy_average_hourly_t0(:,2)=energy_data(:,3)/8760000; % reactive power (kVAR)
    energy_average_hourly_t1(:,2)=energy_data(:,4)/8760000; % reactive power (kVAR)
    
    % real power
    matrix_index_t0=25;
    impact_matrix_R1_t0(matrix_index_t0,1)=energy_average_hourly_t0(1,1); %GC
    impact_matrix_R1_t0(matrix_index_t0,2:6)=energy_average_hourly_t0(6:10,1)';
    impact_matrix_R2_t0(matrix_index_t0,1)=energy_average_hourly_t0(2,1); %GC
    impact_matrix_R2_t0(matrix_index_t0,2:6)=energy_average_hourly_t0(11:15,1)';
    impact_matrix_R3_t0(matrix_index_t0,1)=energy_average_hourly_t0(3,1); %GC
    impact_matrix_R3_t0(matrix_index_t0,2:4)=energy_average_hourly_t0(16:18,1)';
    impact_matrix_R4_t0(matrix_index_t0,1)=energy_average_hourly_t0(4,1); %GC
    impact_matrix_R4_t0(matrix_index_t0,2:4)=energy_average_hourly_t0(19:21,1)';
    impact_matrix_R5_t0(matrix_index_t0,1)=energy_average_hourly_t0(5,1); %GC
    impact_matrix_R5_t0(matrix_index_t0,2:8)=energy_average_hourly_t0(22:28,1)';
    
    matrix_index_t1=22;
    impact_matrix_R1_t1(matrix_index_t1,1)=energy_average_hourly_t1(1,1); %GC
    impact_matrix_R1_t1(matrix_index_t1,2:6)=energy_average_hourly_t1(6:10,1)';
    impact_matrix_R2_t1(matrix_index_t1,1)=energy_average_hourly_t1(2,1); %GC
    impact_matrix_R2_t1(matrix_index_t1,2:6)=energy_average_hourly_t1(11:15,1)';
    impact_matrix_R3_t1(matrix_index_t1,1)=energy_average_hourly_t1(3,1); %GC
    impact_matrix_R3_t1(matrix_index_t1,2:4)=energy_average_hourly_t1(16:18,1)';
    impact_matrix_R4_t1(matrix_index_t1,1)=energy_average_hourly_t1(4,1); %GC
    impact_matrix_R4_t1(matrix_index_t1,2:4)=energy_average_hourly_t1(19:21,1)';
    impact_matrix_R5_t1(matrix_index_t1,1)=energy_average_hourly_t1(5,1); %GC
    impact_matrix_R5_t1(matrix_index_t1,2:8)=energy_average_hourly_t1(22:28,1)';
    
    % Reactive power
    matrix_index_t0=26;
    impact_matrix_R1_t0(matrix_index_t0,1)=energy_average_hourly_t0(1,2); %GC
    impact_matrix_R1_t0(matrix_index_t0,2:6)=energy_average_hourly_t0(6:10,2)';
    impact_matrix_R2_t0(matrix_index_t0,1)=energy_average_hourly_t0(2,2); %GC
    impact_matrix_R2_t0(matrix_index_t0,2:6)=energy_average_hourly_t0(11:15,2)';
    impact_matrix_R3_t0(matrix_index_t0,1)=energy_average_hourly_t0(3,2); %GC
    impact_matrix_R3_t0(matrix_index_t0,2:4)=energy_average_hourly_t0(16:18,2)';
    impact_matrix_R4_t0(matrix_index_t0,1)=energy_average_hourly_t0(4,2); %GC
    impact_matrix_R4_t0(matrix_index_t0,2:4)=energy_average_hourly_t0(19:21,2)';
    impact_matrix_R5_t0(matrix_index_t0,1)=energy_average_hourly_t0(5,2); %GC
    impact_matrix_R5_t0(matrix_index_t0,2:8)=energy_average_hourly_t0(22:28,2)';
    
    matrix_index_t1=23;
    impact_matrix_R1_t1(matrix_index_t1,1)=energy_average_hourly_t1(1,2); %GC
    impact_matrix_R1_t1(matrix_index_t1,2:6)=energy_average_hourly_t1(6:10,2)';
    impact_matrix_R2_t1(matrix_index_t1,1)=energy_average_hourly_t1(2,2); %GC
    impact_matrix_R2_t1(matrix_index_t1,2:6)=energy_average_hourly_t1(11:15,2)';
    impact_matrix_R3_t1(matrix_index_t1,1)=energy_average_hourly_t1(3,2); %GC
    impact_matrix_R3_t1(matrix_index_t1,2:4)=energy_average_hourly_t1(16:18,2)';
    impact_matrix_R4_t1(matrix_index_t1,1)=energy_average_hourly_t1(4,2); %GC
    impact_matrix_R4_t1(matrix_index_t1,2:4)=energy_average_hourly_t1(19:21,2)';
    impact_matrix_R5_t1(matrix_index_t1,1)=energy_average_hourly_t1(5,2); %GC
    impact_matrix_R5_t1(matrix_index_t1,2:8)=energy_average_hourly_t1(22:28,2)';
    
    clear data_t0 data_t1 energy_average_hourly_t0 energy_average_hourly_t1 energy_average_hourly_t0 energy_average_hourly_t1 energy_consuption_t0 energy_consuption_t1
    
    % Index 29 (Distribution Losses)
    load([write_dir,'total_energy_consumption_t0.mat']);
    data_t0 = energy_consumption;
    load([write_dir,'total_energy_consumption_t1.mat']);
    data_t1 = energy_consumption;
    
    load([write_dir,'annual_losses_t0.mat']);
    data_t0_2 = annual_losses;
    load([write_dir,'annual_losses_t1.mat']);
    data_t1_2 = annual_losses;
    
    [no_feeders cells] = size(data_t0);
    clear  energy_consumption anual_losses;

    energy_data(:,1) = cell2mat(data_t0(:,2)); % t0 real power
    energy_data(:,2) = cell2mat(data_t1(:,2)); % t1 real power
    
    for i=1:length(data_t0)
        temp=cell2mat(data_t0_2(i,3)); % t0 losses
        temp2=cell2mat(data_t1_2(i,3)); % t1 losses
        energy_data(i,3)= temp(6,1);
        energy_data(i,4)= temp2(6,1);
        % t1 losses
    end
    losses_t0=100*(energy_data(:,3)./energy_data(:,1)); % Losses t0 in %
    losses_t1=100*(energy_data(:,4)./energy_data(:,2)); % Losses t1 in %

    matrix_index_t0=27;
    impact_matrix_R1_t0(matrix_index_t0,1)=losses_t0(1,1);
    impact_matrix_R1_t0(matrix_index_t0,2:6)=losses_t0(6:10,1)';
    impact_matrix_R2_t0(matrix_index_t0,1)=losses_t0(2,1);
    impact_matrix_R2_t0(matrix_index_t0,2:6)=losses_t0(11:15,1)';
    impact_matrix_R3_t0(matrix_index_t0,1)=losses_t0(3,1);
    impact_matrix_R3_t0(matrix_index_t0,2:4)=losses_t0(16:18,1)';
    impact_matrix_R4_t0(matrix_index_t0,1)=losses_t0(4,1);
    impact_matrix_R4_t0(matrix_index_t0,2:4)=losses_t0(19:21,1)';
    impact_matrix_R5_t0(matrix_index_t0,1)=losses_t0(5,1);
    impact_matrix_R5_t0(matrix_index_t0,2:8)=losses_t0(22:28,1)';
    
    matrix_index_t1=24;
    impact_matrix_R1_t1(matrix_index_t1,1)=losses_t1(1,1);
    impact_matrix_R1_t1(matrix_index_t1,2:6)=losses_t1(6:10,1)';
    impact_matrix_R2_t1(matrix_index_t1,1)=losses_t1(2,1);
    impact_matrix_R2_t1(matrix_index_t1,2:6)=losses_t1(11:15,1)';
    impact_matrix_R3_t1(matrix_index_t1,1)=losses_t1(3,1);
    impact_matrix_R3_t1(matrix_index_t1,2:4)=losses_t1(16:18,1)';
    impact_matrix_R4_t1(matrix_index_t1,1)=losses_t1(4,1);
    impact_matrix_R4_t1(matrix_index_t1,2:4)=losses_t1(19:21,1)';
    impact_matrix_R5_t1(matrix_index_t1,1)=losses_t1(5,1);
    impact_matrix_R5_t1(matrix_index_t1,2:8)=losses_t1(22:28,1)';
    
    clear data_t0 data_t1 data_t0_2 data_t1_2 energy_data losses_t0 losses_t1 temp tem2

    % Index 30 (Power Factor)
    
    load([write_dir,'power_factors_t0.mat']);
    data_t0 = power_factor;
    load([write_dir,'power_factors_t1.mat']);
    data_t1 = power_factor;
    [no_feeders cells] = size(data_t0);
    clear  energy_consuption anual_losses;
    clear power_factor

    power_factor_t0=cell2mat(data_t0(:,12)); % Average annual power factor for t0
    power_factor_t1=cell2mat(data_t1(:,12)); % Average annual power factor for t1
    
    matrix_index_t0=28;
    impact_matrix_R1_t0(matrix_index_t0,1)=power_factor_t0(1,1);
    impact_matrix_R1_t0(matrix_index_t0,2:6)=power_factor_t0(6:10,1)';
    impact_matrix_R2_t0(matrix_index_t0,1)=power_factor_t0(2,1);
    impact_matrix_R2_t0(matrix_index_t0,2:6)=power_factor_t0(11:15,1)';
    impact_matrix_R3_t0(matrix_index_t0,1)=power_factor_t0(3,1);
    impact_matrix_R3_t0(matrix_index_t0,2:4)=power_factor_t0(16:18,1)';
    impact_matrix_R4_t0(matrix_index_t0,1)=power_factor_t0(4,1);
    impact_matrix_R4_t0(matrix_index_t0,2:4)=power_factor_t0(19:21,1)';
    impact_matrix_R5_t0(matrix_index_t0,1)=power_factor_t0(5,1);
    impact_matrix_R5_t0(matrix_index_t0,2:8)=power_factor_t0(22:28,1)';
    
    matrix_index_t1=25;
    impact_matrix_R1_t1(matrix_index_t1,1)=power_factor_t1(1,1);
    impact_matrix_R1_t1(matrix_index_t1,2:6)=power_factor_t1(6:10,1)';
    impact_matrix_R2_t1(matrix_index_t1,1)=power_factor_t1(2,1);
    impact_matrix_R2_t1(matrix_index_t1,2:6)=power_factor_t1(11:15,1)';
    impact_matrix_R3_t1(matrix_index_t1,1)=power_factor_t1(3,1);
    impact_matrix_R3_t1(matrix_index_t1,2:4)=power_factor_t1(16:18,1)';
    impact_matrix_R4_t1(matrix_index_t1,1)=power_factor_t1(4,1);
    impact_matrix_R4_t1(matrix_index_t1,2:4)=power_factor_t1(19:21,1)';
    impact_matrix_R5_t1(matrix_index_t1,1)=power_factor_t1(5,1);
    impact_matrix_R5_t1(matrix_index_t1,2:8)=power_factor_t1(22:28,1)';
    
    clear data_t0 data_t1 power_factor_t0 power_factor_t1
   
% Index 12, 13, 39 & 40 (end use emissions & total emissions)
    load([write_dir,'emissions_t0.mat']);
    data_t0 = emissions_totals;
    load([write_dir,'emissions_t1.mat']);
    data_t1 = emissions_totals;

    clear emissions_totals ;
    
    temp1=cell2mat(data_t0(1:28,2:5)');
    temp2=cell2mat(data_t1(1:28,2:5)');
    
    % Base Case
    Temp_R1(:,1)=temp1(:,1); %CO2
    Temp_R1(:,2:6)=temp1(:,6:10); %SoX, NoX, PM-10 
    Temp_R2(:,1)=temp1(:,2);
    Temp_R2(:,2:6)=temp1(:,11:15);
    Temp_R3(:,1)=temp1(:,3);
    Temp_R3(:,2:4)=temp1(:,16:18);
    Temp_R4(:,1)=temp1(:,4);
    Temp_R4(:,2:4)=temp1(:,19:21);
    Temp_R5(:,1)=temp1(:,5);
    Temp_R5(:,2:8)=temp1(:,22:28);
    
    % t1
    Temp_R6(:,1)=temp2(:,1); %CO2
    Temp_R6(:,2:6)=temp2(:,6:10); %SoX, NoX, PM-10 
    Temp_R7(:,1)=temp2(:,2);
    Temp_R7(:,2:6)=temp2(:,11:15);
    Temp_R8(:,1)=temp2(:,3);
    Temp_R8(:,2:4)=temp2(:,16:18);
    Temp_R9(:,1)=temp2(:,4);
    Temp_R9(:,2:4)=temp2(:,19:21);
    Temp_R10(:,1)=temp2(:,5);
    Temp_R10(:,2:8)=temp2(:,22:28);
    
    % Emission to supply all load (including losses)
    matrix_index_start_t0=29;
    matrix_index_stop_t0=32;
    
    impact_matrix_R1_t0(matrix_index_start_t0:matrix_index_stop_t0,1:6)=Temp_R1;
    impact_matrix_R2_t0(matrix_index_start_t0:matrix_index_stop_t0,1:6)=Temp_R2;
    impact_matrix_R3_t0(matrix_index_start_t0:matrix_index_stop_t0,1:4)=Temp_R3;
    impact_matrix_R4_t0(matrix_index_start_t0:matrix_index_stop_t0,1:4)=Temp_R4;
    impact_matrix_R5_t0(matrix_index_start_t0:matrix_index_stop_t0,1:8)=Temp_R5;
    
    matrix_index_start_t1=26;
    matrix_index_stop_t1=29;
    
    impact_matrix_R1_t1(matrix_index_start_t1:matrix_index_stop_t1,1:6)=Temp_R6;
    impact_matrix_R2_t1(matrix_index_start_t1:matrix_index_stop_t1,1:6)=Temp_R7;
    impact_matrix_R3_t1(matrix_index_start_t1:matrix_index_stop_t1,1:4)=Temp_R8;
    impact_matrix_R4_t1(matrix_index_start_t1:matrix_index_stop_t1,1:4)=Temp_R9;
    impact_matrix_R5_t1(matrix_index_start_t1:matrix_index_stop_t1,1:8)=Temp_R10;
    
    % Emission to supply the end user
    matrix_index_start_t0=18;
    matrix_index_stop_t0=21;
    for i=matrix_index_start_t0:matrix_index_stop_t0
        impact_matrix_R1_t0(i,1:6)=Temp_R1(i-matrix_index_start_t0+1,:).*(1-impact_matrix_R1_t0(27,:)/100);
        impact_matrix_R2_t0(i,1:6)=Temp_R2(i-matrix_index_start_t0+1,:).*(1-impact_matrix_R2_t0(27,:)/100);
        impact_matrix_R3_t0(i,1:4)=Temp_R3(i-matrix_index_start_t0+1,:).*(1-impact_matrix_R3_t0(27,:)/100);
        impact_matrix_R4_t0(i,1:4)=Temp_R4(i-matrix_index_start_t0+1,:).*(1-impact_matrix_R4_t0(27,:)/100);
        impact_matrix_R5_t0(i,1:8)=Temp_R5(i-matrix_index_start_t0+1,:).*(1-impact_matrix_R5_t0(27,:)/100);
    end
    
    matrix_index_start_t1=18;
    matrix_index_stop_t1=21;
    for i=matrix_index_start_t0:matrix_index_stop_t0
        impact_matrix_R1_t1(i,1:6)=Temp_R6(i-matrix_index_start_t1+1,:).*(1-impact_matrix_R1_t1(24,:)/100);
        impact_matrix_R2_t1(i,1:6)=Temp_R7(i-matrix_index_start_t1+1,:).*(1-impact_matrix_R2_t1(24,:)/100);
        impact_matrix_R3_t1(i,1:4)=Temp_R8(i-matrix_index_start_t1+1,:).*(1-impact_matrix_R3_t1(24,:)/100);
        impact_matrix_R4_t1(i,1:4)=Temp_R9(i-matrix_index_start_t1+1,:).*(1-impact_matrix_R4_t1(24,:)/100);
        impact_matrix_R5_t1(i,1:8)=Temp_R10(i-matrix_index_start_t1+1,:).*(1-impact_matrix_R5_t1(24,:)/100);
    end
    


    clear data_t0 data_t1 Temp_R1 Temp_R2 Temp_R3 Temp_R4 Temp_R5 Temp_R6 Temp_R7 Temp_R8 Temp_R9 Temp_R10 matrix_index_start matrix_index_stop temp1 temp2
    
    
    % Write t0 values to the Excel file
    xlswrite('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx',impact_matrix_R5_t0,'Base','AP4:AW35')
    xlswrite('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx',impact_matrix_R4_t0,'Base','AH4:AK35')
    xlswrite('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx',impact_matrix_R3_t0,'Base','Z4:AC35')
    xlswrite('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx',impact_matrix_R2_t0,'Base','P4:U35')
    xlswrite('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx',impact_matrix_R1_t0,'Base','F4:K35')
    
    % Write t1 values to the Excel file
    xlswrite('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx',impact_matrix_R5_t1,'For t1','AP4:AW32')
    xlswrite('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx',impact_matrix_R4_t1,'For t1','AH4:AK32')
    xlswrite('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx',impact_matrix_R3_t1,'For t1','Z4:AC32')
    xlswrite('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx',impact_matrix_R2_t1,'For t1','P4:U32')
    xlswrite('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx',impact_matrix_R1_t1,'For t1','F4:K32')
else
    % Will not calculate the impact matrices
    
end % End of imapct matrix



%clear;