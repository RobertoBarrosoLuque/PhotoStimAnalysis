%Code for comparing day performance for individual animals uses the
%DayComp, GetSession functions
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\');
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\Downloaded Function');
file_name = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Charlotte\Behavior_Data_current\';


animal = 18;

[ dirL ] = get_directory_names(strcat(file_name,'\',int2str(animal)));

overall = zeros(size(dirL,1),5);
conv_perf = zeros(1,60);

endd =  size(dirL,1);
B_coeff_rw = zeros(8,1);B_coeff_ch = zeros(8,1);
se_rw = zeros(8,1);se_ch = zeros(8,1);

count = 0;count_Bch = 0;
for i = 1:endd-1
    close all
    dirL{i}
    count = count+1;
    %get Session structure, and TrialInf matrix for current day
    [Session,TrialInf,sessionData] = GetSession(animal,dirL{i});
    
    [DayInfo] = DayComp(TrialInf, Session);
    
    overall(i,4) = DayInfo.avg_time_trial;
    
    if Session.switches ~= 0
        [IMG,rand,avg_percent,raw_average,conv_average]=SwitchPerf(20,40, sessionData);
        conv_perf(1,:) = conv_perf + conv_average;
        overall(i,1) = DayInfo.switchPerf;
        overall(i,2) = DayInfo.avg_trials_switch;
        overall(i,3) = DayInfo.avg_percor_block;
        overall(i,5) = length(Session.switches); % column 5 has total number of switches
    else %no switches that session
        overall(i,1) = NaN; % DayInfo.switchPerf;
        overall(i,2) = NaN; % DayInfo.avg_trials_switch;
        overall(i,3) = sum(TrialInf(:,5))/TrialInf(end,1);%DayInfo.avg_percor_block;
        overall(i,5) = 0; % length(Session.switches);
    end
    
    
    overall(i,5) = length(Session.switches);   % column 5 has total number of switches
    
    %ch is regression using choice data rw is regression using reward data
    [h_ch,B_ch,dev_ch,stats_ch,h_rw,B_rw,dev_rw,stats_rw] = MLogReg(TrialInf);
    
    %check if B_ch is an empty vector
    if size(B_ch,2) ~= 0
    count_Bch = count_Bch + 1; 
    B_coeff_ch = B_coeff_ch + B_ch(2:9);
    se_ch = se_ch+stats_ch.se(2:9);
    end 
    
    
%     B_coeff_rw = B_coeff_rw + B_rw(2:9);
%     se_rw = se_rw+stats_rw.se(2:9);
    
    %     subplot(2,1,1)
    %     errorbar(B_ch(2:9),stats_ch.se(1:8),'ro');xlim([0 8]); xlabel('Pased choices')
    %
    %     subplot(2,1,2)
    %     errorbar(B_rw(2:9),stats_rw.se(1:8),'ko');xlim([0 8]); xlabel('Reward History')
    %
    %     pause()
end


B_coeff_ch = B_coeff_ch/count_Bch;
se_ch = se_ch/count_Bch;
figure;
errorbar(B_coeff_ch,se_ch,'ro');xlim([0 9])
xlabel('Trials from current'); ylabel('Decision history weights')
title(strcat('Average Through All Sessions (Mouse: ', int2str(animal),')'))

figure
plot(-20:39,conv_perf/count,'k');
line([0 0],[0 1]); hold off

figure
scatter(1:count,overall(1:count,3),'Filled')
lsline
title('Average Percent Correct Block Per Day')

figure
%switch performance is a measure calculated by:
% (# of switches in session/max possible #of switches) 
%thus measure is always between [0 1]
bar(1:count+1,overall(:,1),'k');
title('Switch Performance Across Days')





