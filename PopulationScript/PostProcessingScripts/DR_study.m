% This script is intended to compare results for the CVR study for the 2011
% ARRA Grant Analysis

% create 4/02/2011 by Jason Fuller


% TODO: Make Y-axis 2 digit precision

clear;
clc;

set_defaults();

case_labels = {'Base Case';'CPP w/ Tech';'CPP w/o Tech';'TOU w/ Tech';'TOU w/o Tech'};

% where to write the new data
write_dir = 'C:\Users\D3X289\Documents\GLD_Analysis_2011\Gridlabd\Taxonomy_Feeders\PostAnalysis\test_ProcessedData\';

plot_energy = 1;
plot_peak_power = 0;

% default bar width on two types of plots
barwidth_4cases = 0.4;
barwidth_28cases = 0.9;

% load the energy consumption variable and save to a temp (since they have
% the same name)
if (plot_energy == 1)
    load([write_dir,'total_energy_consumption_t0.mat']);
    data_t0 = energy_consumption;
    load([write_dir,'total_energy_consumption_t4.mat']);
    data_t4 = energy_consumption;
    load([write_dir,'total_energy_consumption_t5.mat']);
    data_t5 = energy_consumption;
    load([write_dir,'total_energy_consumption_t6.mat']);
    data_t6 = energy_consumption;
    load([write_dir,'total_energy_consumption_t7.mat']);
    data_t7 = energy_consumption;

    clear energy_consumption;

    data_labels = strrep(data_t0(:,1),'_t0','');
    data_labels = strrep(data_labels,'_','-');

    energy_data(:,1) = cell2mat(data_t0(:,2));
    energy_data(:,2) = cell2mat(data_t4(:,2));
    energy_data(:,3) = cell2mat(data_t5(:,2));
    energy_data(:,4) = cell2mat(data_t6(:,2));
    energy_data(:,5) = cell2mat(data_t7(:,2));

    for kind=1:5
        energy_reduction(:,kind) = energy_data(:,kind) - energy_data(:,1);
        percent_energy_reduction(:,kind) = 100 .* energy_reduction(:,kind) ./ energy_data(:,1);
    end

    for mind=1:1%length(data_labels)      
        
        fname = ['Total Energy Consumption ' char(data_labels(mind))];
        set_figure_size(fname);
        hold on;
        bar(energy_data(mind,:) / 1000000,'barwidth',barwidth_4cases);
        ylabel('MWh');
        title(['Energy Consumption: ' char(data_labels(mind))]);
        set_figure_graphics(case_labels,fname,0);
        hold off;

        fname = ['Total Energy Reduction ' char(data_labels(mind))];
        set_figure_size(fname);
        hold on;
        bar(energy_reduction(mind,2:5) / 1000000,'barwidth',barwidth_4cases);
        ylabel('MWh');
        title(['Energy Reduction: ' char(data_labels(mind))]);
        set_figure_graphics(case_labels(2:5),fname,0);
        hold off;

        fname = ['Percent Energy Reduction ' char(data_labels(mind))];
        set_figure_size(fname);
        hold on;
        bar(percent_energy_reduction(mind,2:5),'barwidth',barwidth_4cases);
        ylabel('%');
        title(['Energy Reduction: ' char(data_labels(mind))]);
        set_figure_graphics(case_labels(2:5),fname,'%.2f');     
        hold off;
    end
end

if (plot_peak_power == 1)
    load([write_dir,'peakiest_peak_t0.mat']);
    data_t0 = peakiest_peakday;
    load([write_dir,'peakiest_peak_t4.mat']);
    data_t4 = peakiest_peakday;
    load([write_dir,'peakiest_peak_t5.mat']);
    data_t5 = peakiest_peakday;
    load([write_dir,'peakiest_peak_t6.mat']);
    data_t6 = peakiest_peakday;
    load([write_dir,'peakiest_peak_t7.mat']);
    data_t7 = peakiest_peakday;
   
    clear peakiest_peakday;

    data_labels = strrep(data_t0(:,1),'_t0','');
    data_labels = strrep(data_labels,'_','-');
    
    % temporary
    %my_ind = [1]; %length(data_t0(:,1))
    
    peak_power_data(:,1) = cell2mat(data_t0(:,2));
    peak_power_data(:,2) = cell2mat(data_t4(:,2));
    peak_power_data(:,3) = cell2mat(data_t5(:,2));
    peak_power_data(:,4) = cell2mat(data_t6(:,2));
    peak_power_data(:,5) = cell2mat(data_t7(:,2));
    peak_va_data(:,1) = cell2mat(data_t0(:,3));
    peak_va_data(:,2) = cell2mat(data_t4(:,3));
    peak_va_data(:,3) = cell2mat(data_t5(:,3));
    peak_va_data(:,4) = cell2mat(data_t6(:,3));
    peak_va_data(:,5) = cell2mat(data_t7(:,3));
    
    delta_peak_power(:,1) = 100 * (peak_power_data(:,2) - peak_power_data(:,1)) ./ peak_power_data(:,1);
    delta_peak_va(:,1) = 100 * (peak_va_data(:,2) - peak_va_data(:,1)) ./ peak_va_data(:,1);
    
    delta_peak_power(:,2) = 100 * (peak_power_data(:,3) - peak_power_data(:,1)) ./ peak_power_data(:,1);
    delta_peak_va(:,2) = 100 * (peak_va_data(:,3) - peak_va_data(:,1)) ./ peak_va_data(:,1);
    
    delta_peak_power(:,3) = 100 * (peak_power_data(:,4) - peak_power_data(:,1)) ./ peak_power_data(:,1);
    delta_peak_va(:,3) = 100 * (peak_va_data(:,4) - peak_va_data(:,1)) ./ peak_va_data(:,1);
    
    delta_peak_power(:,4) = 100 * (peak_power_data(:,5) - peak_power_data(:,1)) ./ peak_power_data(:,1);
    delta_peak_va(:,4) = 100 * (peak_va_data(:,5) - peak_va_data(:,1)) ./ peak_va_data(:,1);
    
    scrsz = get(0,'ScreenSize');
    for jind = 1:length(data_labels)
        fname = ['Peak Demand MW ' char(data_labels)];
        figure('Name',fname,'NumberTitle','off','Position',[100 scrsz(4)/15 scrsz(3)/1.2 scrsz(4)/1.2])
        hold on;
        bar(peak_power_data(jind,:) / 1000000,'barwidth',barwidth_4cases);
        ylabel('MW');
        title(['Peak Demand by Case ' data_labels]);
        D = gca;
        set_figure(D,case_labels);
        print('-djpeg',fname);
        hold off;
        
        fname = ['Delta Peak Demand MW ' char(data_labels)];
        figure('Name',fname,'NumberTitle','off','Position',[100 scrsz(4)/15 scrsz(3)/1.2 scrsz(4)/1.2])
        hold on;
        bar(delta_peak_power(jind,2:5),'barwidth',barwidth_4cases);
        ylabel('%');
        title('Change in Peak Demand by Feeder (MW)');
        E = gca;
        set_figure(E,case_labels(2:5));
        print('-djpeg',fname);
        hold off;
    end
end

%clear;