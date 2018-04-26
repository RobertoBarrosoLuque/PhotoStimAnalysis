function [Session,TrialInf,sessionData] = GetSession(animal,day)
% day = date; animal_num = animal;
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier2\Roberto\Matlab Code\General Fuctions\');
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier2\Roberto\Matlab Code\Downloaded Function');

% file = strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Charlotte\Behavior_Data_current\', int2str(animal_num),'\',day,'\session_' , int2str(session_num));
%     
% %file = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Charlotte\Behavior_Data\2\21-Aug-2017';
% file_name = strcat(file, '\sessionData');

file_name = strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Charlotte\Behavior_Data_current\');
file_name = strcat(file_name,int2str(animal),'\',day);

[ dirList ] = get_directory_names(file_name);

%check to see if multiple sessions were made 

if size(dirList,1) ==1   
    load(strcat(file_name,'\session_1\','sessionData'))  
else 
    %if there is more than 1 session load sessionData with most trials
    first =  strcat(file_name,'\',dirList{1});
    [ dir1 ] = dir(first);
    for i = 1:size(dirList,1)
        current_file = strcat(file_name,'\',dirList{i});
        [ dir2 ] = dir(current_file);
        if size(dir2,1)>=size(dir1,1)
            session = i;
        end 
        current_file = strcat(file_name,'\',dirList{i});
        [ dir1 ] = dir(current_file);
    end
    
    load(strcat(file_name,'\session_',int2str(session),'\','sessionData'))    
end 


[TrialInf,jR,jL,jC,jG] = TrialInfo(sessionData);
%%


%Time stored in row 10 by intraframe interval
Session.Total_time = sum(sessionData(10,:))/60; %time in minutes

%trial number stored in row 11
Session.total_trials = sessionData(end,length(sessionData));
Session.num_rewards = sum(sessionData(9,:));
Session.total_percent_correct = Session.num_rewards/Session.total_trials;
%result is in ul check giveReward_stepperMotor for correct conversion
Session.rewards_given = Session.num_rewards*3.2;

Session.condone_trials = 0;Session.condtwo_trials = 0;Session.condthree_trials = 0;
Session.condfour_trials = 0;Session.condfive_trials = 0;Session.condsix_trials = 0;
Session.condseven_trials = 0;Session.condeight_trials = 0;
%get the total number of trials per each condition


%%
checker = 0; no_checker = 0;
%get total number of trials checker and total no checker 1-4 are checker
%trials, 5-8 are no checker
for i=1:length(sessionData)-1
    trial = sessionData(end, i);
    if sessionData(1,i) == 1 && sessionData(end,i+1)~=trial      %checker right Block l
        Session.condone_trials = Session.condone_trials +1;
        checker = checker + 1; 
    elseif sessionData(1,i) == 2 && sessionData(end,i+1)~=trial  %checker left Block 1
        Session.condtwo_trials = Session.condtwo_trials +1;
        checker = checker + 1;
    elseif sessionData(1,i) == 3 && sessionData(end,i+1)~=trial  %checker left Block 2
        Session.condthree_trials = Session.condthree_trials +1;
        checker = checker + 1;
    elseif sessionData(1,i) == 4 && sessionData(end,i+1)~=trial  %checker right Block 2
        Session.condfour_trials = Session.condfour_trials +1;
        checker = checker + 1;
    elseif sessionData(1,i) == 5 && sessionData(end,i+1)~=trial  %grating right Block 1
        Session.condfive_trials = Session.condfive_trials +1;
        no_checker = no_checker +1;
    elseif sessionData(1,i) == 6 && sessionData(end,i+1)~=trial  %grating left Block 1
        Session.condsix_trials = Session.condsix_trials +1;
        no_checker = no_checker +1;
    elseif sessionData(1,i) == 7 && sessionData(end,i+1)~=trial  %grating left Block 2
        Session.condseven_trials = Session.condseven_trials +1;
        no_checker = no_checker +1;
    elseif sessionData(1,i) == 8 && sessionData(end,i+1)~=trial  %grating right Block 2
        Session.condeight_trials = Session.condeight_trials +1;
        no_checker = no_checker +1;
    end
    
end
clear i;

%get indices when trial changes
trial_change = diff(sessionData(end,:));
indx_change = find(trial_change==1); %indx_change = [1 indx_change];
indx_rewards = find(sessionData(9,:)==1); indx_rewards = [1 indx_rewards];

%%
%inititate  arrays for comulative percentages
correct_trials = zeros(1,Session.total_trials); cum_correct_trials = [];
%make array for correct and incorrect trials
for n = 1:length(indx_change)
    if any(indx_change(n)==indx_rewards) == 1
        correct_trials(n) = 1; % one for correct trial
    end
    per = sum(correct_trials)/n;
    cum_correct_trials(n) = per;
end
clear n;
Session.cumulative_percent = cum_correct_trials;

dif = diff(sessionData(4,:)); frame_switch = find(dif~=0); frame_switch = [1 frame_switch];
trial_switch = []; cumulative_blocks = {};per_correct_block = [];
jj = 0;

for k= frame_switch
    jj = jj+1;
    trial_switch(jj) = [sessionData(end,frame_switch(jj))];
    if k ~= frame_switch(length(frame_switch))
        start = k; endd = frame_switch(jj+1);
    else
        start = k; endd = length(sessionData);
    end
    current_block = [];
    
    %get percent correct per each frame block & get cumulative percent
    %correct per each frame switch trial_change = diff(sessionData(end,:));
    trchange = diff(sessionData(end,start:endd));
    trchange = find(trchange==1);
    
    if k ~= frame_switch(1)
        trchange = trchange +  start-1;
    end
    rewarded_current = intersect(trchange,indx_rewards); %rewarded trials in current block
    
    xx = 0;current_block = zeros(1,length(trchange));
    cum_correct = [];
    for x= trchange
        xx = xx + 1;
        if any(trchange(xx)==rewarded_current) == 1
            current_block(xx) = 1; % one for correct trial
        end
        percent = sum(current_block)/xx;
        cum_correct(xx) = percent;
    end
    cumulative_blocks{jj} =  cum_correct;
    per_current = sum(current_block)/length(trchange);
    per_correct_block = [per_correct_block; per_current];
    
end
clear k;trial_switch=trial_switch(2:length(trial_switch));
Session.switches = [trial_switch];Session.percent_switches = per_correct_block;

end 