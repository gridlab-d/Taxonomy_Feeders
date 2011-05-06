% This script is intended to compare results for the CVR study for the 2011
% ARRA Grant Analysis

% create 4/02/2011 by Jason Fuller


% TODO: Make Y-axis 2 digit precision

clear;
clc;

% Set the default text sizing
set_defaults();

% where to write the new data
write_dir = 'C:\Users\D3X289\Documents\GLD_Analysis_2011\Gridlabd\Taxonomy_Feeders\PostAnalysis\ProcessedData\'; %Jason
%write_dir = 'C:\Users\d3p313\Desktop\Post Processing Script\MAT Files\Consolodated MAT Files\'; %Kevin

plot_energy = 0;
plot_peak_power = 0;
plot_EOL = 0;
plot_pf = 1;

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

    % Energy Consumption by Feeder
    fname = 'Total Energy Consumption';
    set_figure_size(fname);
    hold on;
    bar(energy_data / 1000000,'barwidth',0.9);
    ylabel('Energy Consumption (MWh)');
    %title('Energy Consumption by Feeder');
    set_figure_graphics(data_labels,fname,0);
    legend('Base Case','w/CVR')
    hold off;

    % Change in Energy Consumption (MWh)
    fname = 'Total Energy Reduction';
    set_figure_size(fname);
    hold on;
    bar(energy_reduction / 1000000);
    ylabel('Change in Energy Consumption (MWh)');
    %title('Energy Reduction by Feeder');
    set_figure_graphics(data_labels,fname,0);
    hold off;
    
    % Change in Energy Consumption (%)
    fname = 'Percent Energy Reduction';
    set_figure_size(fname);
    hold on;
    bar(percent_energy_reduction);
    ylabel('Change in Energy Consumption (%)');
    %title('Energy Reduction by Feeder');
    set_figure_graphics(data_labels,fname,'%.2f');
    hold off;
end

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
   
    % Peak Demand (MW)
    fname = 'Peak Demand MW';
    set_figure_size(fname);
    hold on;
    bar(peak_power_data / 1000000,'barwidth',0.9);
    ylabel('Peak Load (MW)');
    %title('Peak Demand by Feeder');
    set_figure_graphics(data_labels,fname,0);
    legend('Base Case','w/CVR')
    hold off;
    
%     %Peak Demand (MVA)
%     fname = 'Peak Demand MVA';
%     figure('Name',fname,'NumberTitle','off','Position',[100 scrsz(4)/15 scrsz(3)/1.2 scrsz(4)/1.2])
%     hold on;
%     bar(peak_va_data / 1000000,'barwidth',0.9);
%     ylabel('Peak Demand (MVA)');
%     %title('Peak Demand by Feeder');
%     F = gca;
%     set(F,'XGrid','off','YGrid','on','ZGrid','off');
%     ylab = get(F,'Ylabel');
%     ylab_pos_orig = get(ylab,'position');
%     ylab_pos = [ylab_pos_orig(1)-2 ylab_pos_orig(2) ylab_pos_orig(3)];
%     set(get(F,'YLabel'),'position',ylab_pos);
%     set(F,'XGrid','off','YGrid','on','ZGrid','off');
%     axes('Position',[.005 .005 .99 .99],'xtick',[],'ytick',[],'box','on','handlevisibility','off','Color','none');
%     xticklabel_rotate(1:length(data_labels),90,data_labels);
%     print('-djpeg',fname);
%     hold off;   
    
    % Change in Peak Demand (MW)
    fname = 'Delta Peak Demand MW';
    set_figure_size(fname);
    hold on;
    bar(peak_power_data(:,2)-peak_power_data(:,1));
    ylabel('Change in Peak Load (MW)');
    %title('Change in Peak Demand by Feeder (MW)');
    set_figure_graphics(data_labels,fname,0);
    hold off;  


    % Change in Peak Demand (%)
    fname = 'Delta Peak Demand %';
    set_figure_size(fname);
    hold on;
    bar(delta_peak_power);
    ylabel('Change in Peak Load (%)');
    %title('Change in Peak Demand by Feeder (MW)');
    set_figure_graphics(data_labels,fname,0);
    hold off; 
    

