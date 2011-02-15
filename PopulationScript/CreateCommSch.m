clear;
clc;

write_file = fopen('commercial_schedules.glm','w');

%big box weekday
list{1,1}         = [ 60	80	0.3886291	0.271477476	0.053492274	0.152904	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.152689654	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.135189183	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.129425937	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.129182691	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.120395487	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.094208241	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.096301361	0	0	0;
                    70	75	1.14431455	0.514095094	0.20419859	0.103125016	0	0	0.117198945;
                    70	75	1.9         0.756712711	0.354904907	0.112386911	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.118353665	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.118938419	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.118726482	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.118463969	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.117392723	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.116323885	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.123965906	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.152022293	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.159647455	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.177324942	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.19365133	0	0	0.23439789;
                    70	75	1.14431455	0.514095094	0.20419859	0.205828084	0	0	0.117198945;
                    60	80	0.3886291	0.271477476	0.053492274	0.19317688	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.166999267	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.152904	0	0	0];
%big box weekend                
list{1,2}         = [ 60	80	0.349692285	0.187260835	0.044288222	0.150813	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.147509741	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.133670662	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.127676403	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.126938874	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.11708239	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.084758537	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.066827827	0	0	0;
                    70	75	0.851807975	0.344166965	0.132073408	0.058960649	0	0	0.074853568;
                    70	75	1.353923665	0.501073095	0.219858594	0.06548049	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.072702636	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.073959927	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.073929298	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.073313364	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.073282736	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.074537576	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.106211497	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.128531238	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.14897316	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.161468576	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.182613723	0	0	0.149707137;
                    70	75	0.851807975	0.344166965	0.132073408	0.197675788	0	0	0.074853568;
                    60	80	0.349692285	0.187260835	0.044288222	0.187810728	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.16333445	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.150813	0	0	0];

%strip weekday
list{2,1}         = [ 60	80	0.3886291	0.271477476	0.053492274	0.152904	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.152689654	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.135189183	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.129425937	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.129182691	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.120395487	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.094208241	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.096301361	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.103125016	0	0	0;
                    70	75	1.14431455	0.514095094	0.20419859	0.112386911	0	0	0.117198945;
                    70	75	1.9     	0.756712711	0.354904907	0.118353665	0	0	0.23439789;
                    70	75	1.9     	0.756712711	0.354904907	0.118938419	0	0	0.23439789;
                    70	75	1.9     	0.756712711	0.354904907	0.118726482	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.118463969	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.117392723	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.116323885	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.123965906	0	0	0.23439789;
                    70	75	1.9         0.756712711	0.354904907	0.152022293	0	0	0.23439789;
                    70	75	1.14431455	0.514095094	0.20419859	0.159647455	0	0	0.117198945;
                    60	80	0.3886291	0.271477476	0.053492274	0.177324942	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.19365133	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.205828084	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.19317688	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.166999267	0	0	0;
                    60	80	0.3886291	0.271477476	0.053492274	0.152904	0	0	0];

%strip weekend
list{2,2} =        [  60	80	0.349692285	0.187260835	0.044288222	0.150813	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.147509741	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.133670662	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.127676403	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.126938874	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.11708239	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.084758537	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.066827827	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.058960649	0	0	0;
                    70	75	0.851807975	0.344166965	0.132073408	0.06548049	0	0	0.074853568;
                    70	75	1.353923665	0.501073095	0.219858594	0.072702636	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.073959927	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.073929298	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.073313364	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.073282736	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.074537576	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.106211497	0	0	0.149707137;
                    70	75	1.353923665	0.501073095	0.219858594	0.128531238	0	0	0.149707137;
                    70	75	0.851807975	0.344166965	0.132073408	0.14897316	0	0	0.074853568;
                    60	80	0.349692285	0.187260835	0.044288222	0.161468576	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.182613723	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.197675788	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.187810728	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.16333445	0	0	0;
                    60	80	0.349692285	0.187260835	0.044288222	0.150813	0	0	0];
