function [] = set_figure_graphics_time_series(my_name,yformat,my_leg,offset,leg_loc,leg_orientation)
    % This file formats the graphics to match in all files for the SGIG
    % analysis - time series plots
    %
    % set_figure_graphics_time_series(my_name,yformat,my_leg,offset,leg_loc,pos_mod)
    %
    % my_name - name of the graphics file
    % yformat - 1-removes exponens, 2 set 2 decimal places, 3 sets 1
    %           decimal place
    % my_leg - lets you add a legend; set to 'none' to provide no legend
    % offset - moves the yaxis label to the left when the numbering on the
    %          yaxis is too large.
    % leg_loc - Location of the legend.
	% leg_orientation - legend orientation ('horizontal' or 'vertical' - defaults to vertical)
    %
    % started 5/1/2011 by J. Fuller
	% Modified 7/5/2011 by F. Tuffner from set_figure_graphics.m

    
    %Set a default for leg_orientation, if not used
    if (nargin==5)
        leg_orientation = [];
    end
    
    ca = gca;
    cf = gcf;
    
    % turns on the y-grid lines
    set(ca,'XGrid','off','YGrid','on','ZGrid','off');
    
    % this manually moves the y-axis labels over a little so when saving to
    % a jpg, the text doesn't overlap the axis
    ylab = get(ca,'Ylabel');
    ylab_pos_orig = get(ylab,'position');
    
    ylab_pos = [ylab_pos_orig(1)-offset ylab_pos_orig(2) ylab_pos_orig(3)]; %Just move the left position
    set(ylab,'position',ylab_pos); % Move the label when the format changes
    
    % This puts a border around the figure
    %  Note, this doesn't support sub-titles well
    axes('Position',[.005 .005 .99 .99],'xtick',[],'ytick',[],'box','on','handlevisibility','off','Color','none');   
    
    % This puts the "correct" no. of significant digits on the y-axis
    if (yformat == 1) % Removes the exponential foramting
        set(gca,'YTickLabel',num2str(get(gca,'YTick').','%2.0f'));
    elseif (yformat == 2)
        set(gca,'YTickLabel',num2str(get(gca,'YTick').','%2.2f'));
    elseif (yformat == 3)
        set(gca,'YTickLabel',num2str(get(gca,'YTick').','%0.1f'));
    end
    
    if (~strcmp(char(my_leg(1,:)),'none'))
        if (isempty(leg_orientation))
            legend(ca,my_leg,'location',leg_loc,'FontSize',10);
        else
            legend(ca,my_leg,'location',leg_loc,'orientation',leg_orientation,'FontSize',10);
        end
    end
    
    % Resize the print-out image to only take up half a page minus a little
    set(cf,'PaperUnits','inches');
    set(cf,'PaperSize',[8 11]);
    set(cf,'PaperPosition',[1 1 8 4.75]);
    
    print('-dpng',my_name);
end