%     % Change in Peak Demand (MVA)
%     fname = 'Delta Peak Demand MVA';
%     figure('Name',fname,'NumberTitle','off','Position',[100 scrsz(4)/15 scrsz(3)/1.2 scrsz(4)/1.2])
%     hold on;
%     bar(delta_peak_va);
%     ylabel('%');
%     title('Change in Peak Demand by Feeder (MVA)');
%     G = gca;
%     set(G,'XGrid','off','YGrid','on','ZGrid','off');
%     ylab = get(G,'Ylabel');
%     ylab_pos_orig = get(ylab,'position');
%     ylab_pos = [ylab_pos_orig(1)-2 ylab_pos_orig(2) ylab_pos_orig(3)];
%     set(get(G,'YLabel'),'position',ylab_pos);
%     set(G,'XGrid','off','YGrid','on','ZGrid','off');
%     axes('Position',[.005 .005 .99 .99],'xtick',[],'ytick',[],'box','on','handlevisibility','off','Color','none');
%    
%     xticklabel_rotate(1:length(data_labels),90,data_labels);
%     print('-djpeg',fname);
%     hold off;

end

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

    scrsz = get(0,'ScreenSize');
    
    % Minimum EOL Voltage Without CVR
    fname = 'Minimum Voltage Without CVR';
    set_figure_size(fname);
    hold on;
    bar(voltage_data0(:,1:3),'barwidth',0.9);
    ylabel('Voltage (V)');
    %title('Minimum EOL Voltage Without CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels,fname,0);
    legend('phase a','phase b','phase c')
    hold off;

    % Average EOL Voltage Without CVR
    fname = 'Average Voltage Without CVR';
    set_figure_size(fname);
    hold on;
    bar(voltage_data0(:,4:6),'barwidth',0.9);
    ylabel('Voltage (V)');
    %title('Average EOL Voltage Without CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels,fname,0);
    legend('phase a','phase b','phase c')
    hold off;
    
    % Minimum EOL Voltage With CVR
    fname = 'Minimum Voltage With CVR';
    set_figure_size(fname);
    hold on;
    bar(voltage_data1(:,1:3),'barwidth',0.9);
    ylabel('Voltage (V)');
   %title('Minimum EOL Voltage With CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels,fname,0);
    legend('phase a','phase b','phase c')
    hold off;
    
    % Average EOL Voltage With CVR
    fname = 'Average Voltage With CVR';
    set_figure_size(fname);
    hold on;
    bar(voltage_data1(:,4:6),'barwidth',0.9);
    ylabel('Voltage (V)');
    %title('Average EOL Voltage With CVR');
    ylim([110 130]);
    set_figure_graphics(data_labels,fname,0);
    legend('phase a','phase b','phase c')
    hold off;
end

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
    
    % Minimum power factor (Base Case)
    
    fname = 'Minimum Power Factor Base Case';
    set_figure_size(fname);
    hold on;
    
    
    pf(:,1)=cell2mat(data_t0(1:28,2:2));
    pf(:,2)=cell2mat(data_t0(1:28,5:5));
    pf(:,3)=cell2mat(data_t0(1:28,8:8));
    pf(:,4)=cell2mat(data_t0(1:28,11:11));
    
    bar(pf,'barwidth',0.9,'barwidth',0.9);
    
    %bar(voltage_data1(:,4:6),'barwidth',0.9);
    
    
    ylabel('Power Factor');
    
    ylim([.5 1.0]);
    set_figure_graphics(data_labels,fname,0);
    legend('phase a','phase b','phase c','total')
   
    hold off;

    % Minimum power factor (CVR)
    
    % Average power factor (Base Case)
    
    % Average power factor (CVR)
    
    % Maximum power factor (Base Case)
    
    % Maximum power factor (CVR)
    

end

%%
% clear;