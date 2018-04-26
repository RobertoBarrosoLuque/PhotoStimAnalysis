%Script to get sumarry of behavioral session Roberto Barroso-Luque
function [Session] = Session_summary_VertvsHorz(date,animal,session_num)
%close all
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier2\Roberto\Matlab Code\Compare Days')
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\General Fuctions')


save = 1;
%input date in following format: day-month-year
%input animal number
%Input session number
%Input 1 if using personal computer else input 0
%\\research.files.med.harvard.edu\Neurobio\HarveyLab\Charlotte\Behavior_Data\1\22-Aug-2017\session_1
day = date; animal_num = animal;

addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier2\Roberto\Matlab Code\Compare Days');


%file =  strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Charlotte\Behavior_Data\', int2str(animal_num),'\',day);
file = strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Charlotte\Behavior_Data_current\', int2str(animal_num),'\',day,'\session_' , int2str(session_num));


%file = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Charlotte\Behavior_Data\2\21-Aug-2017';
file_name = strcat(file, '\sessionData');
load(file_name);


%%

%Time stored in row 10 by intraframe interval
Session.Total_time = sum(sessionData(10,:))/60; %time in minutes
%trial number stored in row 11
Session.total_trials = sessionData(end,length(sessionData));
Session.num_rewards = sum(sessionData(9,:));
Session.total_percent_correct = Session.num_rewards/Session.total_trials;
%result is in ul check giveReward_stepperMotor for correct conversion
Session.rewards_given = Session.num_rewards*3.2;

%Lick Information stored in lickInfo array 1 for lick 0 for no lick
figure; plot(sessionData(7,:));title('Raw lick data')
lickInfo = sessionData(7,:)>1;
sessionData(7,:) = lickInfo;

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

[TrialInf] = TrialInformation(sessionData);

%get number of rewarded trials per each condition
reward_one = 0; reward_two = 0; reward_three = 0; reward_four = 0;
reward_five = 0; reward_six = 0; reward_seven = 0; reward_eight = 0;
reward_checker = 0; reward_nochecker = 0;
total_rewards = 0;
for j = indx_rewards
    total_rewards = total_rewards+1;
    if sessionData(1,j)==1                          %checker right Block l
        reward_one = reward_one +1;
        reward_checker = reward_checker+1;
    elseif sessionData(1,j) ==2                     %checker left Block 1
        reward_two = reward_two +1;
        reward_checker = reward_checker+1;
    elseif sessionData(1,j) ==3                     %checker left Block 2
        reward_three = reward_three +1;
        reward_checker = reward_checker+1;
    elseif sessionData(1,j) ==4                     %checker right Block 2
        reward_four = reward_four +1;
        reward_checker = reward_checker+1;
    elseif sessionData(1,j) ==5                     %grating right Block 1
        reward_five = reward_five +1;
        reward_nochecker = reward_nochecker+1;
    elseif sessionData(1,j) ==6                     %grating left Block 1
        reward_six = reward_six +1;
        reward_nochecker = reward_nochecker+1;
    elseif sessionData(1,j) ==7                     %grating left Block 2
        reward_seven = reward_seven +1;
        reward_nochecker = reward_nochecker+1;
    elseif sessionData(1,j) ==8                     %grating right Block 2
        reward_eight = reward_eight +1;
        reward_nochecker = reward_nochecker+1;
    end
end
clear j;

%calculate percent correct in checker trials vs nonchecker trials
Session.checker_correct = reward_checker/checker;
Session.nochecker_correct = reward_nochecker/no_checker;
Session.one_percent_correct = reward_one/Session.condone_trials;
Session.two_percent_correct = reward_two/Session.condtwo_trials;
Session.three_percent_correct = reward_three/Session.condthree_trials;
Session.four_percent_correct = reward_four/Session.condfour_trials;
Session.five_percent_correct = reward_five/Session.condfive_trials;
Session.six_percent_correct = reward_six/Session.condsix_trials;
Session.seven_percent_correct = reward_seven/Session.condseven_trials;
Session.eight_percent_correct = reward_eight/Session.condeight_trials;

%-----------------------------------------------------------------------------------------------------

dif = diff(sessionData(4,:)); frame_switch = find(dif~=0); frame_switch = [1 frame_switch];
trial_switch = []; cumulative_blocks = {};per_correct_block = [];
jj = 0;


%%


% %in case switch trials were not recorded-----------------------------------
% clear n
% nn=0; frames = zeros(1,length(sessionData(1,:)));
% for n =1:length(sessionData(end,:))
%     if sessionData(1,n)== 1 || sessionData(1,n)== 2 || sessionData(1,n)== 5 || sessionData(1,n)== 6
%         frames(1,n)=1;
%         sessionData(4,n) = 1;
%     else
%         frames(1,n) =2;
%         sessionData(4,n) = 2;
%     end
% end
% clear n
% dif = diff(frames); frame_switch = find(dif~=0); frame_switch= [1 frame_switch];
% trial_switch = [];
%

% %---------------------------------------------------------------------------
%




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
    
