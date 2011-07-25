% This script is intended to compare results for 3 studies
% 1) t3:Recloser and Sectionalizer 
% 2) t4:DMS & OMS
% 3) t5:FDIR

% create 6/22/2011 by Kevin Schneider

clear all;
clc;
format short g
% Set the default text sizing
set_defaults();

% where to write the new data
write_dir = 'C:\Users\d3p313\Desktop\Post Processing Script\MAT Files\Consolodated MAT Files\'; %Kevin

%% Read in the reliability numbers from the SGIG Metrics.xlsx file
% Base Case 2 values
Base2_r1=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','Base 2','F4:K7');
Base2_r2=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','Base 2','P4:U7');
Base2_r3=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','Base 2','Z4:AC7');
Base2_r4=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','Base 2','AH4:AK7');
Base2_r5=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','Base 2','AP4:AW7');
	
% t3 values
t3_r1=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t3','F4:K7');
t3_r2=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t3','P4:U7');
t3_r3=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t3','Z4:AC7');
t3_r4=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t3','AH4:AK7');
t3_r5=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t3','AP4:AW7');

% t4 values
t4_r1=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t4','F4:K7');
t4_r2=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t4','P4:U7');
t4_r3=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t4','Z4:AC7');
t4_r4=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t4','AH4:AK7');
t4_r5=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t4','AP4:AW7');

% t5 values
t5_r1=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t5','F4:K7');
t5_r2=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t5','P4:U7');
t5_r3=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t5','Z4:AC7');
t5_r4=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t5','AH4:AK7');
t5_r5=xlsread('C:\PNNL Work\Current Projects\Grid Lab-D\2011\Analysis\DA Report\Excel Sheets for Report\SGIG Metrics.xlsx','For t5','AP4:AW7');


%Base2_data=[Base2_r1 Base2_r2 Base2_r3 Base2_r4 Base2_r5];

% Reorganize so that the GC feeders are the first five.
Base2_data(:,1)=Base2_r1(:,1);
Base2_data(:,2)=Base2_r2(:,1);
Base2_data(:,3)=Base2_r3(:,1);
Base2_data(:,4)=Base2_r4(:,1);
Base2_data(:,5)=Base2_r5(:,1);
Base2_data(:,6:10)=Base2_r1(:,2:6);
Base2_data(:,11:15)=Base2_r2(:,2:6);
Base2_data(:,16:18)=Base2_r3(:,2:4);
Base2_data(:,19:21)=Base2_r4(:,2:4);
Base2_data(:,22:28)=Base2_r5(:,2:8);

Data_t3(:,1)=t3_r1(:,1);
Data_t3(:,2)=t3_r2(:,1);
Data_t3(:,3)=t3_r3(:,1);
Data_t3(:,4)=t3_r4(:,1);
Data_t3(:,5)=t3_r5(:,1);
Data_t3(:,6:10)=t3_r1(:,2:6);
Data_t3(:,11:15)=t3_r2(:,2:6);
Data_t3(:,16:18)=t3_r3(:,2:4);
Data_t3(:,19:21)=t3_r4(:,2:4);
Data_t3(:,22:28)=t3_r5(:,2:8);

Data_t4(:,1)=t4_r1(:,1);
Data_t4(:,2)=t4_r2(:,1);
Data_t4(:,3)=t4_r3(:,1);
Data_t4(:,4)=t4_r4(:,1);
Data_t4(:,5)=t4_r5(:,1);
Data_t4(:,6:10)=t4_r1(:,2:6);
Data_t4(:,11:15)=t4_r2(:,2:6);
Data_t4(:,16:18)=t4_r3(:,2:4);
Data_t4(:,19:21)=t4_r4(:,2:4);
Data_t4(:,22:28)=t4_r5(:,2:8);

