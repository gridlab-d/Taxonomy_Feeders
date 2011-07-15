% This script is intended to compare results for the CVR study for the 2011
% ARRA Grant Analysis

% create 4/02/2011 by Jason Fuller

clear;
clc;
format short g

% set default text sizing
set_defaults();

% set my specific case labels (feeder labels get populated later from a file)
case_labels = {'Base';'CPP wTech';'CPP noTech';'TOU wTech';'TOU noTech'};
loss_labels = {'OHL';'UGL';'TFR';'TPL'};
dlc_labels = {'Base';'DLC'};
monthly_labels = {'Jan';'Feb';'Mar';'April';'May';'June';'July';'Aug';'Sept';'Oct';'Nov';'Dec'};

% where to write the new data (write gets data, output puts plots)
write_dir = 'C:\Users\d3x289\Documents\GLD2011\Code\Taxonomy\PopulationScript\PostProcessingScripts\ProcessedData\';
output_dir = 'C:\Users\d3x289\Documents\GLD2011\Code\Taxonomy\PopulationScript\PostProcessingScripts\ProcessedPlots\testplots\';

% TOU/CPP versus DLC
plot_TOU = 0;
plot_DLC = 1;

% Turn on individual feeder plots and/or all feeders on a single plot
plot_individual_feeders = 1;
plot_feeder_summaries = 1;
generate_impact_metrics = 0;

% flags for type of plots
plot_energy = 1;
plot_peak_power = 1;
plot_bills = 1;
plot_losses = 1;
plot_emissions = 1;
plot_peak_timeseries = 1;

% secondary flags for sub-plots
plot_monthly_energy = 1; % plot_energy
plot_monthly_peak = 1; % plot_peak_power
plot_monthly_losses = 1; % plot_losses
plot_monthly_emissions = 1; % % plot_emissions

plot_testing = 1; % if testing=1, then only prints the first one of each
close_plots = 1; % close the figures...definitely use when making a bunch

% default bar width on two types of plots
barwidth_4cases = 0.4;
barwidth_12cases = 0.8;
barwidth_28cases = 0.9;

