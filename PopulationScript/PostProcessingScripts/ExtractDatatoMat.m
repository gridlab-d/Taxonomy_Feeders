% This file will import results from a GridLAB-D DOE SGIG Analysis
% and manipulate the data into a single *.mat file per technology per
% feeder.  Subsequent *.m files will be used to post-process.
%
% Created Mar. 9, 2011 by Jason Fuller

%Prepare workspace
close all;
clear all;
clc;

% List feeders and technology numbers to import
% feeders_to_import = {'R1_1247_1';'R1_1247_2';'R1_1247_3';'R1_1247_4';'R1_2500_1';...
%     'R2_1247_1';'R2_1247_2';'R2_1247_3';'R2_2500_1';'R2_3500_1';...
%     'R3_1247_1';'R3_1247_2';'R3_1247_3';'R4_1247_1';'R4_1247_2';...
%     'R4_2500_1';'R5_1247_1';'R5_1247_2';'R5_1247_3';'R5_1247_4';...
%     'R5_1247_5';'R5_2500_1';'R5_3500_1';'GC_1247_1'};
%feeders_to_import = {'GC_1247_1'};
feeders_to_import = {'R5_1247_3'};

% e.g. _t#_ in the name of the feeder
technologies_to_import = {'1'};

% Set the base path for location of data
%base_path = 'C:\Users\d3x289\D1cuments\GLD2011\PostAnalysis\(7) TOU without et\Simulation Results\Run1'; % Jason
base_path = 'C:\Users\d3p313\Desktop\Post Processing Script\Raw Data Files\t1'; % Kevin

% Make a list of all of the files in the read folder
file_list = ls(base_path);

% Get number of feeders and technologies to import
[file_total,junk] = size(file_list);
[tech_total,junk] = size(technologies_to_import);
[feed_total,junk] = size(feeders_to_import);

% just initilizing some test variables
test1 = 0;
test2 = 0;