end
trial_switch=trial_switch+1;
clear k;trial_switch=trial_switch(2:length(trial_switch));
Session.switches = [trial_switch];
colors = ['k','b','g','r','c', 'y'];


lickInfo = zeros(length(sessionData),1);
licks = find(sessionData(7,:)>4);
lickInfo(licks) = 1;

%%
%Block Analysis
per_correct_block=[];

clear n; i = 0;
if isempty(trial_switch)~=1
    for n = [1 trial_switch]
        i = i+1;
        if n == 1 %first block
            start = 1;
            endd = trial_switch(i);
        elseif n == trial_switch(end)%last block
            start = trial_switch(end);
            endd = TrialInf(end,1);
        else %blocks in between
            start = n;
            endd = trial_switch(i);
        end
        
        correct = find(TrialInf(start:endd,2)==1);
        per_current = length(correct)/length(start:endd);
        
        per_correct_block=[per_correct_block;per_current];
    end
    
    
    
    IMG1 = figure;
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 7.25, 9.125], 'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125])
    subplot(3,1,1);
    bar([1:length(trial_switch)+1],per_correct_block);xlabel('Blocks');ylabel('Percent Correct')
    set(gca,'Xtick', [1:i]);C = mtit(strcat('ID: ',int2str(animal_num), '  Date: ',date));
    hold off
    
    if length(trial_switch)>=1
        [BlockInf] = BlockInfo(TrialInf, trial_switch,0);
    end
end
% Line Plot
[IMG2] = lineplot(TrialInf, trial_switch);



% IMG3 = figure;
% subplot(3,1,1);plot(Session.cumulative_percent, 'r');
% xlabel('Trial #'); ylabel('Cum % Correct');
% hold on
% for i= Session.switches
%     p = line([i i], [0 1]);
%     set(p, 'Color', 'k')
% end
% clear i;
% hold off

IMG4 = figure;
conv_perf = Convolve(TrialInf(:,2),5,10);
plot(conv_perf); ylim([0 1])
xlabel('Trial #');
hold on
for i= Session.switches
    p = line([i i], [0 1]);
    set(p, 'Color', 'k')
end
P = mtit(strcat('ID: ',int2str(animal_num), '  Date: ',date));
hold off


[IMG5,xdisp_avg,ydisp_avg] = motionAnalysis_RvsL(sessionData,TrialInf);
 P = mtit(strcat('ID: ',int2str(animal_num), '  Date: ',date));

%Time Scatter Plots
[IMG6] = ScatterPlot(animal_num, date,TrialInf,1);

avg_time = mean(TrialInf(:,3));
med_time = median(TrialInf(:,3));
Session.AvgTimeTrial = avg_time;
Session.MedianTimeTrial = med_time;

%-----------------Lick Plots---------------------------------------------
figure;
title('# of licks per trial')
bar(TrialInf(:,1),TrialInf(:,7)); hold on
ylimit = max(TrialInf(:,7))+10;ylim([0 ylimit]); xlim([0 TrialInf(end,1)])
correct = find(TrialInf(:,2)==1);
incorrect = find(TrialInf(:,2)==0);
for i= Session.switches
    p = line([i i], [0 ylimit]);
    set(p, 'Color', 'k')
end
scatter(correct,zeros(length(correct),1),'c','Filled')
scatter(incorrect,zeros(length(incorrect),1),'r','Filled')
hold off

if length(Session.switches) ~= 0
    [IMG7,rand,avg_percent,raw_average,conv_average]=SwitchPerf(20,40, sessionData);
end

%[B_ch,dev_ch,stats_ch,b_glm,dev_glm,stats_glm] = MLogReg(TrialInf);
%figure;
% subplot(2,1,1)
% errorbar(B_ch(2:9),stats_ch.se(2:9),'ro');xlim([0 8]); xlabel('Pased choices');ylabel('Beta')
% hold on
% errorbar(b_glm(2:9),stats_glm.se(2:9),'ko');xlim([0 8]);; xlabel('Reward History');ylabel('Beta')
% hold off

% subplot(2,1,2)
% errorbar(b_glm(2:9),stats_glm.se(2:9),'ko');xlim([0 8]);; xlabel('Reward History');ylabel('Beta')

Session
%%
if save == 1
    save_file = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\Figures\';
    save_file = strcat(save_file,date,strcat('\',int2str(animal)));
    mkdir(save_file) %create new folder
    saveas(IMG1,strcat(save_file, '\session_',int2str(session_num),'_Blocks'),'png');
    saveas(IMG2,strcat(save_file, '\session_',int2str(session_num),'_lineplot'),'png');
    saveas(IMG4,strcat(save_file, '\session_',int2str(session_num),'_percorinterval'),'png');
    saveas(IMG5,strcat(save_file, '\session_',int2str(session_num),'_movement'),'png');
    saveas(IMG6,strcat(save_file, '\session_',int2str(session_num),'_scatter'),'png');
    %    saveas(IMG7,strcat(save_file, '\session_',int2str(session_num),'_lick'),'png');
end

%[DayInfo] = DayComp(date,animal,TrialInf, Session);

end