Data_t5(:,1)=t5_r1(:,1);
Data_t5(:,2)=t5_r2(:,1);
Data_t5(:,3)=t5_r3(:,1);
Data_t5(:,4)=t5_r4(:,1);
Data_t5(:,5)=t5_r5(:,1);
Data_t5(:,6:10)=t5_r1(:,2:6);
Data_t5(:,11:15)=t5_r2(:,2:6);
Data_t5(:,16:18)=t5_r3(:,2:4);
Data_t5(:,19:21)=t5_r4(:,2:4);
Data_t5(:,22:28)=t5_r5(:,2:8);

% Generate the specific index matrices
SAIFI_t3(1,:)=Base2_data(1,:);
SAIFI_t3(2,:)=Data_t3(1,:);
SAIDI_t3(1,:)=Base2_data(2,:);
SAIDI_t3(2,:)=Data_t3(2,:);
CAIDI_t3(1,:)=Base2_data(3,:);
CAIDI_t3(2,:)=Data_t3(3,:);
MAIFI_t3(1,:)=Base2_data(4,:);
MAIFI_t3(2,:)=Data_t3(4,:);

SAIFI_t4(1,:)=Base2_data(1,:);
SAIFI_t4(2,:)=Data_t4(1,:);
SAIDI_t4(1,:)=Base2_data(2,:);
SAIDI_t4(2,:)=Data_t4(2,:);
CAIDI_t4(1,:)=Base2_data(3,:);
CAIDI_t4(2,:)=Data_t4(3,:);
MAIFI_t4(1,:)=Base2_data(4,:);
MAIFI_t4(2,:)=Data_t4(4,:);

SAIFI_t5(1,:)=Base2_data(1,:);
SAIFI_t5(2,:)=Data_t5(1,:);
SAIDI_t5(1,:)=Base2_data(2,:);
SAIDI_t5(2,:)=Data_t5(2,:);
CAIDI_t5(1,:)=Base2_data(3,:);
CAIDI_t5(2,:)=Data_t5(3,:);
MAIFI_t5(1,:)=Base2_data(4,:);
MAIFI_t5(2,:)=Data_t5(4,:);

% Bring in the feeder names from the annual losses files
load([write_dir,'annual_losses_t0.mat']);
data_t0 = annual_losses;
[no_feeders cells] = size(data_t0);
clear anual_losses;
data_labels = strrep(data_t0(:,1),'_t0','');
data_labels = strrep(data_labels,'_','-');



