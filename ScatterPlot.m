function [fig] = ScatterPlot(animal_num, date,TrialInf,conds)
%funtion to get scatter plot of times per trial set conds to 0 if you want
%only different colors for corrct vs incorrect, place 1 if you want
%different colors for each condition


zero = [2 4 6 8]; ninety = [1 3 5 7]; twelve = [10 12 14 16]; seveight = [9 11 13 15];

%---------SCATTER PLOT-----------------
clear i;clear p

correct = find(TrialInf(:,2)==1);
incorrect = find(TrialInf(:,2)==0);

checker = find(TrialInf(:,5)==1); 
nochecker = find(TrialInf(:,5)==0);

if conds == 0
    count = 1;
    fig = figure;xlabel('Trial'); ylabel('Time(s)');ylim([0 30])
    title(strcat('ID: ',int2str(animal_num), '  Date: ',date));
    hold on
    scatter(correct,TrialInf(correct,3),'c', 'Filled');
    scatter(incorrect,TrialInf(incorrect,3),'g', 'Filled');%lsline;
    xlim([0 length(TrialInf)]);
    
elseif conds == 1
    count = -1;
    fig = figure;xlabel('Trial'); ylabel('Time(s)');ylim([0 30])
    title(strcat('ID: ',int2str(animal_num), '  Date: ',date));
    hold on
    scatter(checker,TrialInf(checker,3),'c', 'Filled');
    scatter(nochecker,TrialInf(nochecker,3),'g', 'Filled');%lsline;
    xlim([0 length(TrialInf)]);
    
if size(TrialInf,2) > 9 %there was photo stimulation trials
    count = count+1;
    
    stim_trials = find(TrialInf(:,10)==1);
    scatter(stim_trials,TrialInf(stim_trials,3),'r', 'Filled')
    
    
else 
    cond_0 = find(ismember(TrialInf(:,6),zero));
    cond_90 = find(ismember(TrialInf(:,6),ninety));
    cond_12 = find(ismember(TrialInf(:,6),twelve));
    cond_78 =  find(ismember(TrialInf(:,6),seveight));
    
    
    fig = figure;xlabel('Trial'); ylabel('Time(s)');ylim([0 30])
    title(strcat('ID: ',int2str(animal_num), '  Date: ',date));
    hold on
    scatter(cond_0,TrialInf(cond_0,3),'c', 'Filled');
    scatter(cond_90,TrialInf(cond_90,3),'g', 'Filled');
    scatter(cond_12,TrialInf(cond_12,3),'b', 'Filled')
    scatter(cond_78,TrialInf(cond_78,3),'r', 'Filled')
    lsline
        
    legend('0 deg', '90 deg', 'Angle 1', 'Angle 2')
    hold off
    xlim([0 length(TrialInf)]);


    
end

if count == 1 %only correct and incorrec trial times were plotted
legend('Correct', 'Incorrect')
elseif count == -1 % only checker no checker trial times were plotted 
    legend('Checker', 'No Checker')
elseif count == 2 % correct, incorrect and photo stim 
    legend('Correct', 'Incorrect', 'Photo Stimulation');
elseif count == 0
    legend('Checker', 'No Checker', 'Photo Stimulation');
end 
hold off



end