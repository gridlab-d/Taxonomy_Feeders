function [] = set_figure_size(my_name)

    %Original code - set size based on 20" wide screen monitor at 1680x1050
    %Locked to a static size so different monitor sizes/resolutions don't cause issues
    %%% scrsz = get(0,'ScreenSize');
    %%% figure('Name',my_name,'NumberTitle','off','Position',[100 scrsz(4)/15 scrsz(3)/1.2 scrsz(4)/2]);
	%%% figure('Name',my_name,'NumberTitle','off','Position',[100 70 1400 525]); %This resulted in odd figure sizing and was causing problems with percent figures
    figure('Name',my_name,'NumberTitle','off');
    
end