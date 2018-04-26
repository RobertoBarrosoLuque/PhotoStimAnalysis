addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code')
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\General Fuctions')
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\sync-master')
addpath('\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Roberto\Matlab Code\Downloaded Function')

%script to calculate and compare the performance for multiuple days on
%stable performance experiments

animal = '\\research.files.med.harvard.edu\Neurobio\HarveyLab\Tier1\Charlotte\Behavior_Data_current\19';
sessions =  {'\23-Feb-2018';'\01-Mar-2018';'\02-Mar-2018';'\09-Mar-2018'};


% get average percent correct in photstim block per each condition
AVG = [];N = [];
for i = 1:size(sessions,1)
     [ dirL ] = dir(strcat(animal,sessions{i},'\'));
    load(strcat(animal,sessions{i},'\',dirL(end).name))
    
    sessions{i}
    
    filename = strcat(animal,sessions{i},'\session_1\sessionData');
    load(filename)
    [TrialInf] = TrialInformation(sessionData);
    
    stimInfo = sync.stimRecord;
    [stimInf,TrialInf,stimAreas] = StimInfo(sessionData, stimInfo, TrialInf);
    
    dif = diff(sessionData(4,:)); frame_switch = find(dif~=0)+1;trial_switch = sessionData(end,frame_switch);
%     [stimAvg, Normal]=PhotoStimBlockPlotEveryOther(TrialInf,trial_switch,stimAreas);
    [stimAvg]=PhotoStimBlockPlotInterleved(TrialInf,trial_switch,stimAreas);
    
    stimAreas
    if size(stimAvg,2)>3
        PPC = stimAvg(:,2);
        S1 = stimAvg(:,3);
        control = stimAvg(:,4);
        
        stimAvg(:,2) = control;
        stimAvg(:,3) = PPC;
        stimAvg(:,4) = S1;
        
        stimAvg = stimAvg(:,2:end);
    end
    AVG = [AVG;stimAvg];
    %     N = [N;Normal];
end
%%
AVG_Tot = nanmean(AVG);
% AVG_nostim = nanmean(N);

%calculate p values using bonferroni correction for multiple tests
[p,tbl,stats] = anova1(AVG,[],'off');[c,test_results] = multcompare(stats,'CType','bonferroni','Display','off');
P = c(:,6);
% P1 = anova1([N(1:length(AVG)) AVG(:,1)]);P2 = anova1(AVG); P3 = anova1([AVG(:,2) N(1:length(AVG))]);close all;%
% P = [P1 P2 P3];

errors = nanstd(AVG)/sqrt(length(AVG));

% errorNS = std(N)/sqrt(length(N));
% errors = [errors errorNS];

Avg_fig = figure;
B = barwitherr(errors,[AVG_Tot]);%[AVG_nostim AVG_Tot]);
hold on; ylim([0 1])% l=line([0  length(trial_switch)+1.5],[.5 .5]); set(l,'Color','k');
B.FaceColor = [0, 0.4470, 0.7410];%[0, 0.5, 0];
varargout=sigstar({[1 2],[1 3],[2 3]}, P); %,[1 3],[2 3]},[P P P]);
xticklabels({'No Stim','PPC', 'S1'})
ylabel('Fraction Correct');hold off
title('Average Performance 	CA21')
text(3.2,.95,strcat('N=',int2str(length(AVG))))
