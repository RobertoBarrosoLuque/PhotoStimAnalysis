%Script to get sumary of behavioral session Roberto Barroso-Luque
function [Session] = Session_summary_PhotoStim(date,animal,session_num)
%close all
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code')
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\General Fuctions')
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\sync-master')
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\Downloaded Function')

save = 1;
%input date in following format: day-month-year
%input animal number
%Input session number
%Input 1 if using personal computer else input 0
day = date; animal_num = animal;

folder = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Charlotte\Behavior_Data_current\';
file = strcat(folder, int2str(animal_num),'\',day,'\session_' , int2str(session_num));

[ dirL ] = dir(strcat(folder, int2str(animal_num),'\',day));

load(strcat(folder, int2str(animal_num),'\',day,'\',dirL(end).name))

file_name = strcat(file, '\sessionData');
load(file_name);

%%
stimInfo = sync.stimRecord;

%Time stored in row 10 by intraframe interval
Session.Total_time = sum(sessionData(10,:))/60; %time in minutes
%trial number stored in row 11
Session.total_trials = sessionData(end,length(sessionData));
Session.num_rewards = sum(sessionData(9,:));
Session.total_percent_correct = Session.num_rewards/Session.total_trials;
%result is in ul check giveReward_stepperMotor for correct conversion
Session.rewards_given = Session.num_rewards*4.3;

%Lick Information stored in lickInfo array 1 for lick 0 for no lick
figure; plot(sessionData(7,:));title('Raw lick data')
lickInfo = sessionData(7,:)>1;
sessionData(7,:) = lickInfo;

Session.condone_trials = 0;Session.condtwo_trials = 0;Session.condthree_trials = 0;
Session.condfour_trials = 0;Session.condfive_trials = 0;Session.condsix_trials = 0;
Session.condseven_trials = 0;Session.condeight_trials = 0;


[TrialInf] = TrialInformation(sessionData);
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
indx_change = find(trial_change==1)+1; indx_change = [1 indx_change];
indx_rewards = find(sessionData(9,:)==1); indx_rewards = [1 indx_rewards];
%%


%Check that sync stim record has the same size as the stims in sessionData
%if not probably last or first in sync should be disregarded
if size(find(TrialInf(:,10)==1),1) ~= size(stimInfo,2)
    fprintf('WARNING: sync.stimRecord not same size as sessionData stim')
    %sizes are differenc so check fist and last in sync plot photDiode
    plot(sync.ch(:,1))
    startVirmen = find(sync.ch(:,2)>.5,1);
    startPhotoDiode = find(sync.ch(:,1)>.5,1);
    
    %if photodiode started before virmen then ignore fist stim record
    if startPhotoDiode<startVirmen
        stimInfo = stimInfo(2:end);
        fprintf('WARNING: sync.stimRecord started before Virmen. Ignoring first stimRecord entry...')
    elseif startPhotoDiode>startVirmen
        stimInfo = stimInfo(1:end-1);
        fprintf('WARNING: sync.stimRecord has extra entry after stim Blocks. Ignoring last stimRecord entry...')
    else 
        fprintf('WARNING: sync.stimRecord and sessionData DISPARITY IN STIM TRIALS!!!')
    end
    
end






%inititate  arrays for comulative percentages
correct_trials = TrialInf(:,2);
clear n;
Session.cumulative_percent = sum(correct_trials)/Session.total_trials;

%in case sync/stimInfo strucutre is empty because of matlab error
if isempty(stimInfo) %should only go in in cases of sync error
    stimframes = find(sessionData(11,:)==1);
    stimtrials = unique(sessionData(end,stimframes));
    
    TrialInf11 = zeros(length(TrialInf),1);
    TrialInf11(stimtrials) = 1;
    
    TrialInf(:,11) = TrialInf11;
    
    stimAreas = {sync.stimRecord.info.targetName};
    
else  %This is the appropriate manner to find stim trials
    
    %get cell with same information as TrialInf plus Stimulation info added
    [stimInf,TrialInf,stimAreas] = StimInfo(sessionData, stimInfo, TrialInf);
end

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

dif = diff(sessionData(4,:)); frame_switch = find(dif~=0)+1;trial_switch = sessionData(end,frame_switch);
frame_switch = [1 trial_switch]; Session.switches = frame_switch;
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

% lickInfo = zeros(length(sessionData),1);
licks = find(sessionData(7,:)>4);
lickInfo(licks) = 1;

%%
%Block Analysis check to see sync object has the same number of stim trials as virmen matrix
[BlockInf] =  BlockInfo(TrialInf, trial_switch,0);

%Use this for experiments where multiple stim areas are targeted in
%interleved trials during stim block
%[PhotoStimFig,Avg_fig]=PhotoStimBlockPlotEveryOther(TrialInf,trial_switch,stimAreas);

[PhotoStimFig,Avg_fig,stimAvg]=PhotoStimBlockPlotInterleved(TrialInf,trial_switch,stimAreas);


%Use this for experiments where only one stim area was targeted
%consistently through out stim blocks (ACC experiment)
%[PhotoStimFig,Avg_fig]=PhotoStimBlockPlotACC(TrialInf,trial_switch,stimAreas);
%P = mtit(strcat('ID: ',int2str(animal_num), '  Date: ',date));





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

[conv_performance] = Convolve(correct_trials,5,7);

IMG4 = figure;
% [percent, interval]=PercentCorrectInterval_RBL(2,correct_trials);
% plot(1:length(correct_trials)-1,percent);ylabel(strcat('Window Size:',int2str(interval)))
% xlabel('Trial #');xlim([1 length(correct_trials)])
% hold on

plot(conv_performance,'r'); xlabel('trial'); ylabel('Convolved Performance')
hold on
for i=1:length(TrialInf)
    
    if ismember(i,Session.switches) ==1
        p = line([i i], [0 1]);
        set(p, 'Color','k')
    elseif TrialInf(i,10)==1 %stim trial
        p = line([i i], [0 1]);
        set(p, 'Color',[0,0.7,0.9])
    end
end
P = mtit(strcat('ID: ',int2str(animal_num), '  Date: ',date));
hold off




[IMG5,xdisp_avg,ydisp_avg] = motionAnalysis_PhotoStim(sessionData,TrialInf);
P = mtit(strcat('ID: ',int2str(animal_num), '  Date: ',date));

%Time Scatter Plots
[IMG6] = TimePlots(TrialInf,stimAreas);
P = mtit(strcat('ID: ',int2str(animal_num), '  Date: ',date));

avg_time = mean(TrialInf(:,3));
med_time = median(TrialInf(:,3));
Session.AvgTimeTrial = avg_time;
Session.MedianTimeTrial = med_time;

%-----------------Lick Plots---------------------------------------------
lickplot = figure;
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
%
if length(Session.switches) ~= 0
    [PerfSwitch,~,~,~,~]=SwitchPerf(20,40, sessionData);
    
    
    %UNCOMMENT FOR STIM AFTER SWITCH EXPERIMENTS
%     
%     [PerfSwitch]=SwitchPerfPhotoStim(20,50, TrialInf,trial_switch,1);
%     [PhotoStimFig,~,~]= PerformanceAfterSwitch(TrialInf,trial_switch,40,stimAreas,1);
%     P = mtit(strcat('ID: ',int2str(animal_num), '  Date: ',date));
end

%[h_ch,B_ch,dev_ch,stats_ch,h_rw,b_glm,dev_glm,stats_glm] = MLogReg(TrialInf);
%figure;
% subplot(2,1,1)
%errorbar(B_ch(2:9),stats_ch.se(2:9),'ro');xlim([0 8]); xlabel('Pased choices');ylabel('Beta')
%hold on
%errorbar(b_glm(2:9),stats_glm.se(2:9),'ko');xlim([0 8]);; xlabel('Reward History');ylabel('Beta')
%hold off

% subplot(2,1,2)
% errorbar(b_glm(2:9),stats_glm.se(2:9),'ko');xlim([0 8]);; xlabel('Reward History');ylabel('Beta')

Session
%%
if save == 1
    save_file = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\FiguresPhotoStim\';
    save_file = strcat(save_file,date,strcat('\',int2str(animal)));
    mkdir(save_file) %create new folder
    %     saveas(IMG1,strcat(save_file, '\session_',int2str(session_num),'_Blocks'),'png');
    saveas(IMG2,strcat(save_file, '\session_',int2str(session_num),'_lineplot'),'png');
    saveas(IMG4,strcat(save_file, '\session_',int2str(session_num),'_percorinterval'),'png');
    saveas(IMG5,strcat(save_file, '\session_',int2str(session_num),'_movement'),'png');
    saveas(IMG6,strcat(save_file, '\session_',int2str(session_num),'_Timescatter'),'png');
    saveas(PerfSwitch,strcat(save_file, '\session_',int2str(session_num),'_PerfSwitch'),'png')
    saveas(PhotoStimFig,strcat(save_file, '\session_',int2str(session_num),'_blocksPH'),'png');    saveas(Avg_fig,strcat(save_file, '\session_',int2str(session_num),'AVG_blocks'),'png');
    
    %saveas(Avg_fig,strcat(save_file, '\session_',int2str(session_num),'_AvgPH'),'png');
    
    %saveas(lickplot,strcat(save_file, '\session_',int2str(session_num),'_lick'),'png');
end

%[DayInfo] = DayComp(date,animal,TrialInf, Session);

TrialInf;
end