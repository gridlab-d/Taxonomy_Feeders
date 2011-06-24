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

% The input data is mannualy inserted because of the method of collection
Base2_r1=[1.30	1.17	1.18	1.17	1.16	1.17
106.05	90.32	97.20	92.49	104.12	90.74
81.75	77.22	82.52	78.84	89.76	77.88
0	2	1	3	0	1];

Base2_r2=[1.30	1.29	1.14	1.16	1.16	1.18
106.05	98.39	93.38	90.43	91.75	100.39
81.75	76.02	82.25	78.06	79.17	84.72
0	1	1	1	0	1];

Base2_r3=[1.30	1.21	1.17	1.19
106.05	95.53	101.37	97.68
81.75	79.06	86.96	82.42
0	2	1	0];
    
Base2_r4=[1.30	1.16	1.19	1.15
106.05	91.84	95.77	90.18
81.75	79.28	80.25	78.70
0	0	1	1];

Base2_r5=[1.30	1.17	1.18	1.19	1.18	1.17	1.17	1.19
106.05	90.88	91.81	93.70	95.44	102.06	94.82	93.88
81.75	77.73	77.77	78.87	80.63	87.50	80.98	79.20
0	0	1	1	1	1	1	1];
	
t3_r1=0;
t3_r2=0;
t3_r3=0;
t3_r4=0;
t3_r5=0;

t4_r1=0;
t4_r2=0;
t4_r3=0;
t4_r4=0;
t4_r5=0;

t5_r1=0;
t5_r2=0;
t5_r3=0;
t5_r4=0;
t5_r5=0;


%Base2_data=[Base2_r1 Base2_r2 Base2_r3 Base2_r4 Base2_r5];

% Reorganize so that the GC feeders are the first five.
Base2_data(:,1)=Base2_r1(:,1);
Base2_data(:,2)=Base2_r1(:,1);
Base2_data(:,3)=Base2_r1(:,1);
Base2_data(:,4)=Base2_r1(:,1);
Base2_data(:,5)=Base2_r1(:,1);
Base2_data(:,6:10)=Base2_r1(:,2:6);
Base2_data(:,11:15)=Base2_r2(:,2:6);
Base2_data(:,16:18)=Base2_r3(:,2:4);
Base2_data(:,19:21)=Base2_r4(:,2:4);
Base2_data(:,22:28)=Base2_r5(:,2:8);


SAIFI_t3(1,:)=Base2_data(1,:);
SAIFI_t3(2,:)=Base2_data(1,:)*.65;
SAIDI_t3(1,:)=Base2_data(2,:);
SAIDI_t3(2,:)=Base2_data(2,:)*.65;
CAIDI_t3(1,:)=Base2_data(3,:);
CAIDI_t3(2,:)=Base2_data(3,:)*.65;
MAIFI_t3(1,:)=Base2_data(4,:);
MAIFI_t3(2,:)=Base2_data(4,:)*.65;

% Bring in the feeder names from the annual losses files
load([write_dir,'annual_losses_t0.mat']);
data_t0 = annual_losses;
[no_feeders cells] = size(data_t0);
clear anual_losses;
data_labels = strrep(data_t0(:,1),'_t0','');
data_labels = strrep(data_labels,'_','-');




% t3 SAIFI
fname = 't3_SAIFI';
set_figure_size(fname);
hold on;
bar(SAIFI_t3','barwidth',0.9);
ylabel('                  Interrputions per year');
ylim([.5 1.5]);
my_legend = {'Base';'R&S'};
set_figure_graphics(data_labels,fname,2,my_legend,.35,'northeastoutside');
hold off;
close(fname);

% t3 SAIDI
fname = 't3_SAIDI';
set_figure_size(fname);
hold on;
bar(SAIDI_t3','barwidth',0.9);
ylabel('Minutes');
ylim([40 120]);
set_figure_graphics(data_labels,fname,2,my_legend,.35,'northeastoutside');
hold off;
close(fname);

% t3 CAIDI
fname = 't3_CAIDI';
set_figure_size(fname);
hold on;
bar(CAIDI_t3','barwidth',0.9);
ylabel('Minutes');
ylim([40 100]);
set_figure_graphics(data_labels,fname,2,my_legend,.5,'northeastoutside');
hold off;
close(fname);

% t3 MAIFI
fname = 't3_MAIFI';
set_figure_size(fname);
hold on;
bar(MAIFI_t3','barwidth',0.9);
ylabel('Momentary Interruptions');
ylim([0 5]);
set_figure_graphics(data_labels,fname,2,my_legend,.5,'northeastoutside');
hold off;
close(fname);

clear;