% loop through all of the techs
for tind=1:tech_total
    
    % loop through all of the feeders
    for find=1:feed_total
        % compare file names and collect data into an array if it
        % matches
        name_to_find = [feeders_to_import{find,1},'_t',technologies_to_import{tind,1}];
        
        if (strfind(name_to_find,'GC_') ~= 0)
            loop = 5;
        else
            loop = 1;
        end
        
        % Since there are 5 of those silly commercial feeders, handle them
        % slightly different by putting a loop on the outside of them
        for commind = 1:loop
                       
            if (loop > 1)
                name_to_find = [feeders_to_import{find,1},'_t',technologies_to_import{tind,1},'_r',num2str(commind)];
             end           
                        
            % catch timestamps and only put them into the mat file once,
            % but check all of the timestamps to make sure they match up
            timestamp_catch = 0;
            
            % same thing with billing info
            comm3_catch = 0;
            comm1_catch = 0;
            res_catch = 0;
            
            % loop through all of the files
            for file_ind=3:file_total   
                if (strfind(file_list(file_ind,:),name_to_find) ~= 0)
                    if (strfind(file_list(file_ind,:),'csv') ~= 0) % make sure we only pull csvs

                        % get the filename and open it up
                        get_entire_name = [base_path,'\',strtrim(file_list(file_ind,:))];
                        file_handle = fopen(get_entire_name,'r');

                        disp(['Reading ' strtrim(file_list(file_ind,:))]);

                        % grab the last portion of the filename for later use
                        % (indicator of the data type)
                        str_input = strtrim(file_list(file_ind,:));
                        str_comp = name_to_find;
                        file_type = strrep(str_input,str_comp,'');
                        file_type = strrep(file_type,'_','');
                        file_type = strrep(file_type,'.csv','');

                        % split the two types of files - time series and dumps
                        % dumps
                        if (strfind(file_list(file_ind,:),'bill') ~= 0)
                            % get the headers
                            headers = textscan(file_handle,'%s %s %s',1,'Delimiter',',','HeaderLines',1,'CollectOutput',0);

                            % bring in the data to a temporary variable
                            temp_data = textscan(file_handle,'%s %s %s','Delimiter',',','HeaderLines',0,'CollectOutput',0);

                            % put all of the data into a data structure using the
                            % file name
                            for colind=1:3
                                temp = strrep(headers{:,colind},'previous_','');
                                temp = strrep(temp,'\n','');
                                temp_var = [name_to_find,'.',file_type,'_',char(temp)];
                                
                                % divide up the billing files into 2 annual
                                % matrices - one for energy and one for $,
                                % and a file with customer names                               
                                if (colind == 1) %names
                                   if (strfind(file_type,'comm3') ~= 0) %3-phase commercial
                                       if (comm3_catch == 0) %first time through so save
                                           temp_var2 = [name_to_find,'.bills_comm3_names'];
                                           eval([temp_var2 '= temp_data{:,colind};']);
                                           test_comm3 = temp_data{:,colind};
                                           comm3_catch = 1;
                                       else
                                           test_comm3_2 = temp_data{:,colind};
                                           
                                           % loop through all of the bill
                                           % names and make sure they all
                                           % match each month
                                           for test_ind=1:length(test_comm3)
                                               if (strcmp(test_comm3{test_ind},test_comm3_2{test_ind}) == 0)
                                                   error('Customer bill names do not match (comm3)');
                                               end
                                           end
                                       end
                                       month_num = str2num(strrep(file_type,'billcomm3p',''));
                                   elseif (strfind(file_type,'commSP') ~= 0) %1-phase commercial
                                       if (comm1_catch == 0) %first time through so save
                                           temp_var2 = [name_to_find,'.bills_comm1_names'];
                                           eval([temp_var2 '= temp_data{:,colind};']);
                                           test_comm1 = temp_data{:,colind};
                                           comm1_catch = 1;
                                       else
                                           test_comm1_2 = temp_data{:,colind};
                                                                                     
                                           % loop through all of the bill
                                           % names and make sure they all
                                           % match each month
                                           for test_ind=1:length(test_comm1)
                                               if (strcmp(test_comm1{test_ind},test_comm1_2{test_ind}) == 0)
                                                   error('Customer bill names do not match (comm1)');
                                               end
                                           end
                                       end
                                       month_num = str2num(strrep(file_type,'billcommSP',''));
                                   elseif (strfind(file_type,'res') ~= 0) %residential
                                       if (res_catch == 0) %first time through so save
                                           temp_var2 = [name_to_find,'.bills_res_names'];
                                           eval([temp_var2 '= temp_data{:,colind};']);
                                           test_res = temp_data{:,colind};
                                           res_catch = 1;
                                       else
                                           test_res_2 = temp_data{:,colind};
                                           
                                           % loop through all of the bill
                                           % names and make sure they all
                                           % match each month
                                           for test_ind=1:length(test_res)
                                               if (strcmp(test_res{test_ind},test_res_2{test_ind}) == 0)
                                                   error('Customer bill names do not match (res)');
                                               end
                                           end
                                       end
                                       month_num = str2num(strrep(file_type,'billres',''));
                                   end
                                elseif (colind == 2) % bill, so save it in matrix
                                    temp_var3 = strrep(temp_var2,'names','bill');
                                    temp_d = str2num(char(temp_data{:,colind}));
                                    eval([temp_var3 '(:,month_num) = temp_d;']);
                                elseif (colind == 3) % energy, so save it in matrix
                                    temp_var4 = strrep(temp_var2,'names','energy');
                                    temp_d = str2num(char(temp_data{:,colind}));
                                    eval([temp_var4 '(:,month_num) = temp_d;']);
                                end
                                
                                % clean up some more workspace
                                clear temp_d;
                            end

                            % clean up my workspace
                            clear temp_data;

                        % time series data    
                        else
                            % scan the data to see how big the file is and grab the
                            % header portion of the output
                            temp_store = importdata(get_entire_name,',',9);

                            % get the headers - EOL slightly different cuz of ':'
                            if (strfind(file_list(file_ind,:),'EOL') ~= 0)
                                token = char(temp_store.textdata(9,:));
                                columns = 0;
                                while (strfind(token,',') ~= 0)
                                    columns = columns + 1;
                                    [my_header, token] = strtok(token,',');
                                    headers{:,columns} = my_header;
                                end

                                columns = columns - 1;
                            else
                                [junk,columns] = size(temp_store.textdata);
                                headers = temp_store.textdata(9,:);
                            end

                            % strip off some stuff that can't be used in variable
                            % names and basic cleanup
                            headers = strrep(headers,'#','');
                            headers = strrep(headers,'property..','');
                            headers = strrep(headers,'.','_');
                            headers = strrep(headers,':','_');
                            headers = strrep(headers,' ','');
                            headers = strrep(headers,'(','');
                            headers = strrep(headers,')','');
                            headers = strrep(headers,'-','');

                            % create the right textscan format depending on the size
                            % of the file being read
                            text_format = [];
                            for colind=1:columns
                                text_format = [text_format,'%s '];
                            end

                            % scan all the data into a temporary variable
                            temp_data = textscan(file_handle,text_format,'Delimiter',',','HeaderLines',9,'CollectOutput',0,'EndOfLine','\n');

                            % put all of the data into a data structure using the
                            % file name
                            for colind=1:columns
                                temp_var = [name_to_find,'.',file_type,'_',char(headers{:,colind})];
                                
                                if (strfind(temp_var,'timestamp') ~= 0)
                                    if (timestamp_catch == 0)
                                        % first time through, so save the
                                        % timestamp variable
                                        temp_var_ts = [name_to_find,'.',char(headers{:,colind})];
                                        eval([temp_var_ts '= temp_data{:,colind};']);
                                        eval(['ts_test = ' temp_var_ts ';']);
                                        timestamp_catch = 1;
                                    else
                                        ts_test_var = temp_data{:,colind};
                                        disp('Comparing timestamps');
                                        % compare the timestamps, if everything checks okay, then
                                        % throw it away, else throw an error
                                        if (strcmp(char(ts_test(1)),char(ts_test_var(1))) == 0)
                                            error('timestamps don''t match at beginning');
                                        end
                                        ll = length(ts_test);
                                        if (strcmp(char(ts_test(ll)),char(ts_test_var(ll))) == 0)
                                            error('timestamps don''t match at end');
                                        end
                                        rr = randi(ll);
                                        if (strcmp(char(ts_test(rr)),char(ts_test_var(rr))) == 0)
                                            error('timestamps don''t match somewhere in the middle of the timestamp vector');
                                        end
                                    end                                    
                                else                                   
                                    % Test the first few data points to see if
                                    % they are numbers rather than text, convert if they are
                                    % then store it into the feeder structure
                                    [test1,test2] = str2num(char(temp_data{:,colind}{1:3}));
                                    if (test2 ~= 0)
                                        test1 = str2num(char(temp_data{:,colind}));
                                        eval([temp_var '= test1;']);
                                    else
                                        eval([temp_var '= temp_data{:,colind};']);
                                    end
                                end 
                            end

                            % clean up the workspace a little
                            clear temp_data headers temp_store;
                        end
                        
                        % we're going to be opening up a lot of files, so
                        % let's try to keep track of them
                        fclose(file_handle);
                    end

                    disp(['Finished ' strtrim(file_list(file_ind,:))]);

                end % end if find file statement   
            end % end file index

            % clean up some more workspace
            clear ts_test ts_test_var test1;
            
            % if the feeder was found, let's save it to the *.mat file and
            % close it on out
            eval(['if (exist(''' name_to_find ''',''var''' ') ~= 0)' ' my_test = 1;' ' else my_test = 0; end']);
            if (my_test == 1)
                save_name = name_to_find;
                disp(['Saving file ' save_name]);
                eval(['save(''' save_name '.mat''' ',''' save_name ''')']);
                disp(['Saved file ' save_name]);
            end

            % clean up some more workspace
            eval(['clear ' name_to_find ';']);
        
        end % end the commmercial feeder for loop       
    end % end feeder index
end % end technology index

% clean up everything I'm sure I forgot
fclose('all');
%clear;