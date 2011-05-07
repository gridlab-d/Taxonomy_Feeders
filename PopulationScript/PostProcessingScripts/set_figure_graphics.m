function [] = set_figure_graphics(xlabels,my_name,yformat,my_leg)
    % This file formats the graphics to match in all files
    % xlabels - an array of labels for the x-axis
    % my_name - name of the graphics file
    % yformat - lets you set format of text on y-axis; set to zero and it
    %           won't effect it; be careful with exponentials 
    % my_leg - lets you add a legend; set to 'none' to provide no legend
    ca = gca;
    cf = gcf;
    
    % turns on the y-grid lines
    set(ca,'XGrid','off','YGrid','on','ZGrid','off');
    
    % this manually moves the y-axis labels over a little so when saving to
    % a jpg, the text doesn't overlap the axis
    ylab = get(ca,'Ylabel');
    ylab_pos_orig = get(ylab,'position');
    if (ylab_pos_orig(1) > 0) %not sure why this works...may need some work here
        ylab_pos_left = ylab_pos_orig(1)/2;
    else
        ylab_pos_left = ylab_pos_orig(1)*2;
    end
    ylab_pos = [ylab_pos_left ylab_pos_orig(2) ylab_pos_orig(3)];
    set(ylab,'position',ylab_pos);
    
    % This puts a border around the figure
    %  Note, this doesn't support sub-titles well
    axes('Position',[.005 .005 .99 .99],'xtick',[],'ytick',[],'box','on','handlevisibility','off','Color','none');   
    
    % This rotates the x-axis labels and positions them correctly
    xticklabel_rotate(1:length(xlabels),90,xlabels);
    
    % This puts the "correct" no. of significant digits on the y-axis
    if (yformat ~= 0)
        ticky = get(ca,'YTick');
        set(ca,'YTickLabel',{}); %clears the old ones   
        ticklabely = num2str(ticky',[yformat '\n']);
        set(ca,'YTickLabel',ticklabely);
    end
    
    if (~strcmp(char(my_leg(1,:)),'none'))
        legend(ca,my_leg);
    end
    
    % Resize the print-out image to only take up half a page minus a little
    set(cf,'PaperUnits','inches');
    set(cf,'PaperSize',[8 11]);
    set(cf,'PaperPosition',[1 1 8 4.75]);
    
    print('-dpng',my_name);
end