%office weekday                
list{3,1} = [  60	80	0.348112379	0.686563303	0.043985115	0.294704	0	0	0;
                    60	80	0.348112379	0.686563303	0.043985115	0.272741123	0	0	0;
                    60	80	0.348112379	0.686563303	0.043985115	0.269718226	0	0	0;
                    60	80	0.348112379	0.686563303	0.043985115	0.268332355	0	0	0;
                    60	80	0.348112379	0.686563303	0.043985115	0.273051235	0	0	0;
                    60	80	0.348112379	0.686563303	0.043985115	0.265089353	0	0	0;
                    60	80	0.348112379	0.686563303	0.043985115	0.222538466	0	0	0;
                    60	80	0.348112379	0.686563303	0.043985115	0.18272159	0	0	0;
                    70	75	0.82405619	1.072914079	0.076012323	0.141559718	0	0	0.164811017;
                    70	75	1.3         1.459264854	0.108039531	0.124535826	0	0	0.329622033;
                    70	75	1.3         1.459264854	0.108039531	0.120415944	0	0	0.329622033;
                    70	75	1.3         1.459264854	0.108039531	0.119008063	0	0	0.329622033;
                    70	75	1.3         1.459264854	0.108039531	0.121218932	0	0	0.329622033;
                    70	75	1.3         1.459264854	0.108039531	0.119596056	0	0	0.329622033;
                    70	75	1.3         1.459264854	0.108039531	0.124505169	0	0	0.329622033;
                    70	75	1.3         1.459264854	0.108039531	0.137109287	0	0	0.329622033;
                    70	75	1.3         1.459264854	0.108039531	0.194213395	0	0	0.329622033;
                    70	75	1.3         1.459264854	0.108039531	0.251609534	0	0	0.329622033;
                    70	75	1.062028095	1.266089467	0.092025927	0.288428668	0	0	0.247216525;
                    70	75	0.82405619	1.072914079	0.076012323	0.31498976	0	0	0.164811017;
                    70	75	0.586084284	0.879738691	0.059998719	0.326273645	0	0	0.082405508;
                    60	80	0.348112379	0.686563303	0.043985115	0.364426769	0	0	0;
                    60	80	0.348112379	0.686563303	0.043985115	0.344905871	0	0	0;
                    60	80	0.348112379	0.686563303	0.043985115	0.33314601	0	0	0;
                    60	80	0.348112379	0.686563303	0.043985115	0.294704	0	0	0];
%office weekend
list{3,2} = [  60	80	0.325187034	0.471623684	0.041838255	0.312494	0	0	0;
                    60	80	0.325187034	0.471623684	0.041838255	0.287409632	0	0	0;
                    60	80	0.325187034	0.471623684	0.041838255	0.273601568	0	0	0;
                    60	80	0.325187034	0.471623684	0.041838255	0.2697332	0	0	0;
                    60	80	0.325187034	0.471623684	0.041838255	0.275827863	0	0	0;
                    60	80	0.325187034	0.471623684	0.041838255	0.267101738	0	0	0;
                    60	80	0.325187034	0.471623684	0.041838255	0.222128431	0	0	0;
                    60	80	0.325187034	0.471623684	0.041838255	0.180707033	0	0	0;
                    70	75	0.399891635	0.73647065	0.046669908	0.137063969	0	0	0.021899574;
                    70	75	0.474596236	1.001317616	0.051501561	0.117058358	0	0	0.043799147;
                    70	75	0.474596236	1.001317616	0.051501561	0.114521294	0	0	0.043799147;
                    70	75	0.474596236	1.001317616	0.051501561	0.113092411	0	0	0.043799147;
                    70	75	0.474596236	1.001317616	0.051501561	0.112982104	0	0	0.043799147;
                    70	75	0.474596236	1.001317616	0.051501561	0.112883464	0	0	0.043799147;
                    70	75	0.474596236	1.001317616	0.051501561	0.112777399	0	0	0.043799147;
                    70	75	0.474596236	1.001317616	0.051501561	0.121280789	0	0	0.043799147;
                    70	75	0.474596236	1.001317616	0.051501561	0.166037724	0	0	0.043799147;
                    70	75	0.474596236	1.001317616	0.051501561	0.215885084	0	0	0.043799147;
                    70	75	0.437243935	0.868894133	0.049085734	0.254449777	0	0	0.03284936;
                    70	75	0.399891635	0.73647065	0.046669908	0.286600167	0	0	0.021899574;
                    70	75	0.362539335	0.604047167	0.044254081	0.318985345	0	0	0.010949787;
                    60	80	0.325187034	0.471623684	0.041838255	0.35867519	0	0	0;
                    60	80	0.325187034	0.471623684	0.041838255	0.344867125	0	0	0;
                    60	80	0.325187034	0.471623684	0.041838255	0.329948757	0	0	0;
                    60	80	0.325187034	0.471623684	0.041838255	0.312494	0	0	0];

schedule_list = {'heating','cooling','light','plugs','gas','exterior','','','occupancy'};
type_list = {'bigbox','stripmall','office'};
 day = {'0-6','7';
        '1-6','0';
        '1-5','0,6'};
        
% loop through all the types (retail vs. office)
for jindex=1:3
    type = type_list{jindex};
    
    
    
    % loop through each of the schedules
    for iindex=1:9
        if (iindex == 7 || iindex == 8)
            continue;
        end
        schedule_name = [type,'_',schedule_list{iindex}];
        
        % loop through weekend vs. weekday
        for mindex=1:2
            
            this_list = list{jindex,mindex};
            schedule = this_list(:,iindex);
            
            if mindex==1
                fprintf(write_file,'schedule %s {\n',schedule_name);
                fprintf(write_file,'     // Weekday {\n');
            else
                fprintf(write_file,'\n     // Weekend {\n');
            end
            % loop through hours
            for kindex=1:24
                value = schedule(kindex);
                fprintf(write_file,'     * %.0f * * %s %.4f;\n',kindex-1,day{jindex,mindex},value);
            end %end hours
            
            if mindex==2
                fprintf(write_file,'};\n\n');
            end
            
        end%end weekday/weekend
    end%end schedules
end%end type

fclose('all');






