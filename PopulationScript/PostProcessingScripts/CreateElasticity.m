clear;
clc;

cpp_selas_wot = -0.111;
cpp_selas_wt = -0.222;

cpp_delas_wd_wot = -0.027;
cpp_delas_wd_wt = -0.052;
cpp_delas_we = -0.43;

tou_selas_wot = -0.076;
tou_selas_wt = -0.152;

tou_delas_wd_wot = -0.041;
tou_delas_wd_wt = -0.051;
tou_delas_we = -0.43;

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

% CPP days and hours for summer/winter by region_ind
% {region_ind,type} - need to be in sequential order
CPP_ratio = 10;

CPP_w{1,1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1];
CPP_w{1,2} = {};

CPP_s{1,1} = [1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 10 1 1 1 1 1 1];
CPP_s{1,2} = {'2009-07-02';'2009-09-28';'2009-07-03';'2009-09-29';'2009-07-01';'2009-06-16';'2009-08-26';'2009-06-15';'2009-09-30';'2009-10-13';'2009-08-14';'2009-07-24';'2009-09-27';'2009-08-15';'2009-10-31'};

CPP_w{2,1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1];
CPP_w{2,2} = {};

CPP_s{2,1} = [1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 10 1 1 1 1 1 1];
CPP_s{2,2} = {'2009-07-09';'2009-07-14';'2009-08-04';'2009-06-08';'2009-07-03';'2009-07-13';'2009-07-02';'2009-07-08';'2009-08-03';'2009-06-16';'2009-06-15';'2009-07-28';'2009-07-07';'2009-06-20';'2009-07-17'};

CPP_w{3,1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1];
CPP_w{3,2} = {};

CPP_s{3,1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 10 1 1 1 1];
CPP_s{3,2} = {'2009-06-08';'2009-07-08';'2009-07-14';'2009-06-09';'2009-07-16';'2009-07-10';'2009-06-30';'2009-06-22';'2009-06-29';'2009-06-25';'2009-06-24';'2009-07-15';'2009-06-26';'2009-07-13';'2009-07-27'};

CPP_w{4,1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1];
CPP_w{4,2} = {};

CPP_s{4,1} = [1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 10 1 1 1 1 1 1 1];
CPP_s{4,2} = {'2009-08-04';'2009-09-03';'2009-06-26';'2009-09-02';'2009-08-03';'2009-09-04';'2009-08-05';'2009-06-29';'2009-09-07';'2009-07-23';'2009-06-28';'2009-06-30';'2009-07-07';'2009-09-01';'2009-09-05'};

CPP_w{5,1} = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 1 1 1];
CPP_w{5,2} = {};

CPP_s{5,1} = [1 1 1 1 1 1 1 1 1 1 10 10 10 10 10 10 10 1 1 1 1 1 1 1];
CPP_s{5,2} = {'2009-08-21';'2009-08-18';'2009-08-27';'2009-09-01';'2009-06-26';'2009-07-24';'2009-08-12';'2009-06-12';'2009-06-28';'2009-06-27';'2009-07-22';'2009-08-20';'2009-07-05';'2009-05-24';'2009-08-26'};

% go through each day and make a flag
% 1 - TOU
% 2 - Weekend
% 3 - CPP
for region_ind = 1:5
    for day_ind = 1:366
    % open all the files I'll need
        if (day_ind == 1)       
%                 temp_delas_TOU_wt = ['delas_TOU_wt_r' num2str(region_ind) '.player'];
%             delas_TOU_wt = fopen(temp_delas_TOU_wt,'w');          
%                 temp_delas_CPP_wt = ['delas_CPP_wt_r' num2str(region_ind) '.player'];
%             delas_CPP_wt = fopen(temp_delas_CPP_wt,'w');
%                 temp_delas_TOU_wot = ['delas_wot_r' num2str(region_ind) '.player'];
%             delas_TOU_wot = fopen(temp_delas_TOU_wot,'w');
%                 temp_delas_CPP_wot = ['delas_CPP_wot_r' num2str(region_ind) '.player'];
%             delas_CPP_wot = fopen(temp_delas_CPP_wot,'w');
            
