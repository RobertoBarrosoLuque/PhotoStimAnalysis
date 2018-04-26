function [DayInfo] = DayComp(TrialInf, Session)%DayComp(date,animal,TrialInf, Session);

%Measure for session performance (actual # switches)/(max amount pos switches)
%switchperf will alwas be between 0 and 1
modd = mod(Session.total_trials,75);
total_pos = (Session.total_trials-modd)/75;
DayInfo.switchPerf = length(Session.switches)/total_pos;

switch_int = zeros(1,length(Session.switches));
for i = 1:length(Session.switches)
    if i ==1
        switch_int(i)=Session.switches(1);
    elseif i == length(Session.switches)
        switch_int(i)=Session.switches(i)-Session.switches(i-1);
    else
        switch_int(i)=Session.switches(i+1)-Session.switches(i);
    end
end
DayInfo.avg_trials_switch = mean(switch_int);

%chech to see if there have been at least 75 trials since last switch if
%not then dont count the percent correct in the last block for the average
%percent correct per block
if length(Session.switches)>0
    if Session.total_trials-Session.switches(end)<75
        DayInfo.avg_percor_block = mean(Session.percent_switches(1:end-1));
    else
        DayInfo.avg_percor_block = mean(Session.percent_switches);
    end
end
DayInfo.avg_time_trial = mean(TrialInf(:,3));

% save_file = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\DataPerDay\';
% save_file = strcat(save_file,int2str(animal));
% mkdir(save_file)
% save_file = strcat(save_file,strcat('\',date));
% save(save_file,'DayInfo');

end