%% t3 plots
% t3 SAIFI
fname = 't3_SAIFI';
set_figure_size(fname);
hold on;
bar(SAIFI_t3','barwidth',0.9);
ylabel('                                                                             Interrputions per year');
ylim([0 1.5]);
my_legend = {'Base';'R&S'};
set_figure_graphics(data_labels,fname,2,my_legend,1,'northoutside',1,0,'horizontal');
hold off;
close(fname);

% t3 delta SAIFI
fname = 't3_delta_SAIFI';
set_figure_size(fname);
hold on;
bar((SAIFI_t3(2,:)-SAIFI_t3(1,:))','barwidth',0.9);
ylabel('Interrputions per year');
ylim([-1 0]);
set_figure_graphics(data_labels,fname,2,'none',.02,'northoutside',1,0,'horizontal');
hold off;
close(fname);


% t3 SAIDI
fname = 't3_SAIDI';
set_figure_size(fname);
hold on;
bar(SAIDI_t3','barwidth',0.9);
ylabel('Minutes');
ylim([20 120]);
my_legend = {'Base';'R&S'};
set_figure_graphics(data_labels,fname,2,my_legend,0,'northoutside',1,0,'horizontal');
hold off;
close(fname);

% t3 SAIDI
fname = 't3_delta_SAIDI';
set_figure_size(fname);
hold on;
bar((SAIDI_t3(2,:)-SAIDI_t3(1,:))','barwidth',0.9);
ylabel('Minutes');
%ylim([-80 00]);
set_figure_graphics(data_labels,fname,2,'none',0.03,'northoutside',1,0,'horizontal');
hold off;
close(fname);


% t3 CAIDI
fname = 't3_CAIDI';
set_figure_size(fname);
hold on;
bar(CAIDI_t3','barwidth',0.9);
ylabel('Minutes');
ylim([40 140]);
my_legend = {'Base';'R&S'};
set_figure_graphics(data_labels,fname,2,my_legend,0,'northoutside',1,0,'horizontal');
hold off;
close(fname);

% t3 CAIDI
fname = 't3_delta_CAIDI';
set_figure_size(fname);
hold on;
bar((CAIDI_t3(2,:)-CAIDI_t3(1,:))','barwidth',0.9);
ylabel('Minutes');
ylim([-40 50]);
set_figure_graphics(data_labels,fname,2,'none',0,'northoutside',1,0,'horizontal');
hold off;
close(fname);



% t3 MAIFI
fname = 't3_MAIFI';
set_figure_size(fname);
hold on;
bar(MAIFI_t3','barwidth',0.9);
ylabel('Momentary Interruptions');
ylim([0 15]);
set_figure_graphics(data_labels,fname,2,my_legend,0,'northoutside',1,0,'horizontal');
hold off;
close(fname);

% t3 MAIFI
fname = 't3_delta_MAIFI';
set_figure_size(fname);
hold on;
bar((MAIFI_t3(2,:)-MAIFI_t3(1,:))','barwidth',0.9);
ylabel('Momentary Interruptions');
ylim([-5 15]);
set_figure_graphics(data_labels,fname,2,'none',0.01,'northoutside',1,0,'horizontal');
hold off;
close(fname);

%% t4 plots
% t4 SAIFI
fname = 't4_SAIFI';
set_figure_size(fname);
hold on;
bar(SAIFI_t4','barwidth',0.9);
ylabel('Interrputions per year');
ylim([1.1 1.4]);
my_legend = {'Base';'DMS&OMS'};
set_figure_graphics(data_labels,fname,2,my_legend,0,'northoutside',1,0,'horizontal');
hold off;
close(fname);

% t4 delta SAIFI
fname = 't4_delta_SAIFI';
set_figure_size(fname);
hold on;
bar((SAIFI_t4(2,:)-SAIFI_t4(1,:))','barwidth',0.9);
ylabel('Interrputions per year');
ylim([-10 10]);
set_figure_graphics(data_labels,fname,2,'none',0,'northoutside',1,0,'horizontal');
hold off;
close(fname);


% t4 SAIDI
fname = 't4_SAIDI';
set_figure_size(fname);
hold on;
bar(SAIDI_t4','barwidth',0.9);
ylabel('Minutes');
ylim([40 120]);
my_legend = {'Base';'DMS&OMS'};
set_figure_graphics(data_labels,fname,2,my_legend,0,'northoutside',1,0,'horizontal');
hold off;
close(fname);

% t4 SAIDI
fname = 't4_delta_SAIDI';
set_figure_size(fname);
hold on;
bar((SAIDI_t4(2,:)-SAIDI_t4(1,:))','barwidth',0.9);
ylabel('Minutes');
ylim([-25 5]);
set_figure_graphics(data_labels,fname,2,'none',0.01,'northoutside',1,0,'horizontal');
hold off;
close(fname);


% t4 CAIDI
fname = 't4_CAIDI';
set_figure_size(fname);
hold on;
bar(CAIDI_t4','barwidth',0.9);
ylabel('Minutes');
ylim([40 100]);
my_legend = {'Base';'DMS&OMS'};
set_figure_graphics(data_labels,fname,2,my_legend,0,'northoutside',1,0,'horizontal');
hold off;
close(fname);

% t4 CAIDI
fname = 't4_delta_CAIDI';
set_figure_size(fname);
hold on;
bar((CAIDI_t4(2,:)-CAIDI_t4(1,:))','barwidth',0.9);
ylabel('Minutes');
ylim([-25 5]);
set_figure_graphics(data_labels,fname,2,'none',0.01,'northoutside',1,0,'horizontal');
hold off;
close(fname);


% t4 MAIFI
fname = 't4_MAIFI';
set_figure_size(fname);
hold on;
bar(MAIFI_t4','barwidth',0.9);
ylabel('Momentary Interruptions');
ylim([0 5]);
my_legend = {'Base';'DMS&OMS'};
set_figure_graphics(data_labels,fname,2,my_legend,.5,'northoutside',1,0,'horizontal');
hold off;
close(fname);

% t4 MAIFI
fname = 't4_delta_MAIFI';
set_figure_size(fname);
hold on;
bar((MAIFI_t4(2,:)-MAIFI_t4(1,:))','barwidth',0.9);
ylabel('Momentary Interruptions');
ylim([-5 5]);
set_figure_graphics(data_labels,fname,2,'none',.5,'northoutside',1,0,'horizontal');
hold off;
close(fname);


%% t5 plots
% t5 SAIFI
fname = 't5_SAIFI';
set_figure_size(fname);
hold on;
bar(SAIFI_t5','barwidth',0.9);
ylabel('Interrputions per year');
ylim([0 1.5]);
my_legend = {'Base';'FDIR'};
set_figure_graphics(data_labels,fname,2,my_legend,0,'northoutside',1,0,'horizontal');
hold off;
close(fname);

% t5 delta SAIFI
fname = 't5_delta_SAIFI';
set_figure_size(fname);
hold on;
bar((SAIFI_t5(2,:)-SAIFI_t5(1,:))','barwidth',0.9);
ylabel('Interrputions per year');
ylim([-1 0]);
set_figure_graphics(data_labels,fname,2,'none',.01,'northoutside',1,0,'horizontal');
hold off;
close(fname);


% t5 SAIDI
fname = 't5_SAIDI';
set_figure_size(fname);
hold on;
bar(SAIDI_t5','barwidth',0.9);
ylabel('Minutes');
ylim([10 120]);
my_legend = {'Base';'FDIR'};
set_figure_graphics(data_labels,fname,2,my_legend,0,'northoutside',1,0,'horizontal');
hold off;
close(fname);

% t5 SAIDI
fname = 't5_delta_SAIDI';
set_figure_size(fname);
hold on;
bar((SAIDI_t5(2,:)-SAIDI_t5(1,:))','barwidth',0.9);
ylabel('Minutes');
ylim([-80 0]);
set_figure_graphics(data_labels,fname,2,'none',.03,'northoutside',1,0,'horizontal');
hold off;
close(fname);


% t5 CAIDI
fname = 't5_CAIDI';
set_figure_size(fname);
hold on;
bar(CAIDI_t5','barwidth',0.9);
ylabel('Minutes');
ylim([20 100]);
my_legend = {'Base';'FDIR'};
set_figure_graphics(data_labels,fname,2,my_legend,0,'northoutside',1,0,'horizontal');
hold off;
close(fname);

% t5 CAIDI
fname = 't5_delta_CAIDI';
set_figure_size(fname);
hold on;
bar((CAIDI_t5(2,:)-CAIDI_t5(1,:))','barwidth',0.9);
ylabel('Minutes');
ylim([-60 20]);
set_figure_graphics(data_labels,fname,2,'none',0.01,'northoutside',1,0,'horizontal');
hold off;
close(fname);


% t5 MAIFI
fname = 't5_MAIFI';
set_figure_size(fname);
hold on;
bar(MAIFI_t5','barwidth',0.9);
ylabel('Momentary Interruptions');
ylim([0 15]);
my_legend = {'Base';'FDIR'};
set_figure_graphics(data_labels,fname,2,my_legend,0.02,'northoutside',1,0,'horizontal');
hold off;
close(fname);

% t5 MAIFI
fname = 't5_delta_MAIFI';
set_figure_size(fname);
hold on;
bar((MAIFI_t5(2,:)-MAIFI_t5(1,:))','barwidth',0.9);
ylabel('Momentary Interruptions');
ylim([-5 15]);
set_figure_graphics(data_labels,fname,2,'none',.02,'northoutside',1,0,'horizontal');
hold off;
close(fname);
%clear;