%                 temp_selas_TOU_wt = ['selas_TOU_wt_r' num2str(region_ind) '.player'];
%             selas_TOU_wt = fopen(temp_selas_TOU_wt,'w');
%                 temp_selas_CPP_wt = ['selas_CPP_wt_r' num2str(region_ind) '.player'];
%             selas_CPP_wt = fopen(temp_selas_CPP_wt,'w');
%                 temp_selas_TOU_wot = ['selas_TOU_wot_r' num2str(region_ind) '.player'];
%             selas_TOU_wot = fopen(temp_selas_TOU_wot,'w');
%                 temp_selas_CPP_wot = ['selas_CPP_wot_r' num2str(region_ind) '.player'];
%             selas_CPP_wot = fopen(temp_selas_CPP_wot,'w');
            
%                 temp_firsttier_TOU_hours = ['firsttier_TOU_hours_r' num2str(region_ind) '.player'];
%             firsttier_TOU_hours = fopen(temp_firsttier_TOU_hours,'w');
%                 temp_secondtier_TOU_hours = ['secondtier_TOU_hours_r' num2str(region_ind) '.player'];
%             secondtier_TOU_hours = fopen(temp_secondtier_TOU_hours,'w');
%                 temp_firsttier_CPP_hours = ['firsttier_CPP_hours_r' num2str(region_ind) '.player'];
%             firsttier_CPP_hours = fopen(temp_firsttier_CPP_hours,'w');
%                 temp_secondtier_CPP_hours = ['secondtier_CPP_hours_r' num2str(region_ind) '.player'];
%             secondtier_CPP_hours = fopen(temp_secondtier_CPP_hours,'w');
                  temp_CPP_days = ['CPP_days_R' num2str(region_ind) '.player'];
              CPP_days = fopen(temp_CPP_days,'w');
        end
        
        
        current_date = datenum([2009 1 day_ind 00 00 00]);
        temp_month = datevec(current_date);
        month = temp_month(2);
        day = weekday(current_date);
        current_date_str = datestr(current_date, 'yyyy-mm-dd');
        
        if ( strmatch(current_date_str,CPP_s{region_ind,2}) ~= 0 ) %summer CPP day
            if (day == 1 || day == 7) % Sun/Sat
                disp(['Warning: A CPP day fell on a weekend in region_ind ' num2str(region_ind) ': ' current_date_str]);             
            end
            
            daily_sch_CPP = CPP_s(region_ind,1);
            
            total_val = sum(cell2mat(daily_sch_CPP));
            second_tier_hours_CPP = (total_val - 24) / (10 - 1);
            first_tier_hours_CPP = 24 - second_tier_hours_CPP;
            
            if (TOU_m(region_ind,month) == 1) %winter
                daily_sch_TOU = TOU_w(region_ind,:);
            else
                daily_sch_TOU = TOU_s(region_ind,:);
            end
            
            total_val = sum(daily_sch_TOU);
            second_tier_hours_TOU = total_val - 24;
            first_tier_hours_TOU = 24 - second_tier_hours_TOU;
%             
%             fprintf(delas_TOU_wt,'%s 00:00:00,%f\n',current_date_str,tou_delas_wd_wt);
%             fprintf(delas_CPP_wt,'%s 00:00:00,%f\n',current_date_str,cpp_delas_wd_wt);
%             fprintf(delas_TOU_wot,'%s 00:00:00,%f\n',current_date_str,tou_delas_wd_wot);
%             fprintf(delas_CPP_wot,'%s 00:00:00,%f\n',current_date_str,cpp_delas_wd_wot);
%             
%             fprintf(selas_TOU_wt,'%s 00:00:00,%f\n',current_date_str,tou_selas_wt);
%             fprintf(selas_CPP_wt,'%s 00:00:00,%f\n',current_date_str,cpp_selas_wt);
%             fprintf(selas_TOU_wot,'%s 00:00:00,%f\n',current_date_str,tou_selas_wot);
%             fprintf(selas_CPP_wot,'%s 00:00:00,%f\n',current_date_str,cpp_selas_wot);
%             
%             fprintf(firsttier_TOU_hours,'%s 00:00:00,%f\n',current_date_str,first_tier_hours_TOU);
%             fprintf(secondtier_TOU_hours,'%s 00:00:00,%f\n',current_date_str,second_tier_hours_TOU);
%             fprintf(firsttier_CPP_hours,'%s 00:00:00,%f\n',current_date_str,first_tier_hours_CPP);
%             fprintf(secondtier_CPP_hours,'%s 00:00:00,%f\n',current_date_str,second_tier_hours_CPP);
              fprintf(CPP_days,'%s 00:00:00,%s\n',current_date_str,'1');
        elseif ( strmatch(current_date_str,CPP_w{region_ind,2}) ~= 0 ) %winter CPP day
            if (day == 1 || day == 7) % Sun/Sat
                disp(['Warning: A CPP day fell on a weekend in region_ind ' num2str(region_ind)]); 
            end
            %fprints here
            disp(['WARNING: Winter CPP days have not been finished.']);
        elseif ( day == 1 || day == 7 ) % weekend
            if (TOU_m(region_ind,month) == 1) %winter
                daily_sch = TOU_w(region_ind,:);
            else
                daily_sch = TOU_s(region_ind,:);
            end
            
            total_val = sum(daily_sch);
            second_tier_hours = total_val - 24;
            first_tier_hours = 24 - second_tier_hours;
            