%% TOU/CPP
if (plot_TOU == 1)
    %% PLOT ENERGY
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

        if (plot_monthly_energy == 1)        
            load([write_dir,'monthly_energy_consumption_t0.mat']);
            data_m_t0 = monthly_energy_consumption;
            load([write_dir,'monthly_energy_consumption_t4.mat']);
            data_m_t4 = monthly_energy_consumption;
            load([write_dir,'monthly_energy_consumption_t5.mat']);
            data_m_t5 = monthly_energy_consumption;
            load([write_dir,'monthly_energy_consumption_t6.mat']);
            data_m_t6 = monthly_energy_consumption;
            load([write_dir,'monthly_energy_consumption_t7.mat']);
            data_m_t7 = monthly_energy_consumption;

            clear monthly_energy_consumption;

            for c_ind = 1:length(data_labels)
                % energy_data_monthly(tech,month,feeder)
                    a = data_m_t0(c_ind,2);
                energy_data_monthly(1,:,c_ind) = cell2mat(a)';
                    a = data_m_t4(c_ind,2);
                energy_data_monthly(2,:,c_ind) = cell2mat(a)';
                    a = data_m_t5(c_ind,2);
                energy_data_monthly(3,:,c_ind) = cell2mat(a)';
                    a = data_m_t6(c_ind,2);
                energy_data_monthly(4,:,c_ind) = cell2mat(a)';
                    a = data_m_t7(c_ind,2);
                energy_data_monthly(5,:,c_ind) = cell2mat(a)';
            end
        end

        for kind=1:5
            energy_reduction(:,kind) = energy_data(:,kind) - energy_data(:,1);
            percent_energy_reduction(:,kind) = 100 .* energy_reduction(:,kind) ./ energy_data(:,1);
        end

        % Feeder level summary plots
        if (plot_feeder_summaries == 1)
            % loop through each case
            if (plot_testing == 1)
                L = 1;
            else
                L = 4;
            end
            for kind = 1:L 
                fname = ['Total Energy Consumption (MWh) ' char(case_labels(kind+1))];
                set_figure_size(fname);
                hold on;
                bar(energy_data(:,kind+1) / 1000000,'barwidth',barwidth_28cases);
                ylabel('Energy Consumption (MWh)');
                set_figure_graphics(data_labels,[output_dir fname],1,'none',0.06,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end

                fname = ['Total Energy Reduction (MWh) ' char(case_labels(kind+1))];
                set_figure_size(fname);
                hold on;
                bar( energy_reduction(:,kind+1) / 1000000,'barwidth',barwidth_28cases);
                ylabel('Change in Energy Consumption (MWh)');
                set_figure_graphics(data_labels,[output_dir fname],3,'none',0,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end

                fname = ['Percent Energy Reduction (%) ' char(case_labels(kind+1))];
                set_figure_size(fname);
                hold on;
                bar(percent_energy_reduction(:,kind+1),'barwidth',barwidth_28cases);
                ylabel('Change in Energy Consumption (%)');
                set_figure_graphics(data_labels,[output_dir fname],2,'none',.04,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end
            end
        end

        fname = ['Total Energy Consumption (MWh)'];
        set_figure_size(fname);
        hold on;
        bar(energy_data / 1000000,'barwidth',barwidth_28cases);
        ylabel('Energy Consumption (MWh)');
        set_figure_graphics(data_labels,[output_dir fname],1,case_labels,.06,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        fname = ['Total Energy Reduction (MWh)'];
        set_figure_size(fname);
        hold on;
        bar( energy_reduction(:,2:5) / 1000000,'barwidth',barwidth_28cases);
        ylabel('Change in Energy Consumption (MWh)');
        set_figure_graphics(data_labels,[output_dir fname],3,case_labels(2:5),-.01,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        fname = ['Percent Energy Reduction (%)'];
        set_figure_size(fname);
        hold on;
        bar(percent_energy_reduction(:,2:5),'barwidth',barwidth_28cases);
        ylabel('Change in Energy Consumption (%)');
        set_figure_graphics(data_labels,[output_dir fname],2,case_labels(2:5),.04,'northoutside',0,0,'horizontal');      
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        if (plot_individual_feeders == 1)
            if plot_testing == 1
                M = 6;
                L = 6;
            else
                M = 1;
                L = length(data_labels);
            end

            for mind=M:L       
        %         fname = ['Total Energy Consumption ' char(data_labels(mind))];
        %         set_figure_size(fname);
        %         hold on;
        %         bar(energy_data(mind,:) / 1000000,'barwidth',barwidth_4cases);
        %         ylabel('MWh');
        %         set_figure_graphics(case_labels,fname,1,'none',2,'northoutside',0,0,'horizontal');
        %         hold off;
        %         if plot_testing ~= 1
        %             close(fname);
        %         end
        % 
        %         fname = ['Total Energy Reduction ' char(data_labels(mind))];
        %         set_figure_size(fname);
        %         hold on;
        %         bar(energy_reduction(mind,2:5) / 1000000,'barwidth',barwidth_4cases);
        %         ylabel('MWh');
        %         set_figure_graphics(case_labels(2:5),fname,1,'none',2,'northoutside',0,0,'horizontal');
        %         hold off;
        %         if plot_testing ~= 1
        %             close(fname);
        %         end
        % 
        %         fname = ['Percent Energy Reduction ' char(data_labels(mind))];
        %         set_figure_size(fname);
        %         hold on;
        %         bar(percent_energy_reduction(mind,2:5),'barwidth',barwidth_4cases);
        %         ylabel('%');
        %         set_figure_graphics(case_labels(2:5),fname,2,'none',2,'northoutside',0,0,'horizontal');     
        %         hold off;
        %         if plot_testing ~= 1
        %             close(fname);
        %         end

                if (plot_monthly_energy == 1)
                    % peak_power_monthly(tech,month,feeder)

                    % Plots energy for each of the 5 cases (base + 4DR) by
                    % month
                    fname = ['Energy (MWh) Monthly ' char(data_labels(mind))];
                    set_figure_size(fname);
                    hold on;
                    bar(energy_data_monthly(:,:,mind)' / 1000000,'barwidth',barwidth_12cases);
                    ylabel('Energy (MWh)');
                    set_figure_graphics(monthly_labels,[output_dir fname],1,case_labels,0,'northoutside',0,0,'horizontal');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end
                end
            end
        end
    end

    %% PLOT PEAK POWER
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

        if (plot_monthly_peak == 1)
            load([write_dir,'peakiest_peak_monthly_t0.mat']);
            data_m_t0 = peakiest_peakday_monthly;
            load([write_dir,'peakiest_peak_monthly_t4.mat']);
            data_m_t4 = peakiest_peakday_monthly;
            load([write_dir,'peakiest_peak_monthly_t5.mat']);
            data_m_t5 = peakiest_peakday_monthly;
            load([write_dir,'peakiest_peak_monthly_t6.mat']);
            data_m_t6 = peakiest_peakday_monthly;
            load([write_dir,'peakiest_peak_monthly_t7.mat']);
            data_m_t7 = peakiest_peakday_monthly;

            for c_ind = 1:length(data_labels)
                % peak_power_monthly(tech,month,feeder)
                    a = data_m_t0(c_ind,2);
                peak_power_monthly_data(1,:,c_ind) = cell2mat(a{1,1})';
                    a = data_m_t4(c_ind,2);
                peak_power_monthly_data(2,:,c_ind) = cell2mat(a{1,1})';
                    a = data_m_t5(c_ind,2);
                peak_power_monthly_data(3,:,c_ind) = cell2mat(a{1,1})';
                    a = data_m_t6(c_ind,2);
                peak_power_monthly_data(4,:,c_ind) = cell2mat(a{1,1})';
                    a = data_m_t7(c_ind,2);
                peak_power_monthly_data(5,:,c_ind) = cell2mat(a{1,1})';

                delta_peak_power_monthly(1,:,c_ind) = 100 * (peak_power_monthly_data(2,:,c_ind) - peak_power_monthly_data(1,:,c_ind)) ./ peak_power_monthly_data(1,:,c_ind);
                delta_peak_power_monthly(2,:,c_ind) = 100 * (peak_power_monthly_data(3,:,c_ind) - peak_power_monthly_data(1,:,c_ind)) ./ peak_power_monthly_data(1,:,c_ind);
                delta_peak_power_monthly(3,:,c_ind) = 100 * (peak_power_monthly_data(4,:,c_ind) - peak_power_monthly_data(1,:,c_ind)) ./ peak_power_monthly_data(1,:,c_ind);
                delta_peak_power_monthly(4,:,c_ind) = 100 * (peak_power_monthly_data(5,:,c_ind) - peak_power_monthly_data(1,:,c_ind)) ./ peak_power_monthly_data(1,:,c_ind);
            end

        end

        delta_peak_power(:,1) = 100 * (peak_power_data(:,2) - peak_power_data(:,1)) ./ peak_power_data(:,1);
        delta_peak_va(:,1) = 100 * (peak_va_data(:,2) - peak_va_data(:,1)) ./ peak_va_data(:,1);

        delta_peak_power(:,2) = 100 * (peak_power_data(:,3) - peak_power_data(:,1)) ./ peak_power_data(:,1);
        delta_peak_va(:,2) = 100 * (peak_va_data(:,3) - peak_va_data(:,1)) ./ peak_va_data(:,1);

        delta_peak_power(:,3) = 100 * (peak_power_data(:,4) - peak_power_data(:,1)) ./ peak_power_data(:,1);
        delta_peak_va(:,3) = 100 * (peak_va_data(:,4) - peak_va_data(:,1)) ./ peak_va_data(:,1);

        delta_peak_power(:,4) = 100 * (peak_power_data(:,5) - peak_power_data(:,1)) ./ peak_power_data(:,1);
        delta_peak_va(:,4) = 100 * (peak_va_data(:,5) - peak_va_data(:,1)) ./ peak_va_data(:,1);

        % Individual Feeder Graphs
        if (plot_individual_feeders == 1)
            % loop through each feeder
            if (plot_testing == 1)
                M = 6;
                L = 6;
            else
                M = 1;
                L = length(data_labels);
            end

            for jind = M:L
    %             % Plots peak demand for each of the 5 cases (base + 4DR)
    %             fname = ['Peak Demand (MW) ' char(data_labels(jind))];
    %             set_figure_size(fname);
    %             hold on;
    %             bar(peak_power_data(jind,:) / 1000000,'barwidth',barwidth_4cases);
    %             ylabel('Peak Demand (MW)');
    %             set_figure_graphics(case_labels,fname,1,'none',0,'northoutside',0,0,'horizontal');
    %             hold off;
    %             if plot_testing ~= 1
    %                 close(fname);
    %             end
    % 
    %             % Plots the delta of peak demand of the 4 cases (DR-base)
    %             fname = ['Delta Peak Demand (%) ' char(data_labels(jind))];
    %             set_figure_size(fname);
    %             hold on;
    %             bar(delta_peak_power(jind,:),'barwidth',barwidth_4cases);
    %             ylabel('Change in Peak Demand (%)');
    %             set_figure_graphics(case_labels(2:5),fname,1,'none',0,'northoutside',0,0,'horizontal');
    %             hold off;
    %             if plot_testing ~= 1
    %                 close(fname);
    %             end

                if (plot_monthly_peak == 1)
                    % peak_power_monthly(tech,month,feeder)

                    % Plots peak demand for each of the 5 cases (base + 4DR)
                    fname = ['Peak Demand (MW) Monthly ' char(data_labels(jind))];
                    set_figure_size(fname);
                    hold on;
                    bar(peak_power_monthly_data(:,:,jind)' / 1000000,'barwidth',barwidth_12cases);
                    ylabel('Peak Demand (MW)');
                    set_figure_graphics(monthly_labels,[output_dir fname],1,case_labels,0,'northoutside',0,0,'horizontal');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end

                    % Plots the delta of peak demand of the 4 cases (DR-base)
                    fname = ['Delta Peak Demand (%) Monthly ' char(data_labels(jind))];
                    set_figure_size(fname);
                    hold on;
                    bar(delta_peak_power_monthly(:,:,jind)','barwidth',barwidth_12cases);
                    ylabel('Change in Peak Demand (%)');
                    set_figure_graphics(monthly_labels,[output_dir fname],1,case_labels(2:5),0,'northoutside',0,0,'horizontal');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end
                end
            end
        end

        % Feeder level summary plots
        if (plot_feeder_summaries == 1)
            % loop through each case
            if (plot_testing == 1)
                L = 1;
            else
                L = 4;
            end
            for kind = 1:L 
                fname = ['Peak Demand (MW) ' char(case_labels(kind))];
                set_figure_size(fname);
                hold on;
                bar(peak_power_data(:,kind+1) / 1000000,'barwidth',barwidth_28cases);
                ylabel('Peak Demand (MW)');
                set_figure_graphics(data_labels,[output_dir fname],1,'none',0,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end

                fname = ['Delta Peak Demand (kW) ' char(case_labels(kind))];
                set_figure_size(fname);
                hold on;
                bar( (peak_power_data(:,kind+1)-peak_power_data(:,1)) / 1000,'barwidth',barwidth_28cases);
                ylabel('Change in Peak Demand (kW)');
                set_figure_graphics(data_labels,[output_dir fname],3,'none',0,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end

                fname = ['Delta Peak Demand (%) ' char(case_labels(kind))];
                set_figure_size(fname);
                hold on;
                bar(delta_peak_power(:,kind),'barwidth',barwidth_28cases);
                ylabel('Change in Peak Demand (%)');
                set_figure_graphics(data_labels,[output_dir fname],1,'none',0,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end
            end
        end


        fname = ['Peak Demand (MW)'];
        set_figure_size(fname);
        hold on;
        bar(peak_power_data / 1000000,'barwidth',barwidth_28cases);
        ylabel('Peak Demand (MW)');
        set_figure_graphics(data_labels,[output_dir fname],1,case_labels,0,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        fname = ['Delta Peak Demand (kW)'];
        set_figure_size(fname);
        hold on;    
        dpower(:,1) = (peak_power_data(:,2)-peak_power_data(:,1));
        dpower(:,2) = (peak_power_data(:,3)-peak_power_data(:,1));
        dpower(:,3) = (peak_power_data(:,4)-peak_power_data(:,1));
        dpower(:,4) = (peak_power_data(:,5)-peak_power_data(:,1));   
        bar( dpower / 1000,'barwidth',barwidth_28cases);
        ylabel('Change in Peak Demand (kW)');
        set_figure_graphics(data_labels,[output_dir fname],3,case_labels(2:5),0,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        fname = ['Delta Peak Demand (%)'];
        set_figure_size(fname);
        hold on;
        bar(delta_peak_power,'barwidth',barwidth_28cases);
        ylabel('Change in Peak Demand (%)');
        set_figure_graphics(data_labels,[output_dir fname],1,case_labels(2:5),0,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end
    end  % end Peak Power

    %% PLOT PEAK TIME SERIES
    if (plot_peak_timeseries == 1)
        load([write_dir,'peak_15days_t0.mat']);
        data_t0 = peak_15days;
        load([write_dir,'peak_15days_t4.mat']);
        data_t4 = peak_15days;
        load([write_dir,'peak_15days_t5.mat']);
        data_t5 = peak_15days;
        load([write_dir,'peak_15days_t6.mat']);
        data_t6 = peak_15days;
        load([write_dir,'peak_15days_t7.mat']);
        data_t7 = peak_15days;

        clear peak_15days;

        field_names_t0 = fieldnames(data_t0);
        field_names_t4 = fieldnames(data_t4);
        field_names_t5 = fieldnames(data_t5);
        field_names_t6 = fieldnames(data_t6);
        field_names_t7 = fieldnames(data_t7);

        if (plot_testing == 1)
            L = 1;
        else
            L = length(field_names_t0);
        end

        year = 2009 * ones(1,4*24);
        month = 6 * ones(1,4*24);
        day = 1 * ones(1,4*24);
        for jjj=1:24
            hour( (4*(jjj-1)+1):4*jjj ) = jjj-1;
        end

        minutes(1,1:4:96) = 0;         
        minutes(1,2:4:96) = 15;
        minutes(1,3:4:96) = 30;
        minutes(1,4:4:96) = 45;

        xdate = datenum(year,month,day,hour,minutes,minutes);

        for f_ind=1:2:L
            eval(['ts_data_t0 =  data_t0.' char(field_names_t0(f_ind)) ';']);
                eval(['ts_timestep =  data_t0.' char(field_names_t0(f_ind+1)) ';']);
            eval(['ts_data_t4 =  data_t4.' char(field_names_t4(f_ind)) ';']);
                eval(['ts_timestep_t4 =  data_t4.' char(field_names_t4(f_ind+1)) ';']);
            eval(['ts_data_t5 =  data_t5.' char(field_names_t5(f_ind)) ';']);
                eval(['ts_timestep_t5 =  data_t5.' char(field_names_t5(f_ind+1)) ';']);
            eval(['ts_data_t6 =  data_t6.' char(field_names_t6(f_ind)) ';']);
                eval(['ts_timestep_t6 =  data_t6.' char(field_names_t6(f_ind+1)) ';']);
            eval(['ts_data_t7 =  data_t7.' char(field_names_t7(f_ind)) ';']);
                eval(['ts_timestep_t7 =  data_t7.' char(field_names_t7(f_ind+1)) ';']);

            if (plot_testing == 1)
                M = 1;
            else
                M = 15;
            end

            for dd_ind = 1:15
                xlab4{:,dd_ind} = strtok(char(ts_timestep_t4{1,dd_ind}));
                xlab5{:,dd_ind} = strtok(char(ts_timestep_t5{1,dd_ind}));
                xlab6{:,dd_ind} = strtok(char(ts_timestep_t6{1,dd_ind}));
                xlab7{:,dd_ind} = strtok(char(ts_timestep_t7{1,dd_ind}));
            end

            for d_ind=1:M
                xlab = strtok(char(ts_timestep{1,d_ind}));

                % tech 4 plot
                for d_ind4 = 1:15
                    if (strcmp(xlab,xlab4{1,d_ind4}) ~= 0)
                        break;
                    end
                end

                xlab44 = strtok(char(ts_timestep_t4{1,d_ind4}));            
                if (strcmp(xlab,xlab44) == 0)
                    disp(['Dates did not match between t0 & t4 on day ' num2str(d_ind) ' on feeder ' char(field_names_t4(f_ind))]);
                    should_I_plot4 = 0;
                else
                    should_I_plot4 = 1;
                end

                if (should_I_plot4 == 1)
                    fname = ['Base versus ',char(field_names_t4(f_ind)),' day',num2str(d_ind)];
                    set_figure_size(fname);
                    hold on;
                    plot(xdate,ts_data_t0(:,d_ind) / 1000000,xdate,ts_data_t4(:,d_ind4) / 1000000,'r','LineWidth',2);
                    ylabel('Power (MW)');
                    yy = ylim;
                    ylim([0 yy(2)]);
                    xx = xlim;           
                    xlabel(xlab);
                    datetick('x','HHPM');
                    xlim([xx(1) xx(2)]);
                    set_figure_graphics('none',[output_dir fname],1,case_labels(1:2),0,'northwest');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end
                end

                % tech 5 plot
                for d_ind5 = 1:15
                    if (strcmp(xlab,xlab5{1,d_ind5}) ~= 0)
                        break;
                    end
                end

                xlab55 = strtok(char(ts_timestep_t5{1,d_ind5}));            
                if (strcmp(xlab,xlab55) == 0)
                    disp(['Dates did not match between t0 & t5 on day ' num2str(d_ind) ' on feeder ' char(field_names_t5(f_ind))]);
                    should_I_plot5 = 0;
                else
                    should_I_plot5 = 1;
                end

                if (should_I_plot5 == 1)
                    fname = ['Base versus ',char(field_names_t5(f_ind)),' day',num2str(d_ind)];
                    set_figure_size(fname);
                    hold on;
                    plot(xdate,ts_data_t0(:,d_ind) / 1000000,xdate,ts_data_t5(:,d_ind5) / 1000000,'r','LineWidth',2);
                    ylabel('Power (MW)');
                    %yy = ylim;
                    ylim([0 yy(2)]);
                    xlabel(xlab);
                    datetick('x','HHPM');
                    xlim([xx(1) xx(2)]);
                    set_figure_graphics('none',[output_dir fname],1,case_labels(1:2:3),0,'northwest');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end
                end

                % tech 6 plot
                for d_ind6 = 1:15
                    if (strcmp(xlab,xlab6{1,d_ind6}) ~= 0)
                        break;
                    end
                end

                xlab66 = strtok(char(ts_timestep_t6{1,d_ind6}));            
                if (strcmp(xlab,xlab66) == 0)
                    disp(['Dates did not match between t0 & t6 on day ' num2str(d_ind) ' on feeder ' char(field_names_t6(f_ind))]);
                    should_I_plot6 = 0;
                else
                    should_I_plot6 = 1;
                end

                if (should_I_plot6 == 1)
                    fname = ['Base versus ',char(field_names_t6(f_ind)),' day',num2str(d_ind)];
                    set_figure_size(fname);
                    hold on;
                    plot(xdate,ts_data_t0(:,d_ind) / 1000000,xdate,ts_data_t6(:,d_ind6) / 1000000,'r','LineWidth',2);
                    ylabel('Power (MW)');
                    %yy = ylim;
                    ylim([0 yy(2)]);
                    xlabel(xlab);
                    datetick('x','HHPM');
                    xlim([xx(1) xx(2)]);
                    set_figure_graphics('none',[output_dir fname],1,case_labels(1:3:4),0,'northwest');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end
                end

                % tech 7 plot
                for d_ind7 = 1:15
                    if (strcmp(xlab,xlab7{1,d_ind7}) ~= 0)
                        break;
                    end
                end

                xlab77 = strtok(char(ts_timestep_t7{1,d_ind7}));            
                if (strcmp(xlab,xlab77) == 0)
                    disp(['Dates did not match between t0 & t7 on day ' num2str(d_ind) ' on feeder ' char(field_names_t7(f_ind))]);
                    should_I_plot7 = 0;
                else
                    should_I_plot7 = 1;
                end

                if (should_I_plot7 == 1)
                    fname = ['Base versus ',char(field_names_t7(f_ind)),' day',num2str(d_ind)];
                    set_figure_size(fname);
                    hold on;
                    plot(xdate,ts_data_t0(:,d_ind) / 1000000,xdate,ts_data_t7(:,d_ind7) / 1000000,'r','LineWidth',2);
                    ylabel('Power (MW)');
                    %yy = ylim;
                    ylim([0 yy(2)]);
                    xlabel(xlab);
                    datetick('x','HHPM');
                    xlim([xx(1) xx(2)]);
                    set_figure_graphics('none',[output_dir fname],1,case_labels(1:4:5),0,'northwest');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end
                end
            end    
        end    
    end % end plot peak timeseries

    %% PLOT BILLS
    if (plot_bills == 1)
        load([write_dir,'bill_statistics_t0.mat']);
        data_t0 = bill_stats;
        load([write_dir,'bill_statistics_t4.mat']);
        data_t4 = bill_stats;
        load([write_dir,'bill_statistics_t5.mat']);
        data_t5 = bill_stats;
        load([write_dir,'bill_statistics_t6.mat']);
        data_t6 = bill_stats;
        load([write_dir,'bill_statistics_t7.mat']);
        data_t7 = bill_stats;

        % Individual Feeder Graphs
        if (plot_individual_feeders == 1)
            % loop through each feeder
            if (plot_testing == 1)
                M = 6;
                L = 6;
            else
                M = 1;
                L = length(data_labels);
            end

            for jind = M:L
                if (0 && plot_monthly_peak == 1)
                    % peak_power_monthly(tech,month,feeder)

                    % Plots peak demand for each of the 5 cases (base + 4DR)
                    fname = ['Peak Demand (MW) Monthly ' char(data_labels(jind))];
                    set_figure_size(fname);
                    hold on;
                    bar(peak_power_monthly_data(:,:,jind)' / 1000000,'barwidth',barwidth_12cases);
                    ylabel('Peak Demand (MW)');
                    set_figure_graphics(monthly_labels,[output_dir fname],1,case_labels,0,'northoutside',0,0,'horizontal');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end

                    % Plots the delta of peak demand of the 4 cases (DR-base)
                    fname = ['Delta Peak Demand (%) Monthly ' char(data_labels(jind))];
                    set_figure_size(fname);
                    hold on;
                    bar(delta_peak_power_monthly(:,:,jind)','barwidth',barwidth_12cases);
                    ylabel('Change in Peak Demand (%)');
                    set_figure_graphics(monthly_labels,[output_dir fname],1,case_labels(2:5),0,'northoutside',0,0,'horizontal');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end
                end
            end
        end

        % Feeder level summary plots
        if (plot_feeder_summaries == 1)
            % loop through each case
            if (plot_testing == 1)
                L = 1;
            else
                L = 4;
            end
            for kind = 1:L 
                fname = ['Peak Demand (MW) ' char(case_labels(kind))];
                set_figure_size(fname);
                hold on;
                bar(peak_power_data(:,kind+1) / 1000000,'barwidth',barwidth_28cases);
                ylabel('Peak Demand (MW)');
                set_figure_graphics(data_labels,[output_dir fname],1,'none',0,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end

                fname = ['Delta Peak Demand (MW) ' char(case_labels(kind))];
                set_figure_size(fname);
                hold on;
                bar( (peak_power_data(:,kind+1)-peak_power_data(:,1)) / 1000000,'barwidth',barwidth_28cases);
                ylabel('Change in Peak Demand (MW)');
                set_figure_graphics(data_labels,[output_dir fname],3,'none',0,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end

                fname = ['Delta Peak Demand (%) ' char(case_labels(kind))];
                set_figure_size(fname);
                hold on;
                bar(delta_peak_power(:,kind),'barwidth',barwidth_28cases);
                ylabel('Change in Peak Demand (%)');
                set_figure_graphics(data_labels,[output_dir fname],1,'none',0,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end
            end
        end


        fname = ['Peak Demand (MW)'];
        set_figure_size(fname);
        hold on;
        bar(peak_power_data / 1000000,'barwidth',barwidth_28cases);
        ylabel('Peak Demand (MW)');
        set_figure_graphics(data_labels,[output_dir fname],1,case_labels,0,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        fname = ['Delta Peak Demand (MW)'];
        set_figure_size(fname);
        hold on;    
        dpower(:,1) = (peak_power_data(:,2)-peak_power_data(:,1));
        dpower(:,2) = (peak_power_data(:,3)-peak_power_data(:,1));
        dpower(:,3) = (peak_power_data(:,4)-peak_power_data(:,1));
        dpower(:,4) = (peak_power_data(:,5)-peak_power_data(:,1));   
        bar( dpower / 1000000,'barwidth',barwidth_28cases);
        ylabel('Change in Peak Demand (MW)');
        set_figure_graphics(data_labels,[output_dir fname],3,case_labels(2:5),0,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        fname = ['Delta Peak Demand (%)'];
        set_figure_size(fname);
        hold on;
        bar(delta_peak_power,'barwidth',barwidth_28cases);
        ylabel('Change in Peak Demand (%)');
        set_figure_graphics(data_labels,[output_dir fname],1,case_labels(2:5),0,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end
    end % end Plot Bills

    %% PLOT LOSSES
    if (plot_losses == 1)
        load([write_dir,'annual_losses_t0.mat']);
        data_t0 = annual_losses;
        load([write_dir,'annual_losses_t4.mat']);
        data_t4 = annual_losses;
        load([write_dir,'annual_losses_t5.mat']);
        data_t5 = annual_losses;
        load([write_dir,'annual_losses_t6.mat']);
        data_t6 = annual_losses;
        load([write_dir,'annual_losses_t7.mat']);
        data_t7 = annual_losses;

        [no_feeders cells] = size(data_t0);
        clear anual_losses;

        data_labels = strrep(data_t0(:,1),'_t0','');
        data_labels = strrep(data_labels,'_','-');

        for i=1:no_feeders
            loss_data(i,1) = data_t0{i,3}(6,1);
            loss_data(i,2) = data_t4{i,3}(6,1);
            loss_data(i,3) = data_t5{i,3}(6,1);
            loss_data(i,4) = data_t6{i,3}(6,1);
            loss_data(i,5) = data_t7{i,3}(6,1);
        end

        loss_reduction(:,1) = loss_data(:,2)-loss_data(:,1);
        loss_reduction(:,2) = loss_data(:,3)-loss_data(:,1);
        loss_reduction(:,3) = loss_data(:,4)-loss_data(:,1);
        loss_reduction(:,4) = loss_data(:,5)-loss_data(:,1);
        percent_loss_reduction(:,1) = 100.*(loss_reduction(:,1)/loss_data(i,1));
        percent_loss_reduction(:,2) = 100.*(loss_reduction(:,2)/loss_data(i,1));
        percent_loss_reduction(:,3) = 100.*(loss_reduction(:,3)/loss_data(i,1));
        percent_loss_reduction(:,4) = 100.*(loss_reduction(:,4)/loss_data(i,1));

        % Annual Losses
        fname = 'Total annual losses by feeder (MWh)';
        set_figure_size(fname);
        hold on;
        bar(loss_data / 1000000,'barwidth',barwidth_28cases);
        ylabel('Total Losses (MWh)');
        set_figure_graphics(data_labels,[output_dir fname],2,case_labels,0.01,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        % Change in Annual Losses (MWh)
        fname = 'Change in total annual losses by feeder (MWh)';
        set_figure_size(fname);
        hold on;
        bar(loss_reduction / 1000000,'barwidth',barwidth_28cases);
        ylabel('Change in Losses (MWh)');
        set_figure_graphics(data_labels,[output_dir fname],2,case_labels(2:5),0.03,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        % Change in Annual Losses (%)
        fname = 'Change in total annual losses by feeder (%)';
        set_figure_size(fname);
        hold on;
        bar(percent_loss_reduction,'barwidth',barwidth_28cases);
        ylabel('Change in Losses (%)');
        set_figure_graphics(data_labels,[output_dir fname],2,case_labels(2:5),0.03,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        if (plot_monthly_losses == 1)

            load([write_dir,'monthly_losses_t0.mat']);
            data_t0 = monthly_losses;
            load([write_dir,'monthly_losses_t4.mat']);
            data_t4 = monthly_losses;
            load([write_dir,'monthly_losses_t5.mat']);
            data_t5 = monthly_losses;
            load([write_dir,'monthly_losses_t6.mat']);
            data_t6 = monthly_losses;
            load([write_dir,'monthly_losses_t7.mat']);
            data_t7 = monthly_losses;

            clear monthly_losses;        

            if (plot_testing == 1)
                M = 6;
                L = 6;
            else
                M = 1;
                L = length(data_labels);
            end

            for kkind=M:L % by feeder
                for jjind=1:12 % by month
                    monthly_losses(jjind,1)=sum(data_t0{kkind,3}(:,jjind)); % Base Case 
                    monthly_losses(jjind,2)=sum(data_t4{kkind,3}(:,jjind));
                    monthly_losses(jjind,3)=sum(data_t5{kkind,3}(:,jjind));
                    monthly_losses(jjind,4)=sum(data_t6{kkind,3}(:,jjind));
                    monthly_losses(jjind,5)=sum(data_t7{kkind,3}(:,jjind));
                end

                % Energy Consuption (MWh)
                fname = ['Comparison of losses by month for ' char(data_labels(kkind))];
                set_figure_size(fname);
                hold on;
                bar(monthly_losses / 1000000,'barwidth',barwidth_28cases);
                ylabel('Monthly Losses (MWh)');           
                set_figure_graphics(monthly_labels,[output_dir fname],3,case_labels,0.02,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end
            end       
        end
    end % End of losses plots

    %% PLOT EMISSIONS
    if (plot_emissions == 1)
        load([write_dir,'emissions_t0.mat']);
        data_t0 = emissions_totals;
        load([write_dir,'emissions_t4.mat']);
        data_t4 = emissions_totals;
        load([write_dir,'emissions_t5.mat']);
        data_t5 = emissions_totals;
        load([write_dir,'emissions_t6.mat']);
        data_t6 = emissions_totals;
        load([write_dir,'emissions_t7.mat']);
        data_t7 = emissions_totals;

        clear emissions_totals;

        data_labels = strrep(data_t0(:,1),'_t0','');
        data_labels = strrep(data_labels,'_','-');

        emissions_data(:,1)=cell2mat(data_t0(:,2));
        emissions_data(:,2)=cell2mat(data_t4(:,2));
        emissions_data(:,3)=cell2mat(data_t5(:,2));
        emissions_data(:,4)=cell2mat(data_t6(:,2));
        emissions_data(:,5)=cell2mat(data_t7(:,2));

        emissions_change(:,1) = emissions_data(:,2)-emissions_data(:,1);
        emissions_change(:,2) = emissions_data(:,3)-emissions_data(:,1);
        emissions_change(:,3) = emissions_data(:,4)-emissions_data(:,1);
        emissions_change(:,4) = emissions_data(:,5)-emissions_data(:,1);

        percent_emissions_change(:,1)=100*(emissions_change(:,1))./emissions_data(:,1);
        percent_emissions_change(:,2)=100*(emissions_change(:,2))./emissions_data(:,1);
        percent_emissions_change(:,3)=100*(emissions_change(:,3))./emissions_data(:,1);
        percent_emissions_change(:,4)=100*(emissions_change(:,4))./emissions_data(:,1);

        % Total annual CO2 emissions
        fname = 'Comparison of total annual CO2 emission by feeder';
        set_figure_size(fname);
        hold on;
        bar(emissions_data,'barwidth',barwidth_28cases);
        ylabel('CO_2 Emissions (tons)');
        set_figure_graphics(data_labels,[output_dir fname],1,case_labels,0.02,'northoutside',0,0,'horizontal');  
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        % Change annual CO2 emissions (tons)
        fname = 'Change in total annual CO2 emissions by feeder (tons)';
        set_figure_size(fname);
        hold on;
        bar(emissions_change);
        ylabel('Change in CO_2 Emissions (tons)');
        set_figure_graphics(data_labels,[output_dir fname],0,case_labels(2:5),-0.01,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        % Change annual CO2 emissions (%)
        fname = 'Change in total annual CO2 emissions by feeder (%)';
        set_figure_size(fname);
        hold on;
        bar(percent_emissions_change);
        ylabel('Change in CO_2 Emissions (%)');
        set_figure_graphics(data_labels,[output_dir fname],2,case_labels(2:5),0.02,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        if (plot_monthly_emissions == 1)

            load([write_dir,'emissions_monthly_t0.mat']);
            data_t0 = emissions_totals_monthly;
            load([write_dir,'emissions_monthly_t4.mat']);
            data_t4 = emissions_totals_monthly;
            load([write_dir,'emissions_monthly_t5.mat']);
            data_t5 = emissions_totals_monthly;
            load([write_dir,'emissions_monthly_t6.mat']);
            data_t6 = emissions_totals_monthly;
            load([write_dir,'emissions_monthly_t7.mat']);
            data_t7 = emissions_totals_monthly;

            clear emissions_totals
            [no_feeders cells] = size(data_t0);

            if (plot_testing == 1)
                M = 6;
                L = 6;
            else
                M = 1;
                L = length(data_labels);
            end

            for kkind=M:L % by feeder
                for jjind=1:12 % by month
                    monthly_emissions_data(jjind,1)=cell2mat(data_t0{kkind,2}(jjind)); % C02Base Case
                    %                 monthly_emissions_data(jjind,3)=cell2mat(data_t0{kkind,3}(jjind)); % SOX Base Case
                    %                 monthly_emissions_data(jjind,5)=cell2mat(data_t0{kkind,4}(jjind)); % NOX Base Case
                    %                 monthly_emissions_data(jjind,7)=cell2mat(data_t0{kkind,5}(jjind)); % PM-10 Base Case


                    monthly_emissions_data(jjind,2)=cell2mat(data_t4{kkind,2}(jjind)); % co2 TES
                    %                 monthly_emissions_data(jjind,4)=cell2mat(data_t0{kkind,3}(jjind)); % sox TES
                    %                 monthly_emissions_data(jjind,6)=cell2mat(data_t0{kkind,4}(jjind)); % nox TES
                    %                 monthly_emissions_data(jjind,8)=cell2mat(data_t0{kkind,5}(jjind)); % pm-10TES


                    monthly_emissions_data(jjind,3)=cell2mat(data_t5{kkind,2}(jjind)); % co2 TES
                    %                 monthly_emissions_data(jjind,4)=cell2mat(data_t0{kkind,3}(jjind)); % sox TES
                    %                 monthly_emissions_data(jjind,6)=cell2mat(data_t0{kkind,4}(jjind)); % nox TES
                    %                 monthly_emissions_data(jjind,8)=cell2mat(data_t0{kkind,5}(jjind)); % pm-10TES


                    monthly_emissions_data(jjind,4)=cell2mat(data_t6{kkind,2}(jjind)); % co2 TES
                    %                 monthly_emissions_data(jjind,4)=cell2mat(data_t0{kkind,3}(jjind)); % sox TES
                    %                 monthly_emissions_data(jjind,6)=cell2mat(data_t0{kkind,4}(jjind)); % nox TES
                    %                 monthly_emissions_data(jjind,8)=cell2mat(data_t0{kkind,5}(jjind)); % pm-10TES


                    monthly_emissions_data(jjind,5)=cell2mat(data_t7{kkind,2}(jjind)); % co2 TES
                    %                 monthly_emissions_data(jjind,4)=cell2mat(data_t0{kkind,3}(jjind)); % sox TES
                    %                 monthly_emissions_data(jjind,6)=cell2mat(data_t0{kkind,4}(jjind)); % nox TES
                    %                 monthly_emissions_data(jjind,8)=cell2mat(data_t0{kkind,5}(jjind)); % pm-10TES
                end

                % CO2 emissions by month
                fname = ['Comparison of CO2 emissions by month for ' char(data_labels(kkind))];
                set_figure_size(fname);
                hold on;
                bar(monthly_emissions_data,'barwidth',barwidth_12cases);
                ylabel('CO_2 Emissions (tons)');
                set_figure_graphics(monthly_labels,[output_dir fname],1,case_labels,0,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end
            end 
        end    
    end% End of emissions plots

    %% IMPACT METRICS
    % The index numbers are set by the indicies of 'impact_metrics' are specific for TES
    my_file_ind = 0;

    if ( generate_impact_metrics == 1)
        for tech_ind = 4:7
            %Create an index for knowing when we've already completed base
            my_file_ind = my_file_ind + 1;

            %Create the impact matrices
            impact_metrics_R1_t0=zeros(32,6);
            impact_metrics_R2_t0=zeros(32,6);
            impact_metrics_R3_t0=zeros(32,4);
            impact_metrics_R4_t0=zeros(32,4);
            impact_metrics_R5_t0=zeros(32,8);

            impact_metrics_R1_t9=zeros(31,6);
            impact_metrics_R2_t9=zeros(31,6);
            impact_metrics_R3_t9=zeros(31,4);
            impact_metrics_R4_t9=zeros(31,4);
            impact_metrics_R5_t9=zeros(31,8);

    %         impact_metrics_R1_diff_t9=zeros(30,6);
    %         impact_metrics_R2_diff_t9=zeros(30,6);
    %         impact_metrics_R3_diff_t9=zeros(30,4);
    %         impact_metrics_R4_diff_t9=zeros(30,4);
    %         impact_metrics_R5_diff_t9=zeros(30,8);

    %         %Load in storage values
    %         load([write_dir,'storage_values_t' num2str(tech_ind) '.mat']);
    %         data_t9 = storage_values;
    % 
    %         %Put MWh into kWh for metric
    %         storage_kWh_data=cell2mat(data_t9(:,2))*1000;
    % 
    %         clear storage_values storage_values;
    % 
    %         %Put storage into t9 impact - Annual storage dispatch
    %         metrics_index_t9=22;
    %         impact_metrics_R1_t9(metrics_index_t9,:)=[storage_kWh_data(1) storage_kWh_data(6:10).'];
    %         impact_metrics_R2_t9(metrics_index_t9,:)=[storage_kWh_data(2) storage_kWh_data(11:15).'];
    %         impact_metrics_R3_t9(metrics_index_t9,:)=[storage_kWh_data(3) storage_kWh_data(16:18).'];
    %         impact_metrics_R4_t9(metrics_index_t9,:)=[storage_kWh_data(4) storage_kWh_data(19:21).'];
    %         impact_metrics_R5_t9(metrics_index_t9,:)=[storage_kWh_data(5) storage_kWh_data(22:28).'];
    % 
    %         %Annual storage efficiency - it was assumed no thermal losses and cooling efficiency is handled in the house
    %         metrics_index_t9=23;
    %         impact_metrics_R1_t9(metrics_index_t9,:)=100*ones(1,6);
    %         impact_metrics_R2_t9(metrics_index_t9,:)=100*ones(1,6);
    %         impact_metrics_R3_t9(metrics_index_t9,:)=100*ones(1,4);
    %         impact_metrics_R4_t9(metrics_index_t9,:)=100*ones(1,4);
    %         impact_metrics_R5_t9(metrics_index_t9,:)=100*ones(1,8);

            % Index 1 & 2 (Hourly & Monthly end use customer electricty usage)
            load([write_dir,'total_energy_consumption_t0.mat']);
            data_t0 = energy_consumption;
            load([write_dir,'total_energy_consumption_t' num2str(tech_ind) '.mat']);
            data_t9 = energy_consumption;

            load([write_dir,'annual_losses_t0.mat']);
            data_t0_2 = annual_losses;
            load([write_dir,'annual_losses_t' num2str(tech_ind) '.mat']);
            data_t9_2 = annual_losses;
            [no_feeders cells] = size(data_t0);
            clear  energy_consumption annual_losses;

            energy_data(:,1) = cell2mat(data_t0(:,2)); % t0 real power
            energy_data(:,2) = cell2mat(data_t9(:,2)); % t9 real power

            for i=1:length(data_t0)
                temp=cell2mat(data_t0_2(i,3)); % t0 losses
                temp2=cell2mat(data_t9_2(i,3)); % t9 losses
                energy_data(i,3)= temp(6,1);
                energy_data(i,4)= temp2(6,1);
                % t9 losses
            end

            hourly_customer_usage_t0(:,1)=(energy_data(:,1)-energy_data(:,3))/8760000; % Change in average hourly customer (kWh)
            monthly_customer_usage_t0(:,1)=(energy_data(:,1)-energy_data(:,3))/12000000; % Change in average monthly customer (MWh)

            hourly_customer_usage_t9(:,1)=(energy_data(:,2)-energy_data(:,4))/8760000; % Change in average hourly customer (kWh)
            monthly_customer_usage_t9(:,1)=(energy_data(:,2)-energy_data(:,4))/12000000; % Change in average monthly customer (MWh)

            metrics_index_t0=1;
            metrics_index_t9=1;
            impact_metrics_R1_t0(metrics_index_t0,1)=hourly_customer_usage_t0(1,1);
            impact_metrics_R1_t0(metrics_index_t0,2:6)=hourly_customer_usage_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=hourly_customer_usage_t0(2,1);
            impact_metrics_R2_t0(metrics_index_t0,2:6)=hourly_customer_usage_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=hourly_customer_usage_t0(3,1);
            impact_metrics_R3_t0(metrics_index_t0,2:4)=hourly_customer_usage_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=hourly_customer_usage_t0(4,1);
            impact_metrics_R4_t0(metrics_index_t0,2:4)=hourly_customer_usage_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=hourly_customer_usage_t0(5,1);
            impact_metrics_R5_t0(metrics_index_t0,2:8)=hourly_customer_usage_t0(22:28,1)';

            impact_metrics_R1_t9(metrics_index_t9,1)=hourly_customer_usage_t9(1,1);
            impact_metrics_R1_t9(metrics_index_t9,2:6)=hourly_customer_usage_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=hourly_customer_usage_t9(2,1);
            impact_metrics_R2_t9(metrics_index_t9,2:6)=hourly_customer_usage_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=hourly_customer_usage_t9(3,1);
            impact_metrics_R3_t9(metrics_index_t9,2:4)=hourly_customer_usage_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=hourly_customer_usage_t9(4,1);
            impact_metrics_R4_t9(metrics_index_t9,2:4)=hourly_customer_usage_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=hourly_customer_usage_t9(5,1);
            impact_metrics_R5_t9(metrics_index_t9,2:8)=hourly_customer_usage_t9(22:28,1)';

    %         impact_metrics_R1_diff_t9(metrics_index_t9,:)= impact_metrics_R1_t9(metrics_index_t9,:) - impact_metrics_R1_t0(metrics_index_t0,:);
    %         impact_metrics_R2_diff_t9(metrics_index_t9,:)= impact_metrics_R2_t9(metrics_index_t9,:) - impact_metrics_R2_t0(metrics_index_t0,:);
    %         impact_metrics_R3_diff_t9(metrics_index_t9,:)= impact_metrics_R3_t9(metrics_index_t9,:) - impact_metrics_R3_t0(metrics_index_t0,:);
    %         impact_metrics_R4_diff_t9(metrics_index_t9,:)= impact_metrics_R4_t9(metrics_index_t9,:) - impact_metrics_R4_t0(metrics_index_t0,:);
    %         impact_metrics_R5_diff_t9(metrics_index_t9,:)= impact_metrics_R5_t9(metrics_index_t9,:) - impact_metrics_R5_t0(metrics_index_t0,:);

            metrics_index_t0=2;
            metrics_index_t9=2;
            impact_metrics_R1_t0(metrics_index_t0,1)=monthly_customer_usage_t0(1,1);
            impact_metrics_R1_t0(metrics_index_t0,2:6)=monthly_customer_usage_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=monthly_customer_usage_t0(2,1);
            impact_metrics_R2_t0(metrics_index_t0,2:6)=monthly_customer_usage_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=monthly_customer_usage_t0(3,1);
            impact_metrics_R3_t0(metrics_index_t0,2:4)=monthly_customer_usage_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=monthly_customer_usage_t0(4,1);
            impact_metrics_R4_t0(metrics_index_t0,2:4)=monthly_customer_usage_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=monthly_customer_usage_t0(5,1);
            impact_metrics_R5_t0(metrics_index_t0,2:8)=monthly_customer_usage_t0(22:28,1)';

            impact_metrics_R1_t9(metrics_index_t9,1)=monthly_customer_usage_t9(1,1);
            impact_metrics_R1_t9(metrics_index_t9,2:6)=monthly_customer_usage_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=monthly_customer_usage_t9(2,1);
            impact_metrics_R2_t9(metrics_index_t9,2:6)=monthly_customer_usage_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=monthly_customer_usage_t9(3,1);
            impact_metrics_R3_t9(metrics_index_t9,2:4)=monthly_customer_usage_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=monthly_customer_usage_t9(4,1);
            impact_metrics_R4_t9(metrics_index_t9,2:4)=monthly_customer_usage_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=monthly_customer_usage_t9(5,1);
            impact_metrics_R5_t9(metrics_index_t9,2:8)=monthly_customer_usage_t9(22:28,1)';

    %         impact_metrics_R1_diff_t9(metrics_index_t9,:)= impact_metrics_R1_t9(metrics_index_t9,:) - impact_metrics_R1_t0(metrics_index_t0,:);
    %         impact_metrics_R2_diff_t9(metrics_index_t9,:)= impact_metrics_R2_t9(metrics_index_t9,:) - impact_metrics_R2_t0(metrics_index_t0,:);
    %         impact_metrics_R3_diff_t9(metrics_index_t9,:)= impact_metrics_R3_t9(metrics_index_t9,:) - impact_metrics_R3_t0(metrics_index_t0,:);
    %         impact_metrics_R4_diff_t9(metrics_index_t9,:)= impact_metrics_R4_t9(metrics_index_t9,:) - impact_metrics_R4_t0(metrics_index_t0,:);
    %         impact_metrics_R5_diff_t9(metrics_index_t9,:)= impact_metrics_R5_t9(metrics_index_t9,:) - impact_metrics_R5_t0(metrics_index_t0,:);

            clear energy_data data_t0 data_t9 data_t0_2 data_t9_2 hourly_customer_usage_t0 hourly_customer_usage_t9 monthly_customer_usage_t0 monthly_customer_usage_t9 temp temp2

            % Index 3 % 4(Peak generation % percentages and peak load)
            load([write_dir,'peakiest_peak_t0.mat']);
            data_t0 = peakiest_peakday;
            load([write_dir,'peakiest_peak_t' num2str(tech_ind) '.mat']);
            data_t9 = peakiest_peakday;

            clear peakiest_peakday;

            peak_power_data(:,1) = cell2mat(data_t0(:,2));
            peak_power_data(:,2) = cell2mat(data_t9(:,2));
            peak_va_data(:,1) = cell2mat(data_t0(:,3));
            peak_va_data(:,2) = cell2mat(data_t9(:,3));

            peak_power_t0=peak_power_data(:,1)/1000; % Peak total demand for t0
            peak_power_t9=peak_power_data(:,2)/1000; % Peak total demand for t9

            metrics_index_t0=3;
            metrics_index_t9=3;
            impact_metrics_R1_t0(metrics_index_t0,1)=peak_power_t0(1,1);
            impact_metrics_R1_t0(metrics_index_t0,2:6)=peak_power_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=peak_power_t0(2,1);
            impact_metrics_R2_t0(metrics_index_t0,2:6)=peak_power_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=peak_power_t0(3,1);
            impact_metrics_R3_t0(metrics_index_t0,2:4)=peak_power_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=peak_power_t0(4,1);
            impact_metrics_R4_t0(metrics_index_t0,2:4)=peak_power_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=peak_power_t0(5,1);
            impact_metrics_R5_t0(metrics_index_t0,2:8)=peak_power_t0(22:28,1)';

            impact_metrics_R1_t9(metrics_index_t9,1)=peak_power_t9(1,1);
            impact_metrics_R1_t9(metrics_index_t9,2:6)=peak_power_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=peak_power_t9(2,1);
            impact_metrics_R2_t9(metrics_index_t9,2:6)=peak_power_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=peak_power_t9(3,1);
            impact_metrics_R3_t9(metrics_index_t9,2:4)=peak_power_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=peak_power_t9(4,1);
            impact_metrics_R4_t9(metrics_index_t9,2:4)=peak_power_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=peak_power_t9(5,1);
            impact_metrics_R5_t9(metrics_index_t9,2:8)=peak_power_t9(22:28,1)';

    %         impact_metrics_R1_diff_t9(metrics_index_t9,:)= impact_metrics_R1_t9(metrics_index_t9,:) - impact_metrics_R1_t0(metrics_index_t0,:);
    %         impact_metrics_R2_diff_t9(metrics_index_t9,:)= impact_metrics_R2_t9(metrics_index_t9,:) - impact_metrics_R2_t0(metrics_index_t0,:);
    %         impact_metrics_R3_diff_t9(metrics_index_t9,:)= impact_metrics_R3_t9(metrics_index_t9,:) - impact_metrics_R3_t0(metrics_index_t0,:);
    %         impact_metrics_R4_diff_t9(metrics_index_t9,:)= impact_metrics_R4_t9(metrics_index_t9,:) - impact_metrics_R4_t0(metrics_index_t0,:);
    %         impact_metrics_R5_diff_t9(metrics_index_t9,:)= impact_metrics_R5_t9(metrics_index_t9,:) - impact_metrics_R5_t0(metrics_index_t0,:);

            % Generator percentages
            load([write_dir,'emissions_t0.mat']);
            data_t0_2 = emissions_totals;
            load([write_dir,'emissions_t' num2str(tech_ind) '.mat']);
            data_t9_2 = emissions_totals;

            clear emissions_totals;

            data_labels = strrep(data_t0(:,1),'_t0','');
            data_labels = strrep(data_labels,'_','-');

            for i=1:length(data_labels)
                temp1(i,:)=cell2mat(data_t0_2(i,6)); % t0 percent generation for each feeder
                temp2(i,:)=cell2mat(data_t9_2(i,6)); % t9 percent generation for each feeder
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

            metrics_index_start_t0=4;
            metrics_index_stop_t0=12;
            impact_metrics_R1_t0(metrics_index_start_t0:metrics_index_stop_t0,1:6)=Temp_R1;
            impact_metrics_R2_t0(metrics_index_start_t0:metrics_index_stop_t0,1:6)=Temp_R2;
            impact_metrics_R3_t0(metrics_index_start_t0:metrics_index_stop_t0,1:4)=Temp_R3;
            impact_metrics_R4_t0(metrics_index_start_t0:metrics_index_stop_t0,1:4)=Temp_R4;
            impact_metrics_R5_t0(metrics_index_start_t0:metrics_index_stop_t0,1:8)=Temp_R5;


            metrics_index_start_t9=4;
            metrics_index_stop_t9=12;
            impact_metrics_R1_t9(metrics_index_start_t9:metrics_index_stop_t9,1:6)=Temp_R6;
            impact_metrics_R2_t9(metrics_index_start_t9:metrics_index_stop_t9,1:6)=Temp_R7;
            impact_metrics_R3_t9(metrics_index_start_t9:metrics_index_stop_t9,1:4)=Temp_R8;
            impact_metrics_R4_t9(metrics_index_start_t9:metrics_index_stop_t9,1:4)=Temp_R9;
            impact_metrics_R5_t9(metrics_index_start_t9:metrics_index_stop_t9,1:8)=Temp_R10;

            clear temp1 temp2 Temp_R1 Temp_R2 Temp_R3 Temp_R4 Temp_R5 Temp_R6 Temp_R7 Temp_R8 Temp_R9 Temp_R10 metrics_index_start metrics_index_stop

            % Fill in zero values for distributed solar and wind
            metrics_index_start_t0=13;
            metrics_index_stop_t0=14;
            for i=metrics_index_start_t0:metrics_index_stop_t0
                metrics_index=i;
                impact_metrics_R1_t0(metrics_index,1)=0;
                impact_metrics_R1_t0(metrics_index,2:6)=0;
                impact_metrics_R2_t0(metrics_index,1)=0;
                impact_metrics_R2_t0(metrics_index,2:6)=0;
                impact_metrics_R3_t0(metrics_index,1)=0;
                impact_metrics_R3_t0(metrics_index,2:4)=0;
                impact_metrics_R4_t0(metrics_index,1)=0;
                impact_metrics_R4_t0(metrics_index,2:4)=0;
                impact_metrics_R5_t0(metrics_index,1)=0;
                impact_metrics_R5_t0(metrics_index,2:8)=0;
            end

            metrics_index_start_t9=13;
            metrics_index_stop_t9=14;
            for i=metrics_index_start_t9:metrics_index_stop_t9
                metrics_index=i;
                impact_metrics_R1_t9(metrics_index,1)=0;
                impact_metrics_R1_t9(metrics_index,2:6)=0;
                impact_metrics_R2_t9(metrics_index,1)=0;
                impact_metrics_R2_t9(metrics_index,2:6)=0;
                impact_metrics_R3_t9(metrics_index,1)=0;
                impact_metrics_R3_t9(metrics_index,2:4)=0;
                impact_metrics_R4_t9(metrics_index,1)=0;
                impact_metrics_R4_t9(metrics_index,2:4)=0;
                impact_metrics_R5_t9(metrics_index,1)=0;
                impact_metrics_R5_t9(metrics_index,2:8)=0;
            end

            peak_demand_t0=(cell2mat(data_t0(:,2))-cell2mat(data_t0(:,4)))/1000; % Peak end use demand for t0
            peak_demand_t9=(cell2mat(data_t9(:,2))-cell2mat(data_t0(:,4)))/1000; % Peak end use demand for t9
            % Convert to kW

            metrics_index_t0=15;
            impact_metrics_R1_t0(metrics_index_t0,1)=peak_demand_t0(1,1);
            impact_metrics_R1_t0(metrics_index_t0,2:6)=peak_demand_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=peak_demand_t0(2,1);
            impact_metrics_R2_t0(metrics_index_t0,2:6)=peak_demand_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=peak_demand_t0(3,1);
            impact_metrics_R3_t0(metrics_index_t0,2:4)=peak_demand_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=peak_demand_t0(4,1);
            impact_metrics_R4_t0(metrics_index_t0,2:4)=peak_demand_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=peak_demand_t0(5,1);
            impact_metrics_R5_t0(metrics_index_t0,2:8)=peak_demand_t0(22:28,1)';

            metrics_index_t9=15;
            impact_metrics_R1_t9(metrics_index_t9,1)=peak_demand_t9(1,1);
            impact_metrics_R1_t9(metrics_index_t9,2:6)=peak_demand_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=peak_demand_t9(2,1);
            impact_metrics_R2_t9(metrics_index_t9,2:6)=peak_demand_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=peak_demand_t9(3,1);
            impact_metrics_R3_t9(metrics_index_t9,2:4)=peak_demand_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=peak_demand_t9(4,1);
            impact_metrics_R4_t9(metrics_index_t9,2:4)=peak_demand_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=peak_demand_t9(5,1);
            impact_metrics_R5_t9(metrics_index_t9,2:8)=peak_demand_t9(22:28,1)';

    %         impact_metrics_R1_diff_t9(metrics_index_t9-11,:)= impact_metrics_R1_t9(metrics_index_t9,:) - impact_metrics_R1_t0(metrics_index_t0,:);
    %         impact_metrics_R2_diff_t9(metrics_index_t9-11,:)= impact_metrics_R2_t9(metrics_index_t9,:) - impact_metrics_R2_t0(metrics_index_t0,:);
    %         impact_metrics_R3_diff_t9(metrics_index_t9-11,:)= impact_metrics_R3_t9(metrics_index_t9,:) - impact_metrics_R3_t0(metrics_index_t0,:);
    %         impact_metrics_R4_diff_t9(metrics_index_t9-11,:)= impact_metrics_R4_t9(metrics_index_t9,:) - impact_metrics_R4_t0(metrics_index_t0,:);
    %         impact_metrics_R5_diff_t9(metrics_index_t9-11,:)= impact_metrics_R5_t9(metrics_index_t9,:) - impact_metrics_R5_t0(metrics_index_t0,:);

            % TODO:  There is Controllable load for DR - how to calculate?
            metrics_index_t0=16;
            impact_metrics_R1_t0(metrics_index_t0,1)=0;
            impact_metrics_R1_t0(metrics_index_t0,2:6)=0';
            impact_metrics_R2_t0(metrics_index_t0,1)=0;
            impact_metrics_R2_t0(metrics_index_t0,2:6)=0;
            impact_metrics_R3_t0(metrics_index_t0,1)=0;
            impact_metrics_R3_t0(metrics_index_t0,2:4)=0;
            impact_metrics_R4_t0(metrics_index_t0,1)=0;
            impact_metrics_R4_t0(metrics_index_t0,2:4)=0;
            impact_metrics_R5_t0(metrics_index_t0,1)=0;
            impact_metrics_R5_t0(metrics_index_t0,2:8)=0;

            metrics_index_t9=16;
            impact_metrics_R1_t9(metrics_index_t9,1)=0;
            impact_metrics_R1_t9(metrics_index_t9,2:6)=0;
            impact_metrics_R2_t9(metrics_index_t9,1)=0;
            impact_metrics_R2_t9(metrics_index_t9,2:6)=0;
            impact_metrics_R3_t9(metrics_index_t9,1)=0;
            impact_metrics_R3_t9(metrics_index_t9,2:4)=0;
            impact_metrics_R4_t9(metrics_index_t9,1)=0;
            impact_metrics_R4_t9(metrics_index_t9,2:4)=0;
            impact_metrics_R5_t9(metrics_index_t9,1)=0;
            impact_metrics_R5_t9(metrics_index_t9,2:8)=0;

    %         impact_metrics_R1_diff_t9(metrics_index_t9-11,:)= impact_metrics_R1_t9(metrics_index_t9,:) - impact_metrics_R1_t0(metrics_index_t0,:);
    %         impact_metrics_R2_diff_t9(metrics_index_t9-11,:)= impact_metrics_R2_t9(metrics_index_t9,:) - impact_metrics_R2_t0(metrics_index_t0,:);
    %         impact_metrics_R3_diff_t9(metrics_index_t9-11,:)= impact_metrics_R3_t9(metrics_index_t9,:) - impact_metrics_R3_t0(metrics_index_t0,:);
    %         impact_metrics_R4_diff_t9(metrics_index_t9-11,:)= impact_metrics_R4_t9(metrics_index_t9,:) - impact_metrics_R4_t0(metrics_index_t0,:);
    %         impact_metrics_R5_diff_t9(metrics_index_t9-11,:)= impact_metrics_R5_t9(metrics_index_t9,:) - impact_metrics_R5_t0(metrics_index_t0,:);

            clear data_t0 data_t9 data_t0 data_t9 peak_demand_t0 peak_demand_t9 peak_power_t0 peak_power_t9 peak_va_data peak_power_data

            % Index 7 (Annual Electricty production) % Index 21 (Distribution Feeder Load)
            load([write_dir,'total_energy_consumption_t0.mat']);
            data_t0 = energy_consumption;
            load([write_dir,'total_energy_consumption_t' num2str(tech_ind) '.mat']);
            data_t9 = energy_consumption;

            clear energy_consumption;

            energy_data(:,1) = cell2mat(data_t0(:,2)); % t0 real power
            energy_data(:,2) = cell2mat(data_t9(:,2)); % t9 real power
            energy_data(:,3) = cell2mat(data_t0(:,3)); % t0 reactive power
            energy_data(:,4) = cell2mat(data_t9(:,3)); % t9 reactive power

            energy_consuption_t0=energy_data(:,1)/1000000;
            energy_consuption_t9=energy_data(:,2)/1000000;

            metrics_index_t0=17;
            impact_metrics_R1_t0(metrics_index_t0,1)=energy_consuption_t0(1,1); %GC
            impact_metrics_R1_t0(metrics_index_t0,2:6)=energy_consuption_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=energy_consuption_t0(2,1); %GC
            impact_metrics_R2_t0(metrics_index_t0,2:6)=energy_consuption_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=energy_consuption_t0(3,1); %GC
            impact_metrics_R3_t0(metrics_index_t0,2:4)=energy_consuption_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=energy_consuption_t0(4,1); %GC
            impact_metrics_R4_t0(metrics_index_t0,2:4)=energy_consuption_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=energy_consuption_t0(5,1); %GC
            impact_metrics_R5_t0(metrics_index_t0,2:8)=energy_consuption_t0(22:28,1)';

            metrics_index_t9=17;
            impact_metrics_R1_t9(metrics_index_t9,1)=energy_consuption_t9(1,1); %GC
            impact_metrics_R1_t9(metrics_index_t9,2:6)=energy_consuption_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=energy_consuption_t9(2,1); %GC
            impact_metrics_R2_t9(metrics_index_t9,2:6)=energy_consuption_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=energy_consuption_t9(3,1); %GC
            impact_metrics_R3_t9(metrics_index_t9,2:4)=energy_consuption_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=energy_consuption_t9(4,1); %GC
            impact_metrics_R4_t9(metrics_index_t9,2:4)=energy_consuption_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=energy_consuption_t9(5,1); %GC
            impact_metrics_R5_t9(metrics_index_t9,2:8)=energy_consuption_t9(22:28,1)';

    %         impact_metrics_R1_diff_t9(metrics_index_t9-11,:)= impact_metrics_R1_t9(metrics_index_t9,:) - impact_metrics_R1_t0(metrics_index_t0,:);
    %         impact_metrics_R2_diff_t9(metrics_index_t9-11,:)= impact_metrics_R2_t9(metrics_index_t9,:) - impact_metrics_R2_t0(metrics_index_t0,:);
    %         impact_metrics_R3_diff_t9(metrics_index_t9-11,:)= impact_metrics_R3_t9(metrics_index_t9,:) - impact_metrics_R3_t0(metrics_index_t0,:);
    %         impact_metrics_R4_diff_t9(metrics_index_t9-11,:)= impact_metrics_R4_t9(metrics_index_t9,:) - impact_metrics_R4_t0(metrics_index_t0,:);
    %         impact_metrics_R5_diff_t9(metrics_index_t9-11,:)= impact_metrics_R5_t9(metrics_index_t9,:) - impact_metrics_R5_t0(metrics_index_t0,:);

            % Average hourly feeder loading (Index 21)
            energy_average_hourly_t0=energy_data(:,1)/8760000; % real power (kWH)
            energy_average_hourly_t9=energy_data(:,2)/8760000; % real power (kWH)

            energy_average_hourly_t0(:,2)=energy_data(:,3)/8760000; % reactive power (kVAR)
            energy_average_hourly_t9(:,2)=energy_data(:,4)/8760000; % reactive power (kVAR)

            % real power
            metrics_index_t0=25;
            impact_metrics_R1_t0(metrics_index_t0,1)=energy_average_hourly_t0(1,1); %GC
            impact_metrics_R1_t0(metrics_index_t0,2:6)=energy_average_hourly_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=energy_average_hourly_t0(2,1); %GC
            impact_metrics_R2_t0(metrics_index_t0,2:6)=energy_average_hourly_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=energy_average_hourly_t0(3,1); %GC
            impact_metrics_R3_t0(metrics_index_t0,2:4)=energy_average_hourly_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=energy_average_hourly_t0(4,1); %GC
            impact_metrics_R4_t0(metrics_index_t0,2:4)=energy_average_hourly_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=energy_average_hourly_t0(5,1); %GC
            impact_metrics_R5_t0(metrics_index_t0,2:8)=energy_average_hourly_t0(22:28,1)';

            metrics_index_t9=24;
            impact_metrics_R1_t9(metrics_index_t9,1)=energy_average_hourly_t9(1,1); %GC
            impact_metrics_R1_t9(metrics_index_t9,2:6)=energy_average_hourly_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=energy_average_hourly_t9(2,1); %GC
            impact_metrics_R2_t9(metrics_index_t9,2:6)=energy_average_hourly_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=energy_average_hourly_t9(3,1); %GC
            impact_metrics_R3_t9(metrics_index_t9,2:4)=energy_average_hourly_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=energy_average_hourly_t9(4,1); %GC
            impact_metrics_R4_t9(metrics_index_t9,2:4)=energy_average_hourly_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=energy_average_hourly_t9(5,1); %GC
            impact_metrics_R5_t9(metrics_index_t9,2:8)=energy_average_hourly_t9(22:28,1)';

    %         impact_metrics_R1_diff_t9(metrics_index_t9-11,:)= impact_metrics_R1_t9(metrics_index_t9,:) - impact_metrics_R1_t0(metrics_index_t0,:);
    %         impact_metrics_R2_diff_t9(metrics_index_t9-11,:)= impact_metrics_R2_t9(metrics_index_t9,:) - impact_metrics_R2_t0(metrics_index_t0,:);
    %         impact_metrics_R3_diff_t9(metrics_index_t9-11,:)= impact_metrics_R3_t9(metrics_index_t9,:) - impact_metrics_R3_t0(metrics_index_t0,:);
    %         impact_metrics_R4_diff_t9(metrics_index_t9-11,:)= impact_metrics_R4_t9(metrics_index_t9,:) - impact_metrics_R4_t0(metrics_index_t0,:);
    %         impact_metrics_R5_diff_t9(metrics_index_t9-11,:)= impact_metrics_R5_t9(metrics_index_t9,:) - impact_metrics_R5_t0(metrics_index_t0,:);

            % Reactive power
            metrics_index_t0=26;
            impact_metrics_R1_t0(metrics_index_t0,1)=energy_average_hourly_t0(1,2); %GC
            impact_metrics_R1_t0(metrics_index_t0,2:6)=energy_average_hourly_t0(6:10,2)';
            impact_metrics_R2_t0(metrics_index_t0,1)=energy_average_hourly_t0(2,2); %GC
            impact_metrics_R2_t0(metrics_index_t0,2:6)=energy_average_hourly_t0(11:15,2)';
            impact_metrics_R3_t0(metrics_index_t0,1)=energy_average_hourly_t0(3,2); %GC
            impact_metrics_R3_t0(metrics_index_t0,2:4)=energy_average_hourly_t0(16:18,2)';
            impact_metrics_R4_t0(metrics_index_t0,1)=energy_average_hourly_t0(4,2); %GC
            impact_metrics_R4_t0(metrics_index_t0,2:4)=energy_average_hourly_t0(19:21,2)';
            impact_metrics_R5_t0(metrics_index_t0,1)=energy_average_hourly_t0(5,2); %GC
            impact_metrics_R5_t0(metrics_index_t0,2:8)=energy_average_hourly_t0(22:28,2)';

            metrics_index_t9=25;
            impact_metrics_R1_t9(metrics_index_t9,1)=energy_average_hourly_t9(1,2); %GC
            impact_metrics_R1_t9(metrics_index_t9,2:6)=energy_average_hourly_t9(6:10,2)';
            impact_metrics_R2_t9(metrics_index_t9,1)=energy_average_hourly_t9(2,2); %GC
            impact_metrics_R2_t9(metrics_index_t9,2:6)=energy_average_hourly_t9(11:15,2)';
            impact_metrics_R3_t9(metrics_index_t9,1)=energy_average_hourly_t9(3,2); %GC
            impact_metrics_R3_t9(metrics_index_t9,2:4)=energy_average_hourly_t9(16:18,2)';
            impact_metrics_R4_t9(metrics_index_t9,1)=energy_average_hourly_t9(4,2); %GC
            impact_metrics_R4_t9(metrics_index_t9,2:4)=energy_average_hourly_t9(19:21,2)';
            impact_metrics_R5_t9(metrics_index_t9,1)=energy_average_hourly_t9(5,2); %GC
            impact_metrics_R5_t9(metrics_index_t9,2:8)=energy_average_hourly_t9(22:28,2)';

    %         impact_metrics_R1_diff_t9(metrics_index_t9-11,:)= impact_metrics_R1_t9(metrics_index_t9,:) - impact_metrics_R1_t0(metrics_index_t0,:);
    %         impact_metrics_R2_diff_t9(metrics_index_t9-11,:)= impact_metrics_R2_t9(metrics_index_t9,:) - impact_metrics_R2_t0(metrics_index_t0,:);
    %         impact_metrics_R3_diff_t9(metrics_index_t9-11,:)= impact_metrics_R3_t9(metrics_index_t9,:) - impact_metrics_R3_t0(metrics_index_t0,:);
    %         impact_metrics_R4_diff_t9(metrics_index_t9-11,:)= impact_metrics_R4_t9(metrics_index_t9,:) - impact_metrics_R4_t0(metrics_index_t0,:);
    %         impact_metrics_R5_diff_t9(metrics_index_t9-11,:)= impact_metrics_R5_t9(metrics_index_t9,:) - impact_metrics_R5_t0(metrics_index_t0,:);

            clear data_t0 data_t9 energy_average_hourly_t0 energy_average_hourly_t9 energy_average_hourly_t0 energy_average_hourly_t9 energy_consuption_t0 energy_consuption_t9

            % Index 29 (Distribution Losses)
            load([write_dir,'total_energy_consumption_t0.mat']);
            data_t0 = energy_consumption;
            load([write_dir,'total_energy_consumption_t' num2str(tech_ind) '.mat']);
            data_t9 = energy_consumption;

            load([write_dir,'annual_losses_t0.mat']);
            data_t0_2 = annual_losses;
            load([write_dir,'annual_losses_t' num2str(tech_ind) '.mat']);
            data_t9_2 = annual_losses;

            [no_feeders cells] = size(data_t0);
            clear  energy_consumption anual_losses;

            energy_data(:,1) = cell2mat(data_t0(:,2)); % t0 real power
            energy_data(:,2) = cell2mat(data_t9(:,2)); % t9 real power

            for i=1:length(data_t0)
                temp=cell2mat(data_t0_2(i,3)); % t0 losses
                temp2=cell2mat(data_t9_2(i,3)); % t9 losses
                energy_data(i,3)= temp(6,1);
                energy_data(i,4)= temp2(6,1);
                % t9 losses
            end
            losses_t0=100*(energy_data(:,3)./energy_data(:,1)); % Losses t0 in %
            losses_t9=100*(energy_data(:,4)./energy_data(:,2)); % Losses t9 in %

            metrics_index_t0=27;
            impact_metrics_R1_t0(metrics_index_t0,1)=losses_t0(1,1);
            impact_metrics_R1_t0(metrics_index_t0,2:6)=losses_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=losses_t0(2,1);
            impact_metrics_R2_t0(metrics_index_t0,2:6)=losses_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=losses_t0(3,1);
            impact_metrics_R3_t0(metrics_index_t0,2:4)=losses_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=losses_t0(4,1);
            impact_metrics_R4_t0(metrics_index_t0,2:4)=losses_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=losses_t0(5,1);
            impact_metrics_R5_t0(metrics_index_t0,2:8)=losses_t0(22:28,1)';

            metrics_index_t9=26;
            impact_metrics_R1_t9(metrics_index_t9,1)=losses_t9(1,1);
            impact_metrics_R1_t9(metrics_index_t9,2:6)=losses_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=losses_t9(2,1);
            impact_metrics_R2_t9(metrics_index_t9,2:6)=losses_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=losses_t9(3,1);
            impact_metrics_R3_t9(metrics_index_t9,2:4)=losses_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=losses_t9(4,1);
            impact_metrics_R4_t9(metrics_index_t9,2:4)=losses_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=losses_t9(5,1);
            impact_metrics_R5_t9(metrics_index_t9,2:8)=losses_t9(22:28,1)';

    %         impact_metrics_R1_diff_t9(metrics_index_t9,:)= impact_metrics_R1_t9(metrics_index_t9,:) - impact_metrics_R1_t0(metrics_index_t0,:);
    %         impact_metrics_R2_diff_t9(metrics_index_t9,:)= impact_metrics_R2_t9(metrics_index_t9,:) - impact_metrics_R2_t0(metrics_index_t0,:);
    %         impact_metrics_R3_diff_t9(metrics_index_t9,:)= impact_metrics_R3_t9(metrics_index_t9,:) - impact_metrics_R3_t0(metrics_index_t0,:);
    %         impact_metrics_R4_diff_t9(metrics_index_t9,:)= impact_metrics_R4_t9(metrics_index_t9,:) - impact_metrics_R4_t0(metrics_index_t0,:);
    %         impact_metrics_R5_diff_t9(metrics_index_t9,:)= impact_metrics_R5_t9(metrics_index_t9,:) - impact_metrics_R5_t0(metrics_index_t0,:);

            clear data_t0 data_t9 data_t0_2 data_t9_2 energy_data losses_t0 losses_t9 temp tem2

            % Index 30 (Power Factor)

            load([write_dir,'power_factors_t0.mat']);
            data_t0 = power_factor;
            load([write_dir,'power_factors_t' num2str(tech_ind) '.mat']);
            data_t9 = power_factor;
            [no_feeders cells] = size(data_t0);
            clear  energy_consuption annual_losses;
            clear power_factor

            power_factor_t0=cell2mat(data_t0(:,12)); % Average annual power factor for t0
            power_factor_t9=cell2mat(data_t9(:,12)); % Average annual power factor for t9

            metrics_index_t0=28;
            impact_metrics_R1_t0(metrics_index_t0,1)=power_factor_t0(1,1);
            impact_metrics_R1_t0(metrics_index_t0,2:6)=power_factor_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=power_factor_t0(2,1);
            impact_metrics_R2_t0(metrics_index_t0,2:6)=power_factor_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=power_factor_t0(3,1);
            impact_metrics_R3_t0(metrics_index_t0,2:4)=power_factor_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=power_factor_t0(4,1);
            impact_metrics_R4_t0(metrics_index_t0,2:4)=power_factor_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=power_factor_t0(5,1);
            impact_metrics_R5_t0(metrics_index_t0,2:8)=power_factor_t0(22:28,1)';

            metrics_index_t9=27;
            impact_metrics_R1_t9(metrics_index_t9,1)=power_factor_t9(1,1);
            impact_metrics_R1_t9(metrics_index_t9,2:6)=power_factor_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=power_factor_t9(2,1);
            impact_metrics_R2_t9(metrics_index_t9,2:6)=power_factor_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=power_factor_t9(3,1);
            impact_metrics_R3_t9(metrics_index_t9,2:4)=power_factor_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=power_factor_t9(4,1);
            impact_metrics_R4_t9(metrics_index_t9,2:4)=power_factor_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=power_factor_t9(5,1);
            impact_metrics_R5_t9(metrics_index_t9,2:8)=power_factor_t9(22:28,1)';

            clear data_t0 data_t9 power_factor_t0 power_factor_t9

            clear data_t0 power_factor_t0

        % Index 12, 13, 39 & 40 (end use emissions & total emissions)
            load([write_dir,'emissions_t0.mat']);
            data_t0 = emissions_totals;
            load([write_dir,'emissions_t' num2str(tech_ind) '.mat']);
            data_t9 = emissions_totals;

            clear emissions_totals ;

            temp1=cell2mat(data_t0(1:28,2:5)');
            temp2=cell2mat(data_t9(1:28,2:5)');

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
            metrics_index_start_t0=29;
            metrics_index_stop_t0=32;

            impact_metrics_R1_t0(metrics_index_start_t0:metrics_index_stop_t0,1:6)=Temp_R1;
            impact_metrics_R2_t0(metrics_index_start_t0:metrics_index_stop_t0,1:6)=Temp_R2;
            impact_metrics_R3_t0(metrics_index_start_t0:metrics_index_stop_t0,1:4)=Temp_R3;
            impact_metrics_R4_t0(metrics_index_start_t0:metrics_index_stop_t0,1:4)=Temp_R4;
            impact_metrics_R5_t0(metrics_index_start_t0:metrics_index_stop_t0,1:8)=Temp_R5;

            metrics_index_start_t9=28;
            metrics_index_stop_t9=31;

            impact_metrics_R1_t9(metrics_index_start_t9:metrics_index_stop_t9,1:6)=Temp_R6;
            impact_metrics_R2_t9(metrics_index_start_t9:metrics_index_stop_t9,1:6)=Temp_R7;
            impact_metrics_R3_t9(metrics_index_start_t9:metrics_index_stop_t9,1:4)=Temp_R8;
            impact_metrics_R4_t9(metrics_index_start_t9:metrics_index_stop_t9,1:4)=Temp_R9;
            impact_metrics_R5_t9(metrics_index_start_t9:metrics_index_stop_t9,1:8)=Temp_R10;

            %%%% TODO:FIX
    %         impact_metrics_R1_diff_t9(metrics_index_t9,:)= impact_metrics_R1_t9(metrics_index_t9,:) - impact_metrics_R1_t0(metrics_index_t0,:);
    %         impact_metrics_R2_diff_t9(metrics_index_t9,:)= impact_metrics_R2_t9(metrics_index_t9,:) - impact_metrics_R2_t0(metrics_index_t0,:);
    %         impact_metrics_R3_diff_t9(metrics_index_t9,:)= impact_metrics_R3_t9(metrics_index_t9,:) - impact_metrics_R3_t0(metrics_index_t0,:);
    %         impact_metrics_R4_diff_t9(metrics_index_t9,:)= impact_metrics_R4_t9(metrics_index_t9,:) - impact_metrics_R4_t0(metrics_index_t0,:);
    %         impact_metrics_R5_diff_t9(metrics_index_t9,:)= impact_metrics_R5_t9(metrics_index_t9,:) - impact_metrics_R5_t0(metrics_index_t0,:);

            % Emission to supply the end user
            metrics_index_start_t0=18;
            metrics_index_stop_t0=21;
            for i=metrics_index_start_t0:metrics_index_stop_t0
                impact_metrics_R1_t0(i,1:6)=Temp_R1(i-metrics_index_start_t0+1,:).*(1-impact_metrics_R1_t0(27,:)/100);
                impact_metrics_R2_t0(i,1:6)=Temp_R2(i-metrics_index_start_t0+1,:).*(1-impact_metrics_R2_t0(27,:)/100);
                impact_metrics_R3_t0(i,1:4)=Temp_R3(i-metrics_index_start_t0+1,:).*(1-impact_metrics_R3_t0(27,:)/100);
                impact_metrics_R4_t0(i,1:4)=Temp_R4(i-metrics_index_start_t0+1,:).*(1-impact_metrics_R4_t0(27,:)/100);
                impact_metrics_R5_t0(i,1:8)=Temp_R5(i-metrics_index_start_t0+1,:).*(1-impact_metrics_R5_t0(27,:)/100);
            end

            metrics_index_start_t9=18;
            metrics_index_stop_t9=21;
            for i=metrics_index_start_t0:metrics_index_stop_t0
                impact_metrics_R1_t9(i,1:6)=Temp_R6(i-metrics_index_start_t9+1,:).*(1-impact_metrics_R1_t9(26,:)/100);
                impact_metrics_R2_t9(i,1:6)=Temp_R7(i-metrics_index_start_t9+1,:).*(1-impact_metrics_R2_t9(26,:)/100);
                impact_metrics_R3_t9(i,1:4)=Temp_R8(i-metrics_index_start_t9+1,:).*(1-impact_metrics_R3_t9(26,:)/100);
                impact_metrics_R4_t9(i,1:4)=Temp_R9(i-metrics_index_start_t9+1,:).*(1-impact_metrics_R4_t9(26,:)/100);
                impact_metrics_R5_t9(i,1:8)=Temp_R10(i-metrics_index_start_t9+1,:).*(1-impact_metrics_R5_t9(26,:)/100);
            end

            %%%% TODO:FIX
    %         impact_metrics_R1_diff_t9(metrics_index_t9,:)= impact_metrics_R1_t9(metrics_index_t9,:) - impact_metrics_R1_t0(metrics_index_t0,:);
    %         impact_metrics_R2_diff_t9(metrics_index_t9,:)= impact_metrics_R2_t9(metrics_index_t9,:) - impact_metrics_R2_t0(metrics_index_t0,:);
    %         impact_metrics_R3_diff_t9(metrics_index_t9,:)= impact_metrics_R3_t9(metrics_index_t9,:) - impact_metrics_R3_t0(metrics_index_t0,:);
    %         impact_metrics_R4_diff_t9(metrics_index_t9,:)= impact_metrics_R4_t9(metrics_index_t9,:) - impact_metrics_R4_t0(metrics_index_t0,:);
    %         impact_metrics_R5_diff_t9(metrics_index_t9,:)= impact_metrics_R5_t9(metrics_index_t9,:) - impact_metrics_R5_t0(metrics_index_t0,:);


            clear data_t0 data_t9 Temp_R1 Temp_R2 Temp_R3 Temp_R4 Temp_R5 Temp_R6 Temp_R7 Temp_R8 Temp_R9 Temp_R10 metrics_index_start metrics_index_stop temp1 temp2

            % delete energy storage line       
            impact_metrics_R5_t9(22:23,:) = [];
            impact_metrics_R4_t9(22:23,:) = [];
            impact_metrics_R3_t9(22:23,:) = [];
            impact_metrics_R2_t9(22:23,:) = [];
            impact_metrics_R1_t9(22:23,:) = [];

            % Write t0 values to the Excel file
            if (my_file_ind == 1)
                xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R5_t0,'Base','AP4:AW35')
                xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R4_t0,'Base','AH4:AK35')
                xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R3_t0,'Base','Z4:AC35')
                xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R2_t0,'Base','P4:U35')
                xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R1_t0,'Base','F4:K35')
            end

            % Write t9 values to the Excel file
            xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R5_t9,['For t' num2str(tech_ind)],'AP4:AW32')
            xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R4_t9,['For t' num2str(tech_ind)],'AH4:AK32')
            xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R3_t9,['For t' num2str(tech_ind)],'Z4:AC32')
            xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R2_t9,['For t' num2str(tech_ind)],'P4:U32')
            xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R1_t9,['For t' num2str(tech_ind)],'F4:K32')

            % Write t9 values to the Excel file
    %         xlswrite([output_dir '\SGIG Metrics.xlsx'],impact_metrics_R5_diff_t9,['For t' num2str(tech_ind)],'AP4:AW33')
    %         xlswrite([output_dir '\SGIG Metrics.xlsx'],impact_metrics_R4_diff_t9,['For t' num2str(tech_ind)],'AH4:AK33')
    %         xlswrite([output_dir '\SGIG Metrics.xlsx'],impact_metrics_R3_diff_t9,['For t' num2str(tech_ind)],'Z4:AC33')
    %         xlswrite([output_dir '\SGIG Metrics.xlsx'],impact_metrics_R2_diff_t9,['For t' num2str(tech_ind)],'P4:U33')
    %         xlswrite([output_dir '\SGIG Metrics.xlsx'],impact_metrics_R1_diff_t9,['For t' num2str(tech_ind)],'F4:K33')   

            clear data_t0 data_t9 data_t0_2 data_t9_2;
        end % End of tech loop
    end % End of impact metrics
end

%% Plot DLC
if (plot_DLC == 1)
    %% PLOT ENERGY
    if (plot_energy == 1)
        load([write_dir,'total_energy_consumption_t0.mat']);
        data_t0 = energy_consumption;
        load([write_dir,'total_energy_consumption_t8.mat']);
        data_t8 = energy_consumption;

        clear energy_consumption;

        data_labels = strrep(data_t0(:,1),'_t0','');
        data_labels = strrep(data_labels,'_','-');

        energy_data(:,1) = cell2mat(data_t0(:,2));
        energy_data(:,2) = cell2mat(data_t8(:,2));

        if (plot_monthly_energy == 1)        
            load([write_dir,'monthly_energy_consumption_t0.mat']);
            data_m_t0 = monthly_energy_consumption;
            load([write_dir,'monthly_energy_consumption_t8.mat']);
            data_m_t8 = monthly_energy_consumption;

            clear monthly_energy_consumption;

            for c_ind = 1:length(data_labels)
                % energy_data_monthly(tech,month,feeder)
                    a = data_m_t0(c_ind,2);
                energy_data_monthly(1,:,c_ind) = cell2mat(a)';
                    a = data_m_t8(c_ind,2);
                energy_data_monthly(2,:,c_ind) = cell2mat(a)';
            end
        end

        for kind=1:2
            energy_reduction(:,kind) = energy_data(:,kind) - energy_data(:,1);
            percent_energy_reduction(:,kind) = 100 .* energy_reduction(:,kind) ./ energy_data(:,1);
        end

        % Feeder level summary plots
        if (plot_feeder_summaries == 1)

            fname = ['Total Energy Consumption (MWh) DLC'];
            set_figure_size(fname);
            hold on;
            bar(energy_data / 1000000,'barwidth',barwidth_28cases);
            ylabel('Energy Consumption (MWh)');
            set_figure_graphics(data_labels,[output_dir fname],1,dlc_labels,.06,'northoutside',0,0,'horizontal');
            hold off;
            if (close_plots == 1)
                close(fname);
            end

            fname = ['Total Energy Reduction (MWh) DLC'];
            set_figure_size(fname);
            hold on;
            bar( energy_reduction(:,2) / 1000000,'barwidth',barwidth_28cases);
            ylabel('Change in Energy Consumption (MWh)');
            set_figure_graphics(data_labels,[output_dir fname],3,dlc_labels,-.01,'northoutside',0,0,'horizontal');
            hold off;
            if (close_plots == 1)
                close(fname);
            end

            fname = ['Percent Energy Reduction (%) DLC'];
            set_figure_size(fname);
            hold on;
            bar(percent_energy_reduction(:,2),'barwidth',barwidth_28cases);
            ylabel('Change in Energy Consumption (%)');
            set_figure_graphics(data_labels,[output_dir fname],2,dlc_labels,.04,'northoutside',0,0,'horizontal');      
            hold off;
            if (close_plots == 1)
                close(fname);
            end
        end

        if (plot_individual_feeders == 1)
            if plot_testing == 1
                M = 6;
                L = 6;
            else
                M = 1;
                L = length(data_labels);
            end

            for mind=M:L       
        %         fname = ['Total Energy Consumption ' char(data_labels(mind))];
        %         set_figure_size(fname);
        %         hold on;
        %         bar(energy_data(mind,:) / 1000000,'barwidth',barwidth_4cases);
        %         ylabel('MWh');
        %         set_figure_graphics(case_labels,fname,1,'none',2,'northoutside',0,0,'horizontal');
        %         hold off;
        %         if plot_testing ~= 1
        %             close(fname);
        %         end
        % 
        %         fname = ['Total Energy Reduction ' char(data_labels(mind))];
        %         set_figure_size(fname);
        %         hold on;
        %         bar(energy_reduction(mind,2:5) / 1000000,'barwidth',barwidth_4cases);
        %         ylabel('MWh');
        %         set_figure_graphics(case_labels(2:5),fname,1,'none',2,'northoutside',0,0,'horizontal');
        %         hold off;
        %         if plot_testing ~= 1
        %             close(fname);
        %         end
        % 
        %         fname = ['Percent Energy Reduction ' char(data_labels(mind))];
        %         set_figure_size(fname);
        %         hold on;
        %         bar(percent_energy_reduction(mind,2:5),'barwidth',barwidth_4cases);
        %         ylabel('%');
        %         set_figure_graphics(case_labels(2:5),fname,2,'none',2,'northoutside',0,0,'horizontal');     
        %         hold off;
        %         if plot_testing ~= 1
        %             close(fname);
        %         end

                if (plot_monthly_energy == 1)
                    % Plots energy by month
                    fname = ['Energy (MWh) Monthly DLC ' char(data_labels(mind))];
                    set_figure_size(fname);
                    hold on;
                    bar(energy_data_monthly(:,:,mind)' / 1000000,'barwidth',barwidth_12cases);
                    ylabel('Energy (MWh)');
                    set_figure_graphics(monthly_labels,[output_dir fname],1,dlc_labels,0,'northoutside',0,0,'horizontal');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end
                end
            end
        end
    end

    %% PLOT PEAK POWER
    if (plot_peak_power == 1)
        load([write_dir,'peakiest_peak_t0.mat']);
        data_t0 = peakiest_peakday;
        load([write_dir,'peakiest_peak_t8.mat']);
        data_t8 = peakiest_peakday;

        clear peakiest_peakday;

        data_labels = strrep(data_t0(:,1),'_t0','');
        data_labels = strrep(data_labels,'_','-');

        peak_power_data(:,1) = cell2mat(data_t0(:,2));
        peak_power_data(:,2) = cell2mat(data_t8(:,2));

        peak_va_data(:,1) = cell2mat(data_t0(:,3));
        peak_va_data(:,2) = cell2mat(data_t8(:,3));

        if (plot_monthly_peak == 1)
            load([write_dir,'peakiest_peak_monthly_t0.mat']);
            data_m_t0 = peakiest_peakday_monthly;
            load([write_dir,'peakiest_peak_monthly_t8.mat']);
            data_m_t8 = peakiest_peakday_monthly;

            for c_ind = 1:length(data_labels)
                % peak_power_monthly(tech,month,feeder)
                    a = data_m_t0(c_ind,2);
                peak_power_monthly_data(1,:,c_ind) = cell2mat(a{1,1})';
                    a = data_m_t8(c_ind,2);
                peak_power_monthly_data(2,:,c_ind) = cell2mat(a{1,1})';

                delta_peak_power_monthly(1,:,c_ind) = 100 * (peak_power_monthly_data(2,:,c_ind) - peak_power_monthly_data(1,:,c_ind)) ./ peak_power_monthly_data(1,:,c_ind);
            end

        end

        delta_peak_power(:,1) = 100 * (peak_power_data(:,2) - peak_power_data(:,1)) ./ peak_power_data(:,1);
        delta_peak_va(:,1) = 100 * (peak_va_data(:,2) - peak_va_data(:,1)) ./ peak_va_data(:,1);

        % Individual Feeder Graphs
        if (plot_individual_feeders == 1)
            % loop through each feeder
            if (plot_testing == 1)
                M = 6;
                L = 6;
            else
                M = 1;
                L = length(data_labels);
            end

            for jind = M:L
    %             % Plots peak demand for each of the 5 cases (base + 4DR)
    %             fname = ['Peak Demand (MW) ' char(data_labels(jind))];
    %             set_figure_size(fname);
    %             hold on;
    %             bar(peak_power_data(jind,:) / 1000000,'barwidth',barwidth_4cases);
    %             ylabel('Peak Demand (MW)');
    %             set_figure_graphics(case_labels,fname,1,'none',0,'northoutside',0,0,'horizontal');
    %             hold off;
    %             if plot_testing ~= 1
    %                 close(fname);
    %             end
    % 
    %             % Plots the delta of peak demand of the 4 cases (DR-base)
    %             fname = ['Delta Peak Demand (%) ' char(data_labels(jind))];
    %             set_figure_size(fname);
    %             hold on;
    %             bar(delta_peak_power(jind,:),'barwidth',barwidth_4cases);
    %             ylabel('Change in Peak Demand (%)');
    %             set_figure_graphics(case_labels(2:5),fname,1,'none',0,'northoutside',0,0,'horizontal');
    %             hold off;
    %             if plot_testing ~= 1
    %                 close(fname);
    %             end

                if (plot_monthly_peak == 1)
                    % peak_power_monthly(tech,month,feeder)

                    % Plots peak demand for each of the 5 cases (base + 4DR)
                    fname = ['Peak Demand (MW) Monthly DLC ' char(data_labels(jind))];
                    set_figure_size(fname);
                    hold on;
                    bar(peak_power_monthly_data(:,:,jind)' / 1000000,'barwidth',barwidth_12cases);
                    ylabel('Peak Demand (MW)');
                    set_figure_graphics(monthly_labels,[output_dir fname],1,dlc_labels,0,'northoutside',0,0,'horizontal');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end

                    % Plots the delta of peak demand of the 4 cases (DR-base)
                    fname = ['Delta Peak Demand (%) Monthly DLC' char(data_labels(jind))];
                    set_figure_size(fname);
                    hold on;
                    bar(delta_peak_power_monthly(:,:,jind)','barwidth',barwidth_12cases);
                    ylabel('Change in Peak Demand (%)');
                    set_figure_graphics(monthly_labels,[output_dir fname],1,dlc_labels,0,'northoutside',0,0,'horizontal');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end
                end
            end
        end

        % Feeder level summary plots
 
        fname = ['Peak Demand (MW) DLC'];
        set_figure_size(fname);
        hold on;
        bar(peak_power_data / 1000000,'barwidth',barwidth_28cases);
        ylabel('Peak Demand (MW)');
        set_figure_graphics(data_labels,[output_dir fname],1,dlc_labels,0,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        fname = ['Delta Peak Demand (kW) DLC'];
        set_figure_size(fname);
        hold on;    
        dpower(:,1) = (peak_power_data(:,2)-peak_power_data(:,1));   
        bar( dpower / 1000,'barwidth',barwidth_28cases);
        ylabel('Change in Peak Demand (kW)');
        set_figure_graphics(data_labels,[output_dir fname],3,dlc_labels(2),0,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        fname = ['Delta Peak Demand (%) DLC'];
        set_figure_size(fname);
        hold on;
        bar(delta_peak_power,'barwidth',barwidth_28cases);
        ylabel('Change in Peak Demand (%)');
        set_figure_graphics(data_labels,[output_dir fname],1,dlc_labels(2),0,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end
    end  % end Peak Power

    %% PLOT PEAK TIME SERIES
    if (plot_peak_timeseries == 1)
        load([write_dir,'peak_15days_t0.mat']);
        data_t0 = peak_15days;
        load([write_dir,'peak_15days_t8.mat']);
        data_t8 = peak_15days;

        clear peak_15days;

        field_names_t0 = fieldnames(data_t0);
        field_names_t8 = fieldnames(data_t8);

        if (plot_testing == 1)
            L = 1;
        else
            L = length(field_names_t0);
        end

        year = 2009 * ones(1,4*24);
        month = 6 * ones(1,4*24);
        day = 1 * ones(1,4*24);
        for jjj=1:24
            hour( (4*(jjj-1)+1):4*jjj ) = jjj-1;
        end

        minutes(1,1:4:96) = 0;         
        minutes(1,2:4:96) = 15;
        minutes(1,3:4:96) = 30;
        minutes(1,4:4:96) = 45;

        xdate = datenum(year,month,day,hour,minutes,minutes);

        for f_ind=1:2:L
            eval(['ts_data_t0 =  data_t0.' char(field_names_t0(f_ind)) ';']);
                eval(['ts_timestep =  data_t0.' char(field_names_t0(f_ind+1)) ';']);
            eval(['ts_data_t4 =  data_t4.' char(field_names_t8(f_ind)) ';']);
                eval(['ts_timestep_t4 =  data_t4.' char(field_names_t4(f_ind+1)) ';']);

            if (plot_testing == 1)
                M = 1;
            else
                M = 15;
            end

            for dd_ind = 1:15
                xlab8{:,dd_ind} = strtok(char(ts_timestep_t8{1,dd_ind}));
            end

            for d_ind=1:M
                xlab = strtok(char(ts_timestep{1,d_ind}));

                % tech 8 plot
                for d_ind8 = 1:15
                    if (strcmp(xlab,xlab8{1,d_ind8}) ~= 0)
                        break;
                    end
                end

                xlab88 = strtok(char(ts_timestep_t8{1,d_ind8}));            
                if (strcmp(xlab,xlab88) == 0)
                    disp(['Dates did not match between t0 & t8 on day ' num2str(d_ind) ' on feeder ' char(field_names_t8(f_ind))]);
                    should_I_plot8 = 0;
                else
                    should_I_plot8 = 1;
                end

                if (should_I_plot8 == 1)
                    fname = ['Base versus ',char(field_names_t8(f_ind)),' day',num2str(d_ind)];
                    set_figure_size(fname);
                    hold on;
                    plot(xdate,ts_data_t0(:,d_ind) / 1000000,xdate,ts_data_t8(:,d_ind8) / 1000000,'r','LineWidth',2);
                    ylabel('Power (MW)');
                    yy = ylim;
                    ylim([0 yy(2)]);
                    xx = xlim;           
                    xlabel(xlab);
                    datetick('x','HHPM');
                    xlim([xx(1) xx(2)]);
                    set_figure_graphics('none',[output_dir fname],1,dlc_labels(1:2),0,'northwest');
                    hold off;
                    if (close_plots == 1)
                        close(fname);
                    end
                end
            end    
        end    
    end % end plot peak timeseries
    
    %% PLOT LOSSES
    if (plot_losses == 1)
        load([write_dir,'annual_losses_t0.mat']);
        data_t0 = annual_losses;
        load([write_dir,'annual_losses_t8.mat']);
        data_t8 = annual_losses;

        [no_feeders cells] = size(data_t0);
        clear anual_losses;

        data_labels = strrep(data_t0(:,1),'_t0','');
        data_labels = strrep(data_labels,'_','-');

        for i=1:no_feeders
            loss_data(i,1) = data_t0{i,3}(6,1);
            loss_data(i,2) = data_t8{i,3}(6,1);
        end

        loss_reduction(:,1) = loss_data(:,2)-loss_data(:,1);
        percent_loss_reduction(:,1) = 100.*(loss_reduction(:,1)/loss_data(i,1));

        % Annual Losses
        fname = 'Total annual losses by feeder DLC (MWh)';
        set_figure_size(fname);
        hold on;
        bar(loss_data / 1000000,'barwidth',barwidth_28cases);
        ylabel('Total Losses (MWh)');
        set_figure_graphics(data_labels,[output_dir fname],2,dlc_labels,0.01,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        % Change in Annual Losses (MWh)
        fname = 'Change in total annual losses by feeder DLC (MWh)';
        set_figure_size(fname);
        hold on;
        bar(loss_reduction / 1000000,'barwidth',barwidth_28cases);
        ylabel('Change in Losses (MWh)');
        set_figure_graphics(data_labels,[output_dir fname],2,dlc_labels(2),0.03,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        % Change in Annual Losses (%)
        fname = 'Change in total annual losses by feeder DLC (%)';
        set_figure_size(fname);
        hold on;
        bar(percent_loss_reduction,'barwidth',barwidth_28cases);
        ylabel('Change in Losses (%)');
        set_figure_graphics(data_labels,[output_dir fname],2,dlc_labels(2),0.03,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        if (plot_monthly_losses == 1)

            load([write_dir,'monthly_losses_t0.mat']);
            data_t0 = monthly_losses;
            load([write_dir,'monthly_losses_t8.mat']);
            data_t8 = monthly_losses;

            clear monthly_losses;        

            if (plot_testing == 1)
                M = 6;
                L = 6;
            else
                M = 1;
                L = length(data_labels);
            end

            for kkind=M:L % by feeder
                for jjind=1:12 % by month
                    monthly_losses(jjind,1)=sum(data_t0{kkind,3}(:,jjind)); % Base Case 
                    monthly_losses(jjind,2)=sum(data_t8{kkind,3}(:,jjind));
                end

                % Energy Consuption (MWh)
                fname = ['Comparison of losses by month (DLC) for ' char(data_labels(kkind))];
                set_figure_size(fname);
                hold on;
                bar(monthly_losses / 1000000,'barwidth',barwidth_28cases);
                ylabel('Monthly Losses (MWh)');           
                set_figure_graphics(monthly_labels,[output_dir fname],3,dlc_labels,0.02,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end
            end       
        end
    end % End of losses plots

    %% PLOT EMISSIONS
    if (plot_emissions == 1)
        load([write_dir,'emissions_t0.mat']);
        data_t0 = emissions_totals;
        load([write_dir,'emissions_t8.mat']);
        data_t8 = emissions_totals;

        clear emissions_totals;

        data_labels = strrep(data_t0(:,1),'_t0','');
        data_labels = strrep(data_labels,'_','-');

        emissions_data(:,1)=cell2mat(data_t0(:,2));
        emissions_data(:,2)=cell2mat(data_t8(:,2));

        emissions_change(:,1) = emissions_data(:,2)-emissions_data(:,1);

        percent_emissions_change(:,1)=100*(emissions_change(:,1))./emissions_data(:,1);

        % Total annual CO2 emissions
        fname = 'Comparison of total annual CO2 emission by feeder DLC (tons)';
        set_figure_size(fname);
        hold on;
        bar(emissions_data,'barwidth',barwidth_28cases);
        ylabel('CO_2 Emissions (tons)');
        set_figure_graphics(data_labels,[output_dir fname],1,dlc_labels,0.02,'northoutside',0,0,'horizontal');  
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        % Change annual CO2 emissions (tons)
        fname = 'Change in total annual CO2 emissions by feeder DLC (tons)';
        set_figure_size(fname);
        hold on;
        bar(emissions_change);
        ylabel('Change in CO_2 Emissions (tons)');
        set_figure_graphics(data_labels,[output_dir fname],0,case_labels(2),-0.01,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        % Change annual CO2 emissions (%)
        fname = 'Change in total annual CO2 emissions by feeder DLC (%)';
        set_figure_size(fname);
        hold on;
        bar(percent_emissions_change);
        ylabel('Change in CO_2 Emissions (%)');
        set_figure_graphics(data_labels,[output_dir fname],2,case_labels(5),0.02,'northoutside',0,0,'horizontal');
        hold off;
        if (close_plots == 1)
            close(fname);
        end

        if (plot_monthly_emissions == 1)

            load([write_dir,'emissions_monthly_t0.mat']);
            data_t0 = emissions_totals_monthly;
            load([write_dir,'emissions_monthly_t8.mat']);
            data_t8 = emissions_totals_monthly;

            clear emissions_totals
            [no_feeders cells] = size(data_t0);

            if (plot_testing == 1)
                M = 6;
                L = 6;
            else
                M = 1;
                L = length(data_labels);
            end

            for kkind=M:L % by feeder
                for jjind=1:12 % by month
                    monthly_emissions_data(jjind,1)=cell2mat(data_t0{kkind,2}(jjind)); % C02Base Case
                    %                 monthly_emissions_data(jjind,3)=cell2mat(data_t0{kkind,3}(jjind)); % SOX Base Case
                    %                 monthly_emissions_data(jjind,5)=cell2mat(data_t0{kkind,4}(jjind)); % NOX Base Case
                    %                 monthly_emissions_data(jjind,7)=cell2mat(data_t0{kkind,5}(jjind)); % PM-10 Base Case


                    monthly_emissions_data(jjind,2)=cell2mat(data_t8{kkind,2}(jjind)); % co2 TES
                    %                 monthly_emissions_data(jjind,4)=cell2mat(data_t0{kkind,3}(jjind)); % sox TES
                    %                 monthly_emissions_data(jjind,6)=cell2mat(data_t0{kkind,4}(jjind)); % nox TES
                    %                 monthly_emissions_data(jjind,8)=cell2mat(data_t0{kkind,5}(jjind)); % pm-10TES

                end

                % CO2 emissions by month
                fname = ['Comparison of CO2 emissions by month (DLC) for ' char(data_labels(kkind))];
                set_figure_size(fname);
                hold on;
                bar(monthly_emissions_data,'barwidth',barwidth_12cases);
                ylabel('CO_2 Emissions (tons)');
                set_figure_graphics(monthly_labels,[output_dir fname],1,dlc_labels,0,'northoutside',0,0,'horizontal');
                hold off;
                if (close_plots == 1)
                    close(fname);
                end
            end 
        end    
    end% End of emissions plots

    %% IMPACT METRICS
    % The index numbers are set by the indicies of 'impact_metrics' are specific for TES
    my_file_ind = 0;

    if (generate_impact_metrics == 1)
        for tech_ind = 8:8
            %Create an index for knowing when we've already completed base
            my_file_ind = my_file_ind + 1;

            %Create the impact matrices
            impact_metrics_R1_t0=zeros(32,6);
            impact_metrics_R2_t0=zeros(32,6);
            impact_metrics_R3_t0=zeros(32,4);
            impact_metrics_R4_t0=zeros(32,4);
            impact_metrics_R5_t0=zeros(32,8);

            impact_metrics_R1_t9=zeros(31,6);
            impact_metrics_R2_t9=zeros(31,6);
            impact_metrics_R3_t9=zeros(31,4);
            impact_metrics_R4_t9=zeros(31,4);
            impact_metrics_R5_t9=zeros(31,8);

            % Index 1 & 2 (Hourly & Monthly end use customer electricty usage)
            load([write_dir,'total_energy_consumption_t0.mat']);
            data_t0 = energy_consumption;
            load([write_dir,'total_energy_consumption_t' num2str(tech_ind) '.mat']);
            data_t9 = energy_consumption;

            load([write_dir,'annual_losses_t0.mat']);
            data_t0_2 = annual_losses;
            load([write_dir,'annual_losses_t' num2str(tech_ind) '.mat']);
            data_t9_2 = annual_losses;
            [no_feeders cells] = size(data_t0);
            clear  energy_consumption annual_losses;

            energy_data(:,1) = cell2mat(data_t0(:,2)); % t0 real power
            energy_data(:,2) = cell2mat(data_t9(:,2)); % t9 real power

            for i=1:length(data_t0)
                temp=cell2mat(data_t0_2(i,3)); % t0 losses
                temp2=cell2mat(data_t9_2(i,3)); % t9 losses
                energy_data(i,3)= temp(6,1);
                energy_data(i,4)= temp2(6,1);
                % t9 losses
            end

            hourly_customer_usage_t0(:,1)=(energy_data(:,1)-energy_data(:,3))/8760000; % Change in average hourly customer (kWh)
            monthly_customer_usage_t0(:,1)=(energy_data(:,1)-energy_data(:,3))/12000000; % Change in average monthly customer (MWh)

            hourly_customer_usage_t9(:,1)=(energy_data(:,2)-energy_data(:,4))/8760000; % Change in average hourly customer (kWh)
            monthly_customer_usage_t9(:,1)=(energy_data(:,2)-energy_data(:,4))/12000000; % Change in average monthly customer (MWh)

            metrics_index_t0=1;
            metrics_index_t9=1;
            impact_metrics_R1_t0(metrics_index_t0,1)=hourly_customer_usage_t0(1,1);
            impact_metrics_R1_t0(metrics_index_t0,2:6)=hourly_customer_usage_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=hourly_customer_usage_t0(2,1);
            impact_metrics_R2_t0(metrics_index_t0,2:6)=hourly_customer_usage_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=hourly_customer_usage_t0(3,1);
            impact_metrics_R3_t0(metrics_index_t0,2:4)=hourly_customer_usage_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=hourly_customer_usage_t0(4,1);
            impact_metrics_R4_t0(metrics_index_t0,2:4)=hourly_customer_usage_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=hourly_customer_usage_t0(5,1);
            impact_metrics_R5_t0(metrics_index_t0,2:8)=hourly_customer_usage_t0(22:28,1)';

            impact_metrics_R1_t9(metrics_index_t9,1)=hourly_customer_usage_t9(1,1);
            impact_metrics_R1_t9(metrics_index_t9,2:6)=hourly_customer_usage_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=hourly_customer_usage_t9(2,1);
            impact_metrics_R2_t9(metrics_index_t9,2:6)=hourly_customer_usage_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=hourly_customer_usage_t9(3,1);
            impact_metrics_R3_t9(metrics_index_t9,2:4)=hourly_customer_usage_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=hourly_customer_usage_t9(4,1);
            impact_metrics_R4_t9(metrics_index_t9,2:4)=hourly_customer_usage_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=hourly_customer_usage_t9(5,1);
            impact_metrics_R5_t9(metrics_index_t9,2:8)=hourly_customer_usage_t9(22:28,1)';

            metrics_index_t0=2;
            metrics_index_t9=2;
            impact_metrics_R1_t0(metrics_index_t0,1)=monthly_customer_usage_t0(1,1);
            impact_metrics_R1_t0(metrics_index_t0,2:6)=monthly_customer_usage_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=monthly_customer_usage_t0(2,1);
            impact_metrics_R2_t0(metrics_index_t0,2:6)=monthly_customer_usage_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=monthly_customer_usage_t0(3,1);
            impact_metrics_R3_t0(metrics_index_t0,2:4)=monthly_customer_usage_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=monthly_customer_usage_t0(4,1);
            impact_metrics_R4_t0(metrics_index_t0,2:4)=monthly_customer_usage_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=monthly_customer_usage_t0(5,1);
            impact_metrics_R5_t0(metrics_index_t0,2:8)=monthly_customer_usage_t0(22:28,1)';

            impact_metrics_R1_t9(metrics_index_t9,1)=monthly_customer_usage_t9(1,1);
            impact_metrics_R1_t9(metrics_index_t9,2:6)=monthly_customer_usage_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=monthly_customer_usage_t9(2,1);
            impact_metrics_R2_t9(metrics_index_t9,2:6)=monthly_customer_usage_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=monthly_customer_usage_t9(3,1);
            impact_metrics_R3_t9(metrics_index_t9,2:4)=monthly_customer_usage_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=monthly_customer_usage_t9(4,1);
            impact_metrics_R4_t9(metrics_index_t9,2:4)=monthly_customer_usage_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=monthly_customer_usage_t9(5,1);
            impact_metrics_R5_t9(metrics_index_t9,2:8)=monthly_customer_usage_t9(22:28,1)';

            clear energy_data data_t0 data_t9 data_t0_2 data_t9_2 hourly_customer_usage_t0 hourly_customer_usage_t9 monthly_customer_usage_t0 monthly_customer_usage_t9 temp temp2

            % Index 3 % 4(Peak generation % percentages and peak load)
            load([write_dir,'peakiest_peak_t0.mat']);
            data_t0 = peakiest_peakday;
            load([write_dir,'peakiest_peak_t' num2str(tech_ind) '.mat']);
            data_t9 = peakiest_peakday;

            clear peakiest_peakday;

            peak_power_data(:,1) = cell2mat(data_t0(:,2));
            peak_power_data(:,2) = cell2mat(data_t9(:,2));
            peak_va_data(:,1) = cell2mat(data_t0(:,3));
            peak_va_data(:,2) = cell2mat(data_t9(:,3));

            peak_power_t0=peak_power_data(:,1)/1000; % Peak total demand for t0
            peak_power_t9=peak_power_data(:,2)/1000; % Peak total demand for t9

            metrics_index_t0=3;
            metrics_index_t9=3;
            impact_metrics_R1_t0(metrics_index_t0,1)=peak_power_t0(1,1);
            impact_metrics_R1_t0(metrics_index_t0,2:6)=peak_power_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=peak_power_t0(2,1);
            impact_metrics_R2_t0(metrics_index_t0,2:6)=peak_power_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=peak_power_t0(3,1);
            impact_metrics_R3_t0(metrics_index_t0,2:4)=peak_power_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=peak_power_t0(4,1);
            impact_metrics_R4_t0(metrics_index_t0,2:4)=peak_power_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=peak_power_t0(5,1);
            impact_metrics_R5_t0(metrics_index_t0,2:8)=peak_power_t0(22:28,1)';

            impact_metrics_R1_t9(metrics_index_t9,1)=peak_power_t9(1,1);
            impact_metrics_R1_t9(metrics_index_t9,2:6)=peak_power_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=peak_power_t9(2,1);
            impact_metrics_R2_t9(metrics_index_t9,2:6)=peak_power_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=peak_power_t9(3,1);
            impact_metrics_R3_t9(metrics_index_t9,2:4)=peak_power_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=peak_power_t9(4,1);
            impact_metrics_R4_t9(metrics_index_t9,2:4)=peak_power_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=peak_power_t9(5,1);
            impact_metrics_R5_t9(metrics_index_t9,2:8)=peak_power_t9(22:28,1)';

            % Generator percentages
            load([write_dir,'emissions_t0.mat']);
            data_t0_2 = emissions_totals;
            load([write_dir,'emissions_t' num2str(tech_ind) '.mat']);
            data_t9_2 = emissions_totals;

            clear emissions_totals;

            data_labels = strrep(data_t0(:,1),'_t0','');
            data_labels = strrep(data_labels,'_','-');

            for i=1:length(data_labels)
                temp1(i,:)=cell2mat(data_t0_2(i,6)); % t0 percent generation for each feeder
                temp2(i,:)=cell2mat(data_t9_2(i,6)); % t9 percent generation for each feeder
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

            metrics_index_start_t0=4;
            metrics_index_stop_t0=12;
            impact_metrics_R1_t0(metrics_index_start_t0:metrics_index_stop_t0,1:6)=Temp_R1;
            impact_metrics_R2_t0(metrics_index_start_t0:metrics_index_stop_t0,1:6)=Temp_R2;
            impact_metrics_R3_t0(metrics_index_start_t0:metrics_index_stop_t0,1:4)=Temp_R3;
            impact_metrics_R4_t0(metrics_index_start_t0:metrics_index_stop_t0,1:4)=Temp_R4;
            impact_metrics_R5_t0(metrics_index_start_t0:metrics_index_stop_t0,1:8)=Temp_R5;


            metrics_index_start_t9=4;
            metrics_index_stop_t9=12;
            impact_metrics_R1_t9(metrics_index_start_t9:metrics_index_stop_t9,1:6)=Temp_R6;
            impact_metrics_R2_t9(metrics_index_start_t9:metrics_index_stop_t9,1:6)=Temp_R7;
            impact_metrics_R3_t9(metrics_index_start_t9:metrics_index_stop_t9,1:4)=Temp_R8;
            impact_metrics_R4_t9(metrics_index_start_t9:metrics_index_stop_t9,1:4)=Temp_R9;
            impact_metrics_R5_t9(metrics_index_start_t9:metrics_index_stop_t9,1:8)=Temp_R10;

            clear temp1 temp2 Temp_R1 Temp_R2 Temp_R3 Temp_R4 Temp_R5 Temp_R6 Temp_R7 Temp_R8 Temp_R9 Temp_R10 metrics_index_start metrics_index_stop

            % Fill in zero values for distributed solar and wind
            metrics_index_start_t0=13;
            metrics_index_stop_t0=14;
            for i=metrics_index_start_t0:metrics_index_stop_t0
                metrics_index=i;
                impact_metrics_R1_t0(metrics_index,1)=0;
                impact_metrics_R1_t0(metrics_index,2:6)=0;
                impact_metrics_R2_t0(metrics_index,1)=0;
                impact_metrics_R2_t0(metrics_index,2:6)=0;
                impact_metrics_R3_t0(metrics_index,1)=0;
                impact_metrics_R3_t0(metrics_index,2:4)=0;
                impact_metrics_R4_t0(metrics_index,1)=0;
                impact_metrics_R4_t0(metrics_index,2:4)=0;
                impact_metrics_R5_t0(metrics_index,1)=0;
                impact_metrics_R5_t0(metrics_index,2:8)=0;
            end

            metrics_index_start_t9=13;
            metrics_index_stop_t9=14;
            for i=metrics_index_start_t9:metrics_index_stop_t9
                metrics_index=i;
                impact_metrics_R1_t9(metrics_index,1)=0;
                impact_metrics_R1_t9(metrics_index,2:6)=0;
                impact_metrics_R2_t9(metrics_index,1)=0;
                impact_metrics_R2_t9(metrics_index,2:6)=0;
                impact_metrics_R3_t9(metrics_index,1)=0;
                impact_metrics_R3_t9(metrics_index,2:4)=0;
                impact_metrics_R4_t9(metrics_index,1)=0;
                impact_metrics_R4_t9(metrics_index,2:4)=0;
                impact_metrics_R5_t9(metrics_index,1)=0;
                impact_metrics_R5_t9(metrics_index,2:8)=0;
            end

            peak_demand_t0=(cell2mat(data_t0(:,2))-cell2mat(data_t0(:,4)))/1000; % Peak end use demand for t0
            peak_demand_t9=(cell2mat(data_t9(:,2))-cell2mat(data_t0(:,4)))/1000; % Peak end use demand for t9
            % Convert to kW

            metrics_index_t0=15;
            impact_metrics_R1_t0(metrics_index_t0,1)=peak_demand_t0(1,1);
            impact_metrics_R1_t0(metrics_index_t0,2:6)=peak_demand_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=peak_demand_t0(2,1);
            impact_metrics_R2_t0(metrics_index_t0,2:6)=peak_demand_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=peak_demand_t0(3,1);
            impact_metrics_R3_t0(metrics_index_t0,2:4)=peak_demand_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=peak_demand_t0(4,1);
            impact_metrics_R4_t0(metrics_index_t0,2:4)=peak_demand_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=peak_demand_t0(5,1);
            impact_metrics_R5_t0(metrics_index_t0,2:8)=peak_demand_t0(22:28,1)';

            metrics_index_t9=15;
            impact_metrics_R1_t9(metrics_index_t9,1)=peak_demand_t9(1,1);
            impact_metrics_R1_t9(metrics_index_t9,2:6)=peak_demand_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=peak_demand_t9(2,1);
            impact_metrics_R2_t9(metrics_index_t9,2:6)=peak_demand_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=peak_demand_t9(3,1);
            impact_metrics_R3_t9(metrics_index_t9,2:4)=peak_demand_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=peak_demand_t9(4,1);
            impact_metrics_R4_t9(metrics_index_t9,2:4)=peak_demand_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=peak_demand_t9(5,1);
            impact_metrics_R5_t9(metrics_index_t9,2:8)=peak_demand_t9(22:28,1)';

            % TODO:  There is Controllable load for DR - how to calculate?
            metrics_index_t0=16;
            impact_metrics_R1_t0(metrics_index_t0,1)=0;
            impact_metrics_R1_t0(metrics_index_t0,2:6)=0';
            impact_metrics_R2_t0(metrics_index_t0,1)=0;
            impact_metrics_R2_t0(metrics_index_t0,2:6)=0;
            impact_metrics_R3_t0(metrics_index_t0,1)=0;
            impact_metrics_R3_t0(metrics_index_t0,2:4)=0;
            impact_metrics_R4_t0(metrics_index_t0,1)=0;
            impact_metrics_R4_t0(metrics_index_t0,2:4)=0;
            impact_metrics_R5_t0(metrics_index_t0,1)=0;
            impact_metrics_R5_t0(metrics_index_t0,2:8)=0;

            metrics_index_t9=16;
            impact_metrics_R1_t9(metrics_index_t9,1)=0;
            impact_metrics_R1_t9(metrics_index_t9,2:6)=0;
            impact_metrics_R2_t9(metrics_index_t9,1)=0;
            impact_metrics_R2_t9(metrics_index_t9,2:6)=0;
            impact_metrics_R3_t9(metrics_index_t9,1)=0;
            impact_metrics_R3_t9(metrics_index_t9,2:4)=0;
            impact_metrics_R4_t9(metrics_index_t9,1)=0;
            impact_metrics_R4_t9(metrics_index_t9,2:4)=0;
            impact_metrics_R5_t9(metrics_index_t9,1)=0;
            impact_metrics_R5_t9(metrics_index_t9,2:8)=0;

            clear data_t0 data_t9 data_t0 data_t9 peak_demand_t0 peak_demand_t9 peak_power_t0 peak_power_t9 peak_va_data peak_power_data

            % Index 7 (Annual Electricty production) % Index 21 (Distribution Feeder Load)
            load([write_dir,'total_energy_consumption_t0.mat']);
            data_t0 = energy_consumption;
            load([write_dir,'total_energy_consumption_t' num2str(tech_ind) '.mat']);
            data_t9 = energy_consumption;

            clear energy_consumption;

            energy_data(:,1) = cell2mat(data_t0(:,2)); % t0 real power
            energy_data(:,2) = cell2mat(data_t9(:,2)); % t9 real power
            energy_data(:,3) = cell2mat(data_t0(:,3)); % t0 reactive power
            energy_data(:,4) = cell2mat(data_t9(:,3)); % t9 reactive power

            energy_consuption_t0=energy_data(:,1)/1000000;
            energy_consuption_t9=energy_data(:,2)/1000000;

            metrics_index_t0=17;
            impact_metrics_R1_t0(metrics_index_t0,1)=energy_consuption_t0(1,1); %GC
            impact_metrics_R1_t0(metrics_index_t0,2:6)=energy_consuption_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=energy_consuption_t0(2,1); %GC
            impact_metrics_R2_t0(metrics_index_t0,2:6)=energy_consuption_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=energy_consuption_t0(3,1); %GC
            impact_metrics_R3_t0(metrics_index_t0,2:4)=energy_consuption_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=energy_consuption_t0(4,1); %GC
            impact_metrics_R4_t0(metrics_index_t0,2:4)=energy_consuption_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=energy_consuption_t0(5,1); %GC
            impact_metrics_R5_t0(metrics_index_t0,2:8)=energy_consuption_t0(22:28,1)';

            metrics_index_t9=17;
            impact_metrics_R1_t9(metrics_index_t9,1)=energy_consuption_t9(1,1); %GC
            impact_metrics_R1_t9(metrics_index_t9,2:6)=energy_consuption_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=energy_consuption_t9(2,1); %GC
            impact_metrics_R2_t9(metrics_index_t9,2:6)=energy_consuption_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=energy_consuption_t9(3,1); %GC
            impact_metrics_R3_t9(metrics_index_t9,2:4)=energy_consuption_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=energy_consuption_t9(4,1); %GC
            impact_metrics_R4_t9(metrics_index_t9,2:4)=energy_consuption_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=energy_consuption_t9(5,1); %GC
            impact_metrics_R5_t9(metrics_index_t9,2:8)=energy_consuption_t9(22:28,1)';

            % Average hourly feeder loading (Index 21)
            energy_average_hourly_t0=energy_data(:,1)/8760000; % real power (kWH)
            energy_average_hourly_t9=energy_data(:,2)/8760000; % real power (kWH)

            energy_average_hourly_t0(:,2)=energy_data(:,3)/8760000; % reactive power (kVAR)
            energy_average_hourly_t9(:,2)=energy_data(:,4)/8760000; % reactive power (kVAR)

            % real power
            metrics_index_t0=25;
            impact_metrics_R1_t0(metrics_index_t0,1)=energy_average_hourly_t0(1,1); %GC
            impact_metrics_R1_t0(metrics_index_t0,2:6)=energy_average_hourly_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=energy_average_hourly_t0(2,1); %GC
            impact_metrics_R2_t0(metrics_index_t0,2:6)=energy_average_hourly_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=energy_average_hourly_t0(3,1); %GC
            impact_metrics_R3_t0(metrics_index_t0,2:4)=energy_average_hourly_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=energy_average_hourly_t0(4,1); %GC
            impact_metrics_R4_t0(metrics_index_t0,2:4)=energy_average_hourly_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=energy_average_hourly_t0(5,1); %GC
            impact_metrics_R5_t0(metrics_index_t0,2:8)=energy_average_hourly_t0(22:28,1)';

            metrics_index_t9=24;
            impact_metrics_R1_t9(metrics_index_t9,1)=energy_average_hourly_t9(1,1); %GC
            impact_metrics_R1_t9(metrics_index_t9,2:6)=energy_average_hourly_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=energy_average_hourly_t9(2,1); %GC
            impact_metrics_R2_t9(metrics_index_t9,2:6)=energy_average_hourly_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=energy_average_hourly_t9(3,1); %GC
            impact_metrics_R3_t9(metrics_index_t9,2:4)=energy_average_hourly_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=energy_average_hourly_t9(4,1); %GC
            impact_metrics_R4_t9(metrics_index_t9,2:4)=energy_average_hourly_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=energy_average_hourly_t9(5,1); %GC
            impact_metrics_R5_t9(metrics_index_t9,2:8)=energy_average_hourly_t9(22:28,1)';

            % Reactive power
            metrics_index_t0=26;
            impact_metrics_R1_t0(metrics_index_t0,1)=energy_average_hourly_t0(1,2); %GC
            impact_metrics_R1_t0(metrics_index_t0,2:6)=energy_average_hourly_t0(6:10,2)';
            impact_metrics_R2_t0(metrics_index_t0,1)=energy_average_hourly_t0(2,2); %GC
            impact_metrics_R2_t0(metrics_index_t0,2:6)=energy_average_hourly_t0(11:15,2)';
            impact_metrics_R3_t0(metrics_index_t0,1)=energy_average_hourly_t0(3,2); %GC
            impact_metrics_R3_t0(metrics_index_t0,2:4)=energy_average_hourly_t0(16:18,2)';
            impact_metrics_R4_t0(metrics_index_t0,1)=energy_average_hourly_t0(4,2); %GC
            impact_metrics_R4_t0(metrics_index_t0,2:4)=energy_average_hourly_t0(19:21,2)';
            impact_metrics_R5_t0(metrics_index_t0,1)=energy_average_hourly_t0(5,2); %GC
            impact_metrics_R5_t0(metrics_index_t0,2:8)=energy_average_hourly_t0(22:28,2)';

            metrics_index_t9=25;
            impact_metrics_R1_t9(metrics_index_t9,1)=energy_average_hourly_t9(1,2); %GC
            impact_metrics_R1_t9(metrics_index_t9,2:6)=energy_average_hourly_t9(6:10,2)';
            impact_metrics_R2_t9(metrics_index_t9,1)=energy_average_hourly_t9(2,2); %GC
            impact_metrics_R2_t9(metrics_index_t9,2:6)=energy_average_hourly_t9(11:15,2)';
            impact_metrics_R3_t9(metrics_index_t9,1)=energy_average_hourly_t9(3,2); %GC
            impact_metrics_R3_t9(metrics_index_t9,2:4)=energy_average_hourly_t9(16:18,2)';
            impact_metrics_R4_t9(metrics_index_t9,1)=energy_average_hourly_t9(4,2); %GC
            impact_metrics_R4_t9(metrics_index_t9,2:4)=energy_average_hourly_t9(19:21,2)';
            impact_metrics_R5_t9(metrics_index_t9,1)=energy_average_hourly_t9(5,2); %GC
            impact_metrics_R5_t9(metrics_index_t9,2:8)=energy_average_hourly_t9(22:28,2)';

            clear data_t0 data_t9 energy_average_hourly_t0 energy_average_hourly_t9 energy_average_hourly_t0 energy_average_hourly_t9 energy_consuption_t0 energy_consuption_t9

            % Index 29 (Distribution Losses)
            load([write_dir,'total_energy_consumption_t0.mat']);
            data_t0 = energy_consumption;
            load([write_dir,'total_energy_consumption_t' num2str(tech_ind) '.mat']);
            data_t9 = energy_consumption;

            load([write_dir,'annual_losses_t0.mat']);
            data_t0_2 = annual_losses;
            load([write_dir,'annual_losses_t' num2str(tech_ind) '.mat']);
            data_t9_2 = annual_losses;

            [no_feeders cells] = size(data_t0);
            clear  energy_consumption anual_losses;

            energy_data(:,1) = cell2mat(data_t0(:,2)); % t0 real power
            energy_data(:,2) = cell2mat(data_t9(:,2)); % t9 real power

            for i=1:length(data_t0)
                temp=cell2mat(data_t0_2(i,3)); % t0 losses
                temp2=cell2mat(data_t9_2(i,3)); % t9 losses
                energy_data(i,3)= temp(6,1);
                energy_data(i,4)= temp2(6,1);
                % t9 losses
            end
            losses_t0=100*(energy_data(:,3)./energy_data(:,1)); % Losses t0 in %
            losses_t9=100*(energy_data(:,4)./energy_data(:,2)); % Losses t9 in %

            metrics_index_t0=27;
            impact_metrics_R1_t0(metrics_index_t0,1)=losses_t0(1,1);
            impact_metrics_R1_t0(metrics_index_t0,2:6)=losses_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=losses_t0(2,1);
            impact_metrics_R2_t0(metrics_index_t0,2:6)=losses_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=losses_t0(3,1);
            impact_metrics_R3_t0(metrics_index_t0,2:4)=losses_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=losses_t0(4,1);
            impact_metrics_R4_t0(metrics_index_t0,2:4)=losses_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=losses_t0(5,1);
            impact_metrics_R5_t0(metrics_index_t0,2:8)=losses_t0(22:28,1)';

            metrics_index_t9=26;
            impact_metrics_R1_t9(metrics_index_t9,1)=losses_t9(1,1);
            impact_metrics_R1_t9(metrics_index_t9,2:6)=losses_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=losses_t9(2,1);
            impact_metrics_R2_t9(metrics_index_t9,2:6)=losses_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=losses_t9(3,1);
            impact_metrics_R3_t9(metrics_index_t9,2:4)=losses_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=losses_t9(4,1);
            impact_metrics_R4_t9(metrics_index_t9,2:4)=losses_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=losses_t9(5,1);
            impact_metrics_R5_t9(metrics_index_t9,2:8)=losses_t9(22:28,1)';

            clear data_t0 data_t9 data_t0_2 data_t9_2 energy_data losses_t0 losses_t9 temp tem2

            % Index 30 (Power Factor)

            load([write_dir,'power_factors_t0.mat']);
            data_t0 = power_factor;
            load([write_dir,'power_factors_t' num2str(tech_ind) '.mat']);
            data_t9 = power_factor;
            [no_feeders cells] = size(data_t0);
            clear  energy_consuption annual_losses;
            clear power_factor

            power_factor_t0=cell2mat(data_t0(:,12)); % Average annual power factor for t0
            power_factor_t9=cell2mat(data_t9(:,12)); % Average annual power factor for t9

            metrics_index_t0=28;
            impact_metrics_R1_t0(metrics_index_t0,1)=power_factor_t0(1,1);
            impact_metrics_R1_t0(metrics_index_t0,2:6)=power_factor_t0(6:10,1)';
            impact_metrics_R2_t0(metrics_index_t0,1)=power_factor_t0(2,1);
            impact_metrics_R2_t0(metrics_index_t0,2:6)=power_factor_t0(11:15,1)';
            impact_metrics_R3_t0(metrics_index_t0,1)=power_factor_t0(3,1);
            impact_metrics_R3_t0(metrics_index_t0,2:4)=power_factor_t0(16:18,1)';
            impact_metrics_R4_t0(metrics_index_t0,1)=power_factor_t0(4,1);
            impact_metrics_R4_t0(metrics_index_t0,2:4)=power_factor_t0(19:21,1)';
            impact_metrics_R5_t0(metrics_index_t0,1)=power_factor_t0(5,1);
            impact_metrics_R5_t0(metrics_index_t0,2:8)=power_factor_t0(22:28,1)';

            metrics_index_t9=27;
            impact_metrics_R1_t9(metrics_index_t9,1)=power_factor_t9(1,1);
            impact_metrics_R1_t9(metrics_index_t9,2:6)=power_factor_t9(6:10,1)';
            impact_metrics_R2_t9(metrics_index_t9,1)=power_factor_t9(2,1);
            impact_metrics_R2_t9(metrics_index_t9,2:6)=power_factor_t9(11:15,1)';
            impact_metrics_R3_t9(metrics_index_t9,1)=power_factor_t9(3,1);
            impact_metrics_R3_t9(metrics_index_t9,2:4)=power_factor_t9(16:18,1)';
            impact_metrics_R4_t9(metrics_index_t9,1)=power_factor_t9(4,1);
            impact_metrics_R4_t9(metrics_index_t9,2:4)=power_factor_t9(19:21,1)';
            impact_metrics_R5_t9(metrics_index_t9,1)=power_factor_t9(5,1);
            impact_metrics_R5_t9(metrics_index_t9,2:8)=power_factor_t9(22:28,1)';

            clear data_t0 data_t9 power_factor_t0 power_factor_t9

            clear data_t0 power_factor_t0

        % Index 12, 13, 39 & 40 (end use emissions & total emissions)
            load([write_dir,'emissions_t0.mat']);
            data_t0 = emissions_totals;
            load([write_dir,'emissions_t' num2str(tech_ind) '.mat']);
            data_t9 = emissions_totals;

            clear emissions_totals ;

            temp1=cell2mat(data_t0(1:28,2:5)');
            temp2=cell2mat(data_t9(1:28,2:5)');

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
            metrics_index_start_t0=29;
            metrics_index_stop_t0=32;

            impact_metrics_R1_t0(metrics_index_start_t0:metrics_index_stop_t0,1:6)=Temp_R1;
            impact_metrics_R2_t0(metrics_index_start_t0:metrics_index_stop_t0,1:6)=Temp_R2;
            impact_metrics_R3_t0(metrics_index_start_t0:metrics_index_stop_t0,1:4)=Temp_R3;
            impact_metrics_R4_t0(metrics_index_start_t0:metrics_index_stop_t0,1:4)=Temp_R4;
            impact_metrics_R5_t0(metrics_index_start_t0:metrics_index_stop_t0,1:8)=Temp_R5;

            metrics_index_start_t9=28;
            metrics_index_stop_t9=31;

            impact_metrics_R1_t9(metrics_index_start_t9:metrics_index_stop_t9,1:6)=Temp_R6;
            impact_metrics_R2_t9(metrics_index_start_t9:metrics_index_stop_t9,1:6)=Temp_R7;
            impact_metrics_R3_t9(metrics_index_start_t9:metrics_index_stop_t9,1:4)=Temp_R8;
            impact_metrics_R4_t9(metrics_index_start_t9:metrics_index_stop_t9,1:4)=Temp_R9;
            impact_metrics_R5_t9(metrics_index_start_t9:metrics_index_stop_t9,1:8)=Temp_R10;

            % Emission to supply the end user
            metrics_index_start_t0=18;
            metrics_index_stop_t0=21;
            for i=metrics_index_start_t0:metrics_index_stop_t0
                impact_metrics_R1_t0(i,1:6)=Temp_R1(i-metrics_index_start_t0+1,:).*(1-impact_metrics_R1_t0(27,:)/100);
                impact_metrics_R2_t0(i,1:6)=Temp_R2(i-metrics_index_start_t0+1,:).*(1-impact_metrics_R2_t0(27,:)/100);
                impact_metrics_R3_t0(i,1:4)=Temp_R3(i-metrics_index_start_t0+1,:).*(1-impact_metrics_R3_t0(27,:)/100);
                impact_metrics_R4_t0(i,1:4)=Temp_R4(i-metrics_index_start_t0+1,:).*(1-impact_metrics_R4_t0(27,:)/100);
                impact_metrics_R5_t0(i,1:8)=Temp_R5(i-metrics_index_start_t0+1,:).*(1-impact_metrics_R5_t0(27,:)/100);
            end

            metrics_index_start_t9=18;
            metrics_index_stop_t9=21;
            for i=metrics_index_start_t0:metrics_index_stop_t0
                impact_metrics_R1_t9(i,1:6)=Temp_R6(i-metrics_index_start_t9+1,:).*(1-impact_metrics_R1_t9(26,:)/100);
                impact_metrics_R2_t9(i,1:6)=Temp_R7(i-metrics_index_start_t9+1,:).*(1-impact_metrics_R2_t9(26,:)/100);
                impact_metrics_R3_t9(i,1:4)=Temp_R8(i-metrics_index_start_t9+1,:).*(1-impact_metrics_R3_t9(26,:)/100);
                impact_metrics_R4_t9(i,1:4)=Temp_R9(i-metrics_index_start_t9+1,:).*(1-impact_metrics_R4_t9(26,:)/100);
                impact_metrics_R5_t9(i,1:8)=Temp_R10(i-metrics_index_start_t9+1,:).*(1-impact_metrics_R5_t9(26,:)/100);
            end

            clear data_t0 data_t9 Temp_R1 Temp_R2 Temp_R3 Temp_R4 Temp_R5 Temp_R6 Temp_R7 Temp_R8 Temp_R9 Temp_R10 metrics_index_start metrics_index_stop temp1 temp2

            % delete energy storage line       
            impact_metrics_R5_t9(22:23,:) = [];
            impact_metrics_R4_t9(22:23,:) = [];
            impact_metrics_R3_t9(22:23,:) = [];
            impact_metrics_R2_t9(22:23,:) = [];
            impact_metrics_R1_t9(22:23,:) = [];

            % Write t0 values to the Excel file
            if (my_file_ind == 1)
                xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R5_t0,'Base','AP4:AW35')
                xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R4_t0,'Base','AH4:AK35')
                xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R3_t0,'Base','Z4:AC35')
                xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R2_t0,'Base','P4:U35')
                xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R1_t0,'Base','F4:K35')
            end

            % Write t9 values to the Excel file
            xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R5_t9,['For t' num2str(tech_ind)],'AP4:AW32')
            xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R4_t9,['For t' num2str(tech_ind)],'AH4:AK32')
            xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R3_t9,['For t' num2str(tech_ind)],'Z4:AC32')
            xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R2_t9,['For t' num2str(tech_ind)],'P4:U32')
            xlswrite([output_dir 'SGIG Metrics_DR.xlsx'],impact_metrics_R1_t9,['For t' num2str(tech_ind)],'F4:K32')

            clear data_t0 data_t9 data_t0_2 data_t9_2;
        end
    end    
end

%% CLEAN UP
disp('All done');
if plot_testing ~= 1
    clear;
end