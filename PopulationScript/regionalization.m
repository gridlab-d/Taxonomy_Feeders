function [data] = regionalization(region)
%% Regional data that will be imported by the taxonomy script
% Regions:
% 1 - West Coast - temperate
% 2 - North Central/Northeast - cold/cold
% 3 - Southwest - hot/arid
% 4 - Southeast/Central - hot/cold
% 5 - Southeast coastal - hot/humid

%% Weather data
% {region}
weather{1} = 'CA-San_francisco';
weather{2} = 'IL-Chicago';
weather{3} = 'AZ-Phoenix';
weather{4} = 'TN-Nashville';
weather{5} = 'FL-Miami';

%% Timezone data
timezone{1} = 'PST+8PDT';
timezone{2} = 'CST+6CDT';
timezone{3} = 'MST'; % Do we want to be this accurate?
timezone{4} = 'CST+6CDT';
timezone{5} = 'EST+5EDT';

%% Regional building data
% thermal_percentage integrity percentages
%   {region}(level,sf/apart/mh)
%   single family homes
%   apartments
%   mobile homes
%   level corresponds to age of home from "Building Reccs"
%       1:pre-1940, 2:1940-1949, 3:1950-1959, 4:1960-1969, 5:1970-1979, 6:1980-1989, 7:1990-2005
%       1:pre-1960, 2:1960-1989, 3:1990-2005
%       1:pre-1960, 2:1960-1989, 3:1990-2005
thermal_percentage{1} = [   0.0805,0.0724,0.1090,0.0867,0.1384,0.1264,0.1297;
                            0.0356,0.1223,0.0256,0.0000,0.0000,0.0000,0.0000;
                            0.0000,0.0554,0.0181,0.0000,0.0000,0.0000,0.0000];
thermal_percentage{2} = [   0.1574,0.0702,0.1290,0.0971,0.0941,0.0744,0.1532;
                            0.0481,0.0887,0.0303,0.0000,0.0000,0.0000,0.0000;
                            0.0000,0.0372,0.0202,0.0000,0.0000,0.0000,0.0000];
thermal_percentage{3} = [   0.0448,0.0252,0.0883,0.0843,0.1185,0.1315,0.2411;
                            0.0198,0.1159,0.0478,0.0000,0.0000,0.0000,0.0000;
                            0.0000,0.0524,0.0302,0.0000,0.0000,0.0000,0.0000];
thermal_percentage{4} = [   0.0526,0.0337,0.0806,0.0827,0.1081,0.1249,0.2539;
                            0.0217,0.1091,0.0502,0.0000,0.0000,0.0000,0.0000;
                            0.0000,0.0491,0.0333,0.0000,0.0000,0.0000,0.0000];
thermal_percentage{5} = [   0.0614,0.0393,0.0942,0.0966,0.1263,0.1459,0.2965;
                            0.0149,0.0653,0.0289,0.0000,0.0000,0.0000,0.0000;
                            0.0000,0.0198,0.0110,0.0000,0.0000,0.0000,0.0000];
                        
for jjj=1:5
    check_total = sum(sum(thermal_percentage{jjj}));
    if ( abs(check_total - 1) > 0.001 )
        error(['Error in total thermal percentage{',num2str(jjj),'} - Sum does not equal 100%.']);
    end
end

% thermal properties for each level
%   {sf/apart/mh,level}(R-ceil,R-wall,R-floor,window layers,window glass, glazing treatment, window frame, R-door, Air infiltration, COP high, COP low)
%   Single family homes
thermal_properties{1,1} =  [11.0,  4.0,  4.0, 1, 1, 1, 1,   3, 1.5, 2.8, 1.9];
thermal_properties{1,2} =  [19.0, 11.0,  4.0, 2, 1, 1, 1,   3, 1.5, 3.0, 2.0];
thermal_properties{1,3} =  [19.0, 11.0, 11.0, 2, 1, 1, 1,   3, 1.0, 3.2, 2.1];
thermal_properties{1,4} =  [30.0, 11.0, 19.0, 2, 1, 1, 2,   3, 1.0, 3.4, 2.2];
thermal_properties{1,5} =  [30.0, 19.0, 20.0, 2, 1, 1, 2,   3, 1.0, 3.6, 2.3];
thermal_properties{1,6} =  [30.0, 19.0, 22.0, 2, 2, 1, 2,   5, 0.5, 3.8, 2.4];
thermal_properties{1,7} =  [48.0, 22.0, 30.0, 3, 2, 2, 4,  11, 0.5, 4.0, 2.5];
%   Apartments
thermal_properties{2,1} =  [13.4, 11.7,  9.4, 1, 1, 1, 1, 2.2, 1.5, 2.8, 1.9];
thermal_properties{2,2} =  [20.3, 11.7, 12.7, 2, 1, 2, 2, 2.7, 0.5, 3.0, 2.0];
thermal_properties{2,3} =  [28.7, 14.3, 12.7, 2, 2, 3, 4, 6.3, .25, 3.2, 2.1];
%   Mobile Homes
thermal_properties{3,1} =  [   0,    0,    0, 0, 0, 0, 0,   0,   0,   0,   0];
thermal_properties{3,2} =  [13.4,  9.2, 11.7, 1, 1, 1, 1, 2.2, 1.5, 2.8, 1.9];
thermal_properties{3,3} =  [24.1, 11.7, 18.1, 2, 2, 1, 2,   3, 1.5, 3.5, 2.2];

%   Average floor areas for each type and region
floor_area{1} = [2209,820,1054];
floor_area{2} = [2951,798,1035];
floor_area{3} = [2655,901,1069];
floor_area{4} = [2655,901,1069];
floor_area{5} = [2370,764,1093];

% Breakdown of gas vs. heat pump vs. resistance
% TODO
perc_gas = [0.3,0.3,0.3,0.3,0.3];
perc_pump = [0.7,0.7,0.7,0.7,0.7];
perc_res = 1 - perc_pump - perc_gas;

% of AC - all heat pumps have AC, this perc. applies to those with gas/elec
% TODO
perc_AC = [0.8,0.8,0.8,0.8,0.8];

% Average cooling and heating setpoints
% TODO

            
% pool pumps
% TODO
perc_poolpumps = [0,0,0,0,0];


data.thermal_properties = thermal_properties;
data.thermal_percentages = thermal_percentage{region};
data.weather = weather{region};
data.timezone = timezone{region};
data.perc_gas = perc_gas(region);
data.perc_pump = perc_pump(region);
data.perc_res = perc_res(region);
data.perc_AC = perc_AC(region);
data.perc_poolpumps = perc_poolpumps(region);
data.floor_area = floor_area{region};
end