%             fprintf(delas_TOU_wt,'%s 00:00:00,%f\n',current_date_str,tou_delas_we);
%             fprintf(delas_CPP_wt,'%s 00:00:00,%f\n',current_date_str,tou_delas_we);
%             fprintf(delas_TOU_wot,'%s 00:00:00,%f\n',current_date_str,tou_delas_we);
%             fprintf(delas_CPP_wot,'%s 00:00:00,%f\n',current_date_str,tou_delas_we);
%             
%             fprintf(selas_TOU_wt,'%s 00:00:00,%f\n',current_date_str,tou_selas_wt);
%             fprintf(selas_CPP_wt,'%s 00:00:00,%f\n',current_date_str,tou_selas_wt);
%             fprintf(selas_TOU_wot,'%s 00:00:00,%f\n',current_date_str,tou_selas_wot);
%             fprintf(selas_CPP_wot,'%s 00:00:00,%f\n',current_date_str,tou_selas_wot);
%             
%             fprintf(firsttier_TOU_hours,'%s 00:00:00,%f\n',current_date_str,first_tier_hours);
%             fprintf(secondtier_TOU_hours,'%s 00:00:00,%f\n',current_date_str,second_tier_hours);
%             fprintf(firsttier_CPP_hours,'%s 00:00:00,%f\n',current_date_str,first_tier_hours);
%             fprintf(secondtier_CPP_hours,'%s 00:00:00,%f\n',current_date_str,second_tier_hours);
            fprintf(CPP_days,'%s 00:00:00,%s\n',current_date_str,'0');
        else % normal TOU day
            if (TOU_m(region_ind,month) == 1) %winter
                daily_sch = TOU_w(region_ind,:);
            else
                daily_sch = TOU_s(region_ind,:);
            end
            
            total_val = sum(daily_sch);
            second_tier_hours = total_val - 24;
            first_tier_hours = 24 - second_tier_hours;
            
%             fprintf(delas_TOU_wt,'%s 00:00:00,%f\n',current_date_str,tou_delas_wd_wt);
%             fprintf(delas_CPP_wt,'%s 00:00:00,%f\n',current_date_str,tou_delas_wd_wt);
%             fprintf(delas_TOU_wot,'%s 00:00:00,%f\n',current_date_str,tou_delas_wd_wot);
%             fprintf(delas_CPP_wot,'%s 00:00:00,%f\n',current_date_str,tou_delas_wd_wot);
%             
%             fprintf(selas_TOU_wt,'%s 00:00:00,%f\n',current_date_str,tou_selas_wt);
%             fprintf(selas_CPP_wt,'%s 00:00:00,%f\n',current_date_str,tou_selas_wt);
%             fprintf(selas_TOU_wot,'%s 00:00:00,%f\n',current_date_str,tou_selas_wot);
%             fprintf(selas_CPP_wot,'%s 00:00:00,%f\n',current_date_str,tou_selas_wot);
%             
%             fprintf(firsttier_TOU_hours,'%s 00:00:00,%f\n',current_date_str,first_tier_hours);
%             fprintf(secondtier_TOU_hours,'%s 00:00:00,%f\n',current_date_str,second_tier_hours);
%             fprintf(firsttier_CPP_hours,'%s 00:00:00,%f\n',current_date_str,first_tier_hours);
%             fprintf(secondtier_CPP_hours,'%s 00:00:00,%f\n',current_date_str,second_tier_hours);
            fprintf(CPP_days,'%s 00:00:00,%s\n',current_date_str,'0');
        end
    end
    
    fclose('all');
end