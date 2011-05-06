function [] = set_figure_size(my_name)

    scrsz = get(0,'ScreenSize');
    figure('Name',my_name,'NumberTitle','off','Position',[100 scrsz(4)/15 scrsz(3)/1.2 scrsz(4)/2]);
    
end