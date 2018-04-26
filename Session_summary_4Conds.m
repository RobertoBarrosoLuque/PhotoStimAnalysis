%Script to get sumarry of behavioral session Roberto Barroso-Luque
function [Session] = Session_summary_4Conds(date,animal,session_num)
save = 1;
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier2\Roberto\Matlab Code\Compare Days')
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier2\Roberto\Matlab Code\General Fuctions')

%input date in following format: day-month-year
%input animal number
%Input session number
%Input 1 if using personal computer else input 0
%\\research.files.med.harvard.edu\Neurobio\HarveyLab\Charlotte\Behavior_Data\1\22-Aug-2017\session_1
day = date; animal_num = animal;

%file =  strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Charlotte\Behavior_Data\', int2str(animal_num),'\',day);
file = strcat('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Charlotte\Behavior_Data_current\', int2str(animal_num),'\',day,'\session_' , int2str(session_num));

    
%file = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Charlotte\Behavior_Data\2\21-Aug-2017';
file_name = strcat(file, '\sessionData');
load(file_name);


%%



%Time stored in row 10 by intraframe interval
Session.Total_time = sum(sessionData(10,:))/60;
%trial number stored in row 11
Session.total_trials = sessionData(end,length(sessionData));
Session.num_rewards = sum(sessionData(9,:));
Session.total_percent_correct = Session.num_rewards/Session.total_trials;
%result is in ul check giveReward_stepperMotor for correct conversion
Session.rewards_given = Session.num_rewards*3.2;


Session.condone_trials = 0;Session.condtwo_trials = 0;Session.condthree_trials = 0;
Session.condfour_trials = 0;Session.condfive_trials = 0;Session.condsix_trials = 0;
Session.condseven_trials = 0;Session.condeight_trials = 0;

Session.condCRang1_trials = 0; Session.condCLang2_trials = 0; Session.condCLang1_trials = 0;
Session.condCRang2_trials = 0; Session.condGRang1_trials = 0; Session.condGLang2_trials = 0;
Session.condGLang1_trials = 0;Session.condGRang2_trials = 0;
%get the total number of trials per each condition

figure; plot(sessionData(7,:));title('Raw lick data')



%%



checker = 0; no_checker = 0;
%get total number of trials checker and total no checker 1-4 are checker
%trials, 5-8 are no checker
for i=1:length(sessionData)-1
    trial = sessionData(end, i);
    if sessionData(1,i) == 1 && sessionData(end,i+1)~=trial      %checker right 90
        Session.condone_trials = Session.condone_trials +1;
        checker = checker + 1;
    elseif sessionData(1,i) == 2 && sessionData(end,i+1)~=trial  %checker left 0
        Session.condtwo_trials = Session.condtwo_trials +1;
        checker = checker + 1;
    elseif sessionData(1,i) == 3 && sessionData(end,i+1)~=trial  %checker left 90
        Session.condthree_trials = Session.condthree_trials +1;
        checker = checker + 1;
    elseif sessionData(1,i) == 4 && sessionData(end,i+1)~=trial  %checker right 0
        Session.condfour_trials = Session.condfour_trials +1;
        checker = checker + 1;
    elseif sessionData(1,i) == 5 && sessionData(end,i+1)~=trial  %grating right 90
        Session.condfive_trials = Session.condfive_trials +1;
        no_checker = no_checker +1;
    elseif sessionData(1,i) == 6 && sessionData(end,i+1)~=trial  %grating left 0
        Session.condsix_trials = Session.condsix_trials +1;
        no_checker = no_checker +1;
    elseif sessionData(1,i) == 7 && sessionData(end,i+1)~=trial  %grating left 90
        Session.condseven_trials = Session.condseven_trials +1;
        no_checker = no_checker +1;
    elseif sessionData(1,i) == 8 && sessionData(end,i+1)~=trial  %grating right 0
        Session.condeight_trials = Session.condeight_trials +1;
        no_checker = no_checker +1;
        
        %---------------------------ang2 VS ang1 DEGREES ----------------------
    elseif sessionData(1,i) == 9 && sessionData(end,i+1)~=trial      %checker right ang1
        Session.condCRang1_trials = Session.condCRang1_trials +1;
        checker = checker + 1;
    elseif sessionData(1,i) == 10 && sessionData(end,i+1)~=trial  %checker left ang2
        Session.condCLang2_trials = Session.condCLang2_trials +1;
        checker = checker + 1;
    elseif sessionData(1,i) == 11 && sessionData(end,i+1)~=trial  %checker left ang1
        Session.condCLang1_trials = Session.condCLang1_trials +1;
        checker = checker + 1;
    elseif sessionData(1,i) == 12 && sessionData(end,i+1)~=trial  %checker right ang2
        Session.condCRang2_trials = Session.condCRang2_trials +1;
        checker = checker + 1;
    elseif sessionData(1,i) == 13 && sessionData(end,i+1)~=trial  %grating right ang1
        Session.condGRang1_trials =  Session.condGRang1_trials +1;
        no_checker = no_checker +1;
    elseif sessionData(1,i) == 14 && sessionData(end,i+1)~=trial  %grating left ang2
        Session.condGLang2_trials = Session.condGLang2_trials +1;
        no_checker = no_checker +1;
    elseif sessionData(1,i) == 15 && sessionData(end,i+1)~=trial  %grating left ang1
        Session.condGLang1_trials = Session.condGLang1_trials +1;
        no_checker = no_checker +1;
    elseif sessionData(1,i) == 16 && sessionData(end,i+1)~=trial  %grating right ang2
        Session.condGRang2_trials = Session.condGRang2_trials +1;
        no_checker = no_checker +1;
        
    end
    
    if sessionData(7,i) > 1
        sessionData(7,i) = 1;   %1 for lick
    else
        sessionData(7,i) = 0;   %0 for no lick
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

[TrialInf,jR,jL] = TrialInfo(sessionData);

%get number of rewarded trials per each condition
reward_one = 0; reward_two = 0; reward_three = 0; reward_four = 0;
reward_five = 0; reward_six = 0; reward_seven = 0; reward_eight = 0;
reward_checker = 0; reward_nochecker = 0;

reward_CRang1 = 0;reward_CLang2= 0;reward_CLang1 = 0;reward_CRang2 = 0;
reward_GRang1 = 0;reward_GLang2 = 0;reward_GLang1 = 0;reward_GRang2 = 0;
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
        
        %------------------------------------------------------------------------
    elseif sessionData(1,j) == 9      %checker right ang1
        reward_CRang1 = reward_CRang1 +1;
        checker = checker + 1;
    elseif sessionData(1,j) == 10  %checker left ang2
        reward_CLang2 = reward_CLang2 +1;
        checker = checker + 1;
    elseif sessionData(1,j) == 11   %checker left ang1
        reward_CLang1 = reward_CLang1 +1;
        checker = checker + 1;
    elseif sessionData(1,j) == 12 %checker right ang2
         reward_CRang2 = reward_CRang2 +1;
        checker = checker + 1;
    elseif sessionData(1,j) == 13  %grating right ang1
         reward_GRang1 = reward_GRang1 +1;
        no_checker = no_checker +1;
    elseif sessionData(1,j) == 14  %grating left ang2
         reward_GLang2 = reward_GLang2 +1;
        no_checker = no_checker +1;
    elseif sessionData(1,j) == 15   %grating left ang1
         reward_GLang1 = reward_GLang1 +1;
        no_checker = no_checker +1;
    elseif sessionData(1,j) == 16   %grating right ang2
         reward_GRang2 = reward_GRang2 +1;
        no_checker = no_checker +1;
       
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

Session.CRang1_percent_correct = reward_CRang1/Session.condCRang1_trials;%checker right ang1
Session.CLang2_percent_correct = reward_CLang2/Session.condCLang2_trials;%checker left ang2
Session.CLang1_percent_correct = reward_CLang1/Session.condCLang1_trials;%checker left ang1
Session.CRang2_percent_correct = reward_CRang2/Session.condCRang2_trials;%checker right ang2
Session.GRang1_percent_correct = reward_GRang1/Session.condGRang1_trials;%grating right ang1
Session.GLang2_percent_correct = reward_GLang2/Session.condGLang2_trials;%grating left ang2
Session.GLang1_percent_correct = reward_GLang1/Session.condGLang1_trials;%grating left ang1
Session.GRang2_percent_correct = reward_GRang2/Session.condGRang2_trials;%grating right ang2
%-----------------------------------------------------------------------------------------------------


%%



dif = diff(sessionData(4,:)); frame_switch = find(dif~=0); frame_switch = [1 frame_switch];
trial_switch = []; cumulative_blocks = {};per_correct_block = [];
jj = 0;





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
    per_current = sum(current_block)/length(trchange);
    per_correct_block = [per_correct_block; per_current];
    
end
clear k;trial_switch=trial_switch(2:length(trial_switch));
Session.switches = [trial_switch];Session.percent_switches = per_correct_block;
colors = ['k','b','g','r','c', 'y', [0 .5 .6], [1 .2 8]];




%% 




%Block Analysis 
IMG1 = figure;set(gcf, 'Units', 'Inches', 'Position', [0, 0, 12, 12], 'PaperUnits', 'Inches', 'PaperSize', [7.25, 9.125])
subplot(2,2,1);
bar(1,per_correct_block(1), 'k'); ylabel('Percent Correct');
xlabel('Switch Block');hold on
for n=2:length(per_correct_block)
    bar(n,per_correct_block(n), colors(n));
end
set(gca,'Xtick', [1:n]);C = mtit(strcat('ID: ',int2str(animal_num), '  Date: ',date));
hold off

if length(trial_switch)~=0
    [BlockInf] = BlockInfo(TrialInf, trial_switch,1);
    
    %Line plotsif length(trial_switch)>1
    [IMG2] = lineplot(TrialInf, trial_switch);
    [IMG3] =CompConds(TrialInf, trial_switch);
    fig1 = mtit(strcat('ID: ',int2str(animal_num), '  Date: ',date));
    
end


fig = mtit(strcat('ID: ',int2str(animal_num), '  Date: ',date));


%%
%---------------------Plot Figures-----------------------------------------


%Percent Correct Plots

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
subplot(2,1,1)
[percent, interval]=PercentCorrectInterval_RBL(2,correct_trials);
plot(1:length(correct_trials)-1,percent);ylabel(strcat('Window Size:',int2str(interval)))
xlabel('Trial #');xlim([1 length(correct_trials)])
hold on
for i= Session.switches
    p = line([i i], [0 1]);
    set(p, 'Color', 'k')
end
hold off

subplot(2,1,2);
for i= 1:size(cumulative_blocks,2)
    plot(cumulative_blocks{1,i},colors(i));
    %     colormap(f,summer)
    hold on
end
xlabel('Trial #');ylabel('Percent Correct');
hold off

% Ploting displacement for all trials, when correct decision was left, when
% correct decision was to the right
% figure
% subplot(2,1,1)
% [~,~] = motionAnalysis(sessionData,0,jR,jL,TrialInf);
% subplot(2,1,2)
% [~,~] = motionAnalysis(sessionData,1,jR,jL,TrialInf);
% hold on
% [~,~] = motionAnalysis(sessionData,2,jR,jL,TrialInf);
hold off
IMG5 = figure;
[~,~] = motionAnalysis_RvsL(sessionData,3,jR,jL,TrialInf);
P = mtit(strcat('ID: ',int2str(animal_num), '  Date: ',date));

%---------SCATTER PLOT-----------------
[IMG6] = ScatterPlot(animal_num, date,TrialInf,1);
% subplot(2,1,1); ScatterPlot(animal_num, date,TrialInf,0)ScatterPlot(animal_num, date,TrialInf,1);


%-----------------Lick Plots---------------------------------------------
IMG7 = figure;
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
%--------------------------------------------------------------------------
avg_time = mean(TrialInf(:,3));
med_time = median(TrialInf(:,3));
Session.AvgTimeTrial = avg_time;
Session.MedianTimeTrial = med_time;



[avg_percent,conv_RewardperTrial,raw_average,conv_average]=SwitchPerf(20,40, sessionData);

subplot(2,1,1)
plot([-20:39],avg_percent,'k');hold on
p = plot([-20:39],conv_RewardperTrial); set(p,'Color',[.6 .6 .6]); hold off
legend('Average Performance (window = 2)', 'Convoluted');legend('Location', 'northoutside');

subplot(2,1,2)
plot([-20:39],raw_average,'k');hold on
p = plot([-20:39],conv_average);set(p,'Color',[.6 .6 .6]); hold off
legend('Average Performance Raw Data', 'Convoluted');legend('Location', 'northoutside');




%%


if save == 1
    save_file = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\BehaviorTraining\Figures\';
    save_file = strcat(save_file,date,strcat('\',int2str(animal)));
    mkdir(save_file) %create new folder
    saveas(IMG1,strcat(save_file, '\session_',int2str(session_num),'_Blocks'),'png');
    if length(trial_switch)~=0
        saveas(IMG2,strcat(save_file, '\session_',int2str(session_num),'_lineplot'),'png');
    end
    saveas(IMG4,strcat(save_file, '\session_',int2str(session_num),'_percorinterval'),'png');
    saveas(IMG5,strcat(save_file, '\session_',int2str(session_num),'_movement'),'png');
    saveas(IMG6,strcat(save_file, '\session_',int2str(session_num),'_scatter'),'png');
    %saveas(IMG7,strcat(save_file, '\session_',int2str(session_num),'_lick'),'png